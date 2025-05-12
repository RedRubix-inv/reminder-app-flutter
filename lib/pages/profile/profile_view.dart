import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/pages/profile/profile_state.dart';
import 'package:reminder_app/services/auth_service.dart';
import 'package:reminder_app/utils/router.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileState(AuthService()),
      child: const _ProfileViewContent(),
    );
  }
}

class _ProfileViewContent extends StatelessWidget {
  const _ProfileViewContent();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileState>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header Section
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [primaryColor.withOpacity(0.8), backgroundColor],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child:
                              state.userPhotoUrl != null
                                  ? Image.network(
                                    state.userPhotoUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                              'assets/images/profile.png',
                                              fit: BoxFit.cover,
                                            ),
                                  )
                                  : Image.asset(
                                    'assets/images/profile.png',
                                    fit: BoxFit.cover,
                                  ),
                        ),
                      ),
                      const VerticalSpace(20),
                      Text(
                        state.userName ?? 'User',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontFamily: 'Sora',
                        ),
                      ),
                      const VerticalSpace(8),
                      Text(
                        state.userEmail ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: textColorSecondary,
                          fontFamily: 'Sora',
                        ),
                      ),
                    ],
                  ),
                ),
                // Content sections
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Current plan section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _buildSection(
                          title: 'Current plan',
                          items: [
                            _buildMenuItem(
                              icon: Icons.star_outline,
                              title: 'Test Page',
                              onTap: () {
                                GoRouter.of(context).push(RouteName.test);
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.star_outline,
                              title: 'Standard',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      const VerticalSpace(20),
                      // Account settings section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _buildSection(
                          title: 'Account settings',
                          items: [
                            _buildMenuItem(
                              icon: Icons.person_outline,
                              title: 'Personal Information',
                              onTap: () {},
                            ),
                            Divider(
                              color: primaryColor.withOpacity(0.1),
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                            ),
                            _buildMenuItem(
                              icon: Icons.payment_outlined,
                              title: 'Payment Methods',
                              onTap: () {},
                            ),
                            Divider(
                              color: primaryColor.withOpacity(0.1),
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                            ),
                            _buildMenuItem(
                              icon: CupertinoIcons.bell,
                              title: 'Notifications',
                              onTap: () {},
                            ),
                            Divider(
                              color: primaryColor.withOpacity(0.1),
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                            ),
                            _buildMenuItem(
                              icon: Icons.security_outlined,
                              title: 'Security',
                              onTap: () {},
                            ),
                            Divider(
                              color: primaryColor.withOpacity(0.1),
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                            ),
                            _buildMenuItem(
                              icon: Icons.language_outlined,
                              title: 'Language',
                              onTap: () {},
                            ),
                            Divider(
                              color: primaryColor.withOpacity(0.1),
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                            ),
                            _buildMenuItem(
                              icon: Icons.help_outline,
                              title: 'Help & Support',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      const VerticalSpace(20),
                      // Preferences section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _buildSection(
                          title: 'Preferences',
                          items: [
                            _buildMenuItem(
                              icon: Icons.dark_mode_outlined,
                              title: 'Dark Mode',
                              onTap: () {},
                            ),
                            Divider(
                              color: primaryColor.withOpacity(0.1),
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                            ),
                            _buildMenuItem(
                              icon: Icons.notifications_active_outlined,
                              title: 'Reminder Settings',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      const VerticalSpace(30),
                      // Sign out button
                      GestureDetector(
                        onTap: () => state.handleSignOut(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: errorColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.logout, color: errorColor),
                              const SizedBox(width: 8),
                              Text(
                                'Sign Out',
                                style: TextStyle(
                                  color: errorColor,
                                  fontFamily: "Sora",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Sora',
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: primaryColor),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontFamily: 'Sora',
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: textColorSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
