import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hrms_mobileapp_bitbyte/main.dart';
import 'package:hrms_mobileapp_bitbyte/Screens/StartUp-Screens/theme_config.dart';
import 'package:hrms_mobileapp_bitbyte/Screens/StartUp-Screens/constellation_background.dart';
import 'package:hrms_mobileapp_bitbyte/Screens/HR/register_employees.dart';

class HrDashboard extends StatefulWidget {
  final String email;
  final String firstName;
  final String userId;
  const HrDashboard({super.key, required this.email, required this.firstName, required this.userId});

  @override
  State<HrDashboard> createState() => _HrDashboardState();
}

class _HrDashboardState extends State<HrDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const Color _green = Color(0xFF43E97B);

  void _logout() => Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const MyApp()), (route) => false);

  void _openPage(Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeConfig.isDark(context);
    final textPrimary = ThemeConfig.getTextPrimary(context);
    final textSecondary = ThemeConfig.getTextSecondary(context);
    final cardBg = ThemeConfig.getCardBg(context);
    final cardBorder = ThemeConfig.getCardBorder(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(textPrimary, textSecondary, cardBg),
      body: ConstellationBackground(
        accentColor: _green,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(children: [
                  GestureDetector(
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(gradient: ThemeConfig.blueGradient, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.menu_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Welcome, ${widget.firstName}', style: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(widget.userId, style: const TextStyle(color: _green, fontSize: 11, fontWeight: FontWeight.w600)),
                  ]),
                  const Spacer(),
                  IconButton(
                    icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, color: ThemeConfig.blueAccent),
                    onPressed: () { MyApp.themeNotifier.value = MyApp.themeNotifier.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark; setState(() {}); },
                  ),
                  IconButton(icon: const Icon(Icons.logout_rounded, color: Colors.redAccent), onPressed: _logout),
                ]),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      width: double.infinity, padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(gradient: LinearGradient(colors: [_green, Color(0xFF38F9D7)]), borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: Row(children: [
                        const Icon(Icons.people_alt_rounded, color: Colors.white, size: 32),
                        const SizedBox(width: 12),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Human Resources', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          Text(widget.email, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                        ]),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    Text('HR Overview', style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 14),
                    GridView.count(
                      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.4,
                      children: [
                        _statCard('Total Staff', '0', Icons.people_rounded, _green, cardBg, cardBorder, textPrimary, textSecondary),
                        _statCard('New Joiners', '0', Icons.person_add_rounded, const Color(0xFF4FACFE), cardBg, cardBorder, textPrimary, textSecondary),
                        _statCard('On Leave', '0', Icons.beach_access_rounded, const Color(0xFFFA709A), cardBg, cardBorder, textPrimary, textSecondary),
                        _statCard('Pending Reg.', '0', Icons.pending_rounded, const Color(0xFFF7971E), cardBg, cardBorder, textPrimary, textSecondary),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('Quick Actions', style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 14),
                    _quickAction(Icons.person_add_alt_1_rounded, 'Register Employees', 'View employee registrations', _green, cardBg, cardBorder, textPrimary, textSecondary, () => _openPage(const RegisterEmployeesPage())),
                    _quickAction(Icons.calendar_today_rounded, 'Attendance', 'Manage attendance', const Color(0xFF4FACFE), cardBg, cardBorder, textPrimary, textSecondary, () {}),
                    _quickAction(Icons.beach_access_rounded, 'Leave Management', 'Approve/reject leaves', const Color(0xFFFA709A), cardBg, cardBorder, textPrimary, textSecondary, () {}),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color, Color cardBg, Color cardBorder, Color tp, Color ts) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: cardBorder, width: 1.2), boxShadow: ThemeConfig.getPremiumShadow(context)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(icon, color: color, size: 28),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(color: tp, fontSize: 22, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(color: ts, fontSize: 11)),
        ]),
      ]),
    );
  }

  Widget _quickAction(IconData icon, String title, String subtitle, Color color, Color cardBg, Color cardBorder, Color tp, Color ts, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14), border: Border.all(color: cardBorder, width: 1.2)),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withAlpha(80))),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(color: tp, fontSize: 14, fontWeight: FontWeight.w600)),
            Text(subtitle, style: TextStyle(color: ts, fontSize: 11)),
          ])),
          Icon(Icons.arrow_forward_ios_rounded, color: ts, size: 14),
        ]),
      ),
    );
  }

  Widget _buildDrawer(Color textPrimary, Color textSecondary, Color cardBg) {
    return Drawer(
      backgroundColor: cardBg,
      child: SafeArea(child: Column(children: [
        Container(
          width: double.infinity, padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [_green, Color(0xFF38F9D7)])),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const CircleAvatar(radius: 30, backgroundColor: Colors.white24, child: Icon(Icons.person_rounded, color: Colors.white, size: 32)),
            const SizedBox(height: 10),
            Text(widget.firstName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('HR', style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text(widget.userId, style: const TextStyle(color: Colors.white60, fontSize: 11)),
          ]),
        ),
        const SizedBox(height: 10),
        Expanded(child: ListView(children: [
          _drawerTile(Icons.dashboard_rounded, 'Dashboard', textPrimary, () => Navigator.pop(context)),
          _drawerTile(Icons.person_add_alt_1_rounded, 'Register Employees', textPrimary, () {
            Navigator.pop(context);
            _openPage(const RegisterEmployeesPage());
          }),
          _drawerTile(Icons.people_rounded, 'Employees', textPrimary, () => Navigator.pop(context)),
          _drawerTile(Icons.calendar_today_rounded, 'Attendance', textPrimary, () => Navigator.pop(context)),
          _drawerTile(Icons.beach_access_rounded, 'Leave', textPrimary, () => Navigator.pop(context)),
        ])),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
          title: const Text('Logout', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
          onTap: _logout,
        ),
      ])),
    );
  }

  ListTile _drawerTile(IconData icon, String label, Color textPrimary, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: _green),
      title: Text(label, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}