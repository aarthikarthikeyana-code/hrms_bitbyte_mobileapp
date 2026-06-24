import 'package:flutter/material.dart';
import 'package:hrms_mobileapp_bitbyte/main.dart';
import 'package:hrms_mobileapp_bitbyte/Screens/StartUp-Screens/theme_config.dart';
import 'package:hrms_mobileapp_bitbyte/Screens/StartUp-Screens/constellation_background.dart';
import 'package:hrms_mobileapp_bitbyte/Screens/Superadmin/Create_admins.dart';

class SuperAdminDashboard extends StatefulWidget {
  final String email;
  const SuperAdminDashboard({super.key, required this.email});

  @override
  State<SuperAdminDashboard> createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> _statsCards = [
    {'title': 'Total Employees', 'value': '0', 'icon': Icons.people_rounded, 'color': Color(0xFF4FACFE)},
    {'title': 'Present Today', 'value': '0', 'icon': Icons.check_circle_rounded, 'color': Color(0xFF43E97B)},
    {'title': 'On Leave', 'value': '0', 'icon': Icons.beach_access_rounded, 'color': Color(0xFFFA709A)},
    {'title': 'Pending Tasks', 'value': '0', 'icon': Icons.pending_actions_rounded, 'color': Color(0xFFF7971E)},
  ];

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.people_alt_rounded, 'label': 'Employees'},
    {'icon': Icons.calendar_today_rounded, 'label': 'Attendance'},
    {'icon': Icons.beach_access_rounded, 'label': 'Leave'},
    {'icon': Icons.payments_rounded, 'label': 'Payroll'},
    {'icon': Icons.settings_rounded, 'label': 'Settings'},
  ];

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MyApp()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeConfig.isDark(context);
    final textPrimary = ThemeConfig.getTextPrimary(context);
    final textSecondary = ThemeConfig.getTextSecondary(context);
    final cardBg = ThemeConfig.getCardBg(context);
    final cardBorder = ThemeConfig.getCardBorder(context);

    return Scaffold(
  key: _scaffoldKey,
  drawer: _buildDrawer(textPrimary, textSecondary, cardBg, isDark),
  body: ConstellationBackground(
        accentColor: ThemeConfig.blueAccent,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: ThemeConfig.blueGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GestureDetector(
  onTap: () => _scaffoldKey.currentState?.openDrawer(),
  child: const Icon(Icons.menu_rounded, color: Colors.white, size: 24),
),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Super Admin', style: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(widget.email, style: TextStyle(color: textSecondary, fontSize: 11)),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                        color: ThemeConfig.blueAccent,
                      ),
                      onPressed: () {
                        final currentMode = MyApp.themeNotifier.value;
                        MyApp.themeNotifier.value =
                            currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
                        setState(() {});
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                      onPressed: _logout,
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Overview', style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 14),

                      // Stats Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.4,
                        ),
                        itemCount: _statsCards.length,
                        itemBuilder: (context, index) {
                          final card = _statsCards[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: cardBorder, width: 1.2),
                              boxShadow: ThemeConfig.getPremiumShadow(context),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(card['icon'], color: card['color'], size: 28),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(card['value'], style: TextStyle(color: textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                                    Text(card['title'], style: TextStyle(color: textSecondary, fontSize: 11)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                      Text('Quick Actions', style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 14),

                      // Menu Items
                      ...List.generate(_menuItems.length, (index) {
                        final item = _menuItems[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: cardBorder, width: 1.2),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: ThemeConfig.blueGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(item['icon'], color: Colors.white, size: 20),
                            ),
                            title: Text(item['label'], style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
                            trailing: Icon(Icons.arrow_forward_ios_rounded, color: textSecondary, size: 14),
                            onTap: () {},
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
}

  Widget _buildDrawer(Color textPrimary, Color textSecondary, Color cardBg, bool isDark) {
    return Drawer(
      backgroundColor: cardBg,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: ThemeConfig.blueGradient),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 10),
                  const Text('Super Admin', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(widget.email, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.people_alt_rounded, color: ThemeConfig.blueAccent),
                    title: Text('Employees', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w500)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
  leading: Icon(Icons.person_add_rounded, color: ThemeConfig.blueAccent),
  title: Text('Create Admins', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w500)),
  onTap: () {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateAdminsPage()),
    );
  },
),
                  ListTile(
                    leading: Icon(Icons.calendar_today_rounded, color: ThemeConfig.blueAccent),
                    title: Text('Attendance', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w500)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.beach_access_rounded, color: ThemeConfig.blueAccent),
                    title: Text('Leave', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w500)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.payments_rounded, color: ThemeConfig.blueAccent),
                    title: Text('Payroll', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w500)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings_rounded, color: ThemeConfig.blueAccent),
                    title: Text('Settings', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w500)),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}