import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricLoginEnabled = false;
  bool _notificationsEnabled = true;

  void _onBiometricChanged(bool value) {
    setState(() {
      _biometricLoginEnabled = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value ? 'Biometric login enabled.' : 'Biometric login disabled.',
        ),
      ),
    );

    // Biometric authentication will be connected later.
    // The selected preference can later be stored using
    // SharedPreferences or Firebase/Firestore.
  }

  void _onNotificationsChanged(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value ? 'Notifications enabled.' : 'Notifications disabled.',
        ),
      ),
    );

    // Notification preferences will be connected later.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.brandBlue,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          children: [
            const Text(
              'Preferences',
              style: TextStyle(
                color: AppColors.brandBlue,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Manage your Barakaa Pharmacy app preferences.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),

            _buildSettingsTile(
              icon: Icons.fingerprint_rounded,
              title: 'Biometric Login',
              subtitle: 'Use fingerprint or Face ID to sign in quickly',
              trailing: Switch(
                value: _biometricLoginEnabled,
                onChanged: _onBiometricChanged,
                activeColor: AppColors.primary,
              ),
            ),

            _buildSettingsTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              subtitle: 'Receive order updates and important alerts',
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: _onNotificationsChanged,
                activeColor: AppColors.primary,
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('App'),

            const SizedBox(height: 12),

            _buildSettingsTile(
              icon: Icons.language_rounded,
              title: 'Language',
              subtitle: 'English',
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
              onTap: () {
                // Language selection will be added later.
              },
            ),

            _buildSettingsTile(
              icon: Icons.dark_mode_outlined,
              title: 'Appearance',
              subtitle: 'Light mode',
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
              onTap: () {
                // Theme selection will be added later.
              },
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('Security'),

            const SizedBox(height: 12),

            _buildSettingsTile(
              icon: Icons.lock_outline_rounded,
              title: 'Change Password',
              subtitle: 'Update your account password',
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
              onTap: () {
                // Change password screen will be added later.
              },
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('About'),

            const SizedBox(height: 12),

            _buildSettingsTile(
              icon: Icons.info_outline_rounded,
              title: 'About Barakaa Pharmacy',
              subtitle: 'App information and version',
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
              onTap: () {
                _showAboutDialog();
              },
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                'Barakaa Pharmacy',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 4),

            const Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: AppColors.primary, size: 23),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        trailing: trailing,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.brandBlue,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Barakaa Pharmacy',
            style: TextStyle(
              color: AppColors.brandBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'Your trusted pharmacy app for medicines, '
            'health products, orders, and more.\n\n'
            'Version 1.0.0',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
