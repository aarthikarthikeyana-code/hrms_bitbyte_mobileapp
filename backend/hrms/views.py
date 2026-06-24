from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import LoginSerializer, CreateUserSerializer
from .models import User

@api_view(['POST'])
def login_view(request):
    serializer = LoginSerializer(data=request.data)
    if serializer.is_valid():
        email = serializer.validated_data['email']
        password = serializer.validated_data['password']
        try:
            user = User.objects.get(email=email)
            if user.check_password(password):
                return Response({
                    'success': True,
                    'role': user.role,
                    'email': user.email,
                    'first_name': user.first_name,
                    'user_id': user.user_id,
                })
            else:
                return Response({'success': False, 'message': 'Wrong password'}, status=400)
        except User.DoesNotExist:
            return Response({'success': False, 'message': 'User not found'}, status=404)
    return Response(serializer.errors, status=400)

@api_view(['POST'])
def create_user_view(request):
    serializer = CreateUserSerializer(data=request.data)
    if serializer.is_valid():
        data = serializer.validated_data
        if User.objects.filter(email=data['email']).exists():
            return Response({'success': False, 'message': 'Email already exists'}, status=400)
        user = User(
            email=data['email'],
            role=data['role'],
            first_name=data['first_name'],
            last_name=data['last_name'],
            country_code=data['country_code'],
            phone=data['phone'],
            gender=data['gender'],
            dob=data['dob'],
            door_no=data['door_no'],
            street=data['street'],
            pincode=data['pincode'],
            city=data['city'],
            state=data['state'],
            occupation=data['occupation'],
            pan=data['pan'],
            aadhar=data['aadhar'],
        )
        user.set_password(data['password'])
        user.save()
        return Response({'success': True, 'user_id': user.user_id, 'message': f'{data["role"].upper()} created!'})
    return Response({'success': False, 'errors': serializer.errors}, status=400)