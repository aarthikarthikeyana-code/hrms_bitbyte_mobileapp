from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager

class UserManager(BaseUserManager):
    def create_user(self, email, password=None, role='employee'):
        user = self.model(email=email, role=role)
        user.set_password(password)
        user.save(using=self._db)
        return user

class User(AbstractBaseUser):
    ROLE_CHOICES = [
        ('superadmin', 'Super Admin'),
        ('ceo', 'CEO'),
        ('md', 'MD'),
        ('employee', 'Employee'),
    ]

    GENDER_CHOICES = [('male', 'Male'), ('female', 'Female'), ('other', 'Other')]

    # Basic
    email = models.EmailField(unique=True)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='employee')
    is_active = models.BooleanField(default=True)
    user_id = models.CharField(max_length=20, unique=True, blank=True)

    # Personal
    first_name = models.CharField(max_length=50, blank=True)
    last_name = models.CharField(max_length=50, blank=True)
    country_code = models.CharField(max_length=5, default='+91')
    phone = models.CharField(max_length=15, blank=True)
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES, blank=True)
    dob = models.DateField(null=True, blank=True)

    # Address
    door_no = models.CharField(max_length=20, blank=True)
    street = models.CharField(max_length=100, blank=True)
    pincode = models.CharField(max_length=10, blank=True)
    city = models.CharField(max_length=50, blank=True)
    state = models.CharField(max_length=50, blank=True)

    # Identity
    occupation = models.CharField(max_length=50, blank=True)
    pan = models.CharField(max_length=10, blank=True)
    aadhar = models.CharField(max_length=12, blank=True)

    USERNAME_FIELD = 'email'
    objects = UserManager()

    def save(self, *args, **kwargs):
        if not self.user_id:
            prefix = self.role.upper()[:2]
            count = User.objects.filter(role=self.role).count() + 1
            self.user_id = f'BB{self.role.upper()}{count:04d}'
        super().save(*args, **kwargs)

    def __str__(self):
        return self.email