import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/listing_provider.dart';
import '../../utils/app_colors.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final listingProvider = context.watch<ListingProvider>();
    final userProfile = authProvider.userProfile;
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primaryNavy,
                    child: Text(
                      (userProfile?.displayName ?? 'U')[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userProfile?.displayName ?? 'User',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            const Divider(indent: 16, endIndent: 16),

            // Notification toggle
            ListTile(
              leading: const Icon(Icons.notifications_outlined,
                  color: AppColors.primaryNavy),
              title: const Text('Location Notifications'),
              trailing: Switch.adaptive(
                value: listingProvider.locationNotifications,
                activeTrackColor: AppColors.accentAmber,
                onChanged: (value) {
                  listingProvider.toggleLocationNotifications(value);
                },
              ),
            ),
            const Divider(indent: 16, endIndent: 16),

            // About
            ListTile(
              leading: const Icon(Icons.info_outline,
                  color: AppColors.primaryNavy),
              title: const Text('About Kigali Connect'),
              subtitle: const Text('Version 1.0.0'),
              trailing: const Icon(Icons.chevron_right,
                  color: AppColors.textGrey),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Kigali Connect',
                  applicationVersion: '1.0.0',
                  children: [
                    const Text(
                        'A city services directory for Kigali, Rwanda.'),
                  ],
                );
              },
            ),
            const Divider(indent: 16, endIndent: 16),

            // Privacy Policy
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined,
                  color: AppColors.primaryNavy),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.chevron_right,
                  color: AppColors.textGrey),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon')),
                );
              },
            ),

            // Logout button
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        title: const Text('Log Out'),
                        content: const Text(
                            'Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel',
                                style:
                                    TextStyle(color: AppColors.textGrey)),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(ctx);
                              await authProvider.signOut();
                              if (!context.mounted) return;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const LoginScreen()),
                                (route) => false,
                              );
                            },
                            child: const Text('Log Out',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
