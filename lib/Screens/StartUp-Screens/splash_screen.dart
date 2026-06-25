import 'dart:async';
import 'package:flutter/material.dart';
import 'theme_config.dart';
import 'logo_widget.dart';
import 'constellation_background.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _activeDotIndex = 0;
  late Timer _dotTimer;
  late Timer _navTimer;

  @override
  void initState() {
    super.initState();

    // Cycle the loading dots
    _dotTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _activeDotIndex = (_activeDotIndex + 1) % 5;
        });
      }
    });

    // Navigate to onboarding screen after a delay
    _navTimer = Timer(const Duration(milliseconds: 3500), () {
      _navigateToOnboarding();
    });
  }

  void _navigateToOnboarding() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _dotTimer.cancel();
    _navTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = ThemeConfig.isDark(context);
    final textPrimary = ThemeConfig.getTextPrimary(context);
    final textSecondary = ThemeConfig.getTextSecondary(context);

    return Scaffold(
      body: GestureDetector(
        onTap: _navigateToOnboarding,
        child: ConstellationBackground(
          accentColor: ThemeConfig.blueAccent,
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 20),
                  // Logo at the top
                  const BitByteLogo(
                    size: 90,
                    showSubtitle: true,
                  ),

                  // Overlapping Team & Task Cards
                  SizedBox(
                    height: size.height * 0.38,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Left / Bottom: Team Card
                        Positioned(
                          left: size.width * 0.1,
                          child: Transform.rotate(
                            angle: -0.12, // slightly tilted anti-clockwise
                            child: _buildTeamCard(isDark, textPrimary, textSecondary),
                          ),
                        ),

                        // Right / Top: Tasks Card
                        Positioned(
                          right: size.width * 0.1,
                          top: size.height * 0.04,
                          child: Transform.rotate(
                            angle: 0.08, // slightly tilted clockwise
                            child: _buildTasksCard(isDark, textPrimary, textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Slogans, Dots and Loading indicators
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Subtitles
                      Text(
                        'Smart HR  |  Smarter Organization',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF00C6FF) : const Color(0xFF0072FF),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Smarter Results',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF00C6FF) : const Color(0xFF0072FF),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Loading Dot indicators (5 dots)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final isActive = index == _activeDotIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            height: 8,
                            width: isActive ? 10 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? (isDark ? const Color(0xFF00C6FF) : const Color(0xFF0072FF))
                                  : (isDark ? const Color(0xFF00C6FF) : const Color(0xFF0072FF)).withAlpha(76),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 12),

                      // Loading text
                      Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textSecondary.withAlpha(128),
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper to build the "Team" mockup card
  Widget _buildTeamCard(bool isDark, Color textPrimary, Color textSecondary) {
    return Container(
      width: 195,
      height: 240,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A1729) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E2E44) : const Color(0xFFE2E8F0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 102 : 25),
            blurRadius: 20,
            offset: const Offset(-5, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1F2F46) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.people_alt_rounded,
                  color: isDark ? const Color(0xFF00C6FF) : const Color(0xFF0072FF),
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Team',
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // User List
          _buildTeamMember(
            'Alex M.',
            'Designer',
            'Active',
            const Color(0xFF42A5F5),
            isDark,
            textPrimary,
            textSecondary,
          ),
          const SizedBox(height: 12),
          _buildTeamMember(
            'Sara K.',
            'Developer',
            'On Leave',
            const Color(0xFFAB47BC),
            isDark,
            textPrimary,
            textSecondary,
          ),
          const SizedBox(height: 12),
          _buildTeamMember(
            'John D.',
            'Manager',
            'Active',
            const Color(0xFF26A69A),
            isDark,
            textPrimary,
            textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(
    String name,
    String role,
    String status,
    Color avatarColor,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
  ) {
    final isActive = status == 'Active';
    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 15,
          backgroundColor: avatarColor.withAlpha(51),
          child: Icon(
            Icons.person,
            size: 16,
            color: avatarColor,
          ),
        ),
        const SizedBox(width: 8),
        // Name & Role
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
              Text(
                role,
                style: TextStyle(
                  color: textSecondary.withAlpha(153),
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
        // Status Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF00E676).withAlpha(25)
                : const Color(0xFFFFB300).withAlpha(25),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: isActive
                  ? (isDark ? const Color(0xFF00FF87) : const Color(0xFF00B876))
                  : const Color(0xFFFFB300),
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // Helper to build the "Tasks" mockup card
  Widget _buildTasksCard(bool isDark, Color textPrimary, Color textSecondary) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 195,
          height: 240,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF081424) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF1E2E44) : const Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 102 : 25),
                blurRadius: 20,
                offset: const Offset(5, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2D3F) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.task_alt_rounded,
                      color: isDark ? const Color(0xFF00FF87) : const Color(0xFF00B876),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tasks',
                    style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Circular Progress Ring Area
              Center(
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ring
                      CircularProgressIndicator(
                        value: 0.72,
                        strokeWidth: 6,
                        backgroundColor: isDark ? const Color(0xFF122336) : const Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark ? const Color(0xFF00C6FF) : const Color(0xFF0072FF),
                        ),
                      ),
                      // Text in center
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '72%',
                            style: TextStyle(
                              color: textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Done',
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tasks Checklist
              _buildTaskItem('Review reports', true, isDark, textPrimary, textSecondary),
              const SizedBox(height: 8),
              _buildTaskItem('Team sync', true, isDark, textPrimary, textSecondary),
              const SizedBox(height: 8),
              _buildTaskItem('Payroll run', false, isDark, textPrimary, textSecondary),
            ],
          ),
        ),

        // Glowing green checkmark badge at top-right
        Positioned(
          top: -12,
          right: -12,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? const Color(0xFF00FF87) : const Color(0xFF00B876),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? const Color(0xFF00FF87) : const Color(0xFF00B876)).withAlpha(128),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.check_rounded,
              color: isDark ? const Color(0xFF070D19) : Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskItem(
    String title,
    bool isCompleted,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Row(
      children: [
        Icon(
          isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          color: isCompleted
              ? (isDark ? const Color(0xFF00FF87) : const Color(0xFF00B876))
              : const Color(0xFF4FACFE),
          size: 14,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: isCompleted ? textPrimary : textSecondary.withAlpha(102),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
