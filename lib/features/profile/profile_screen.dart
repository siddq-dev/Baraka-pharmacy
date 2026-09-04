import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

import 'package:barakaa/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.brandBlue,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context),

              const SizedBox(height: 28),

              _buildSectionTitle('Account'),

              const SizedBox(height: 12),

              _buildProfileOption(
                icon: Icons.person_outline_rounded,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () {
                  context.push(AppRoutes.editProfile);
                },
              ),

              _buildProfileOption(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                subtitle: 'View your orders and order history',
                onTap: () {
                  // Orders screen will be connected later.
                },
              ),

              _buildProfileOption(
                icon: Icons.favorite_border_rounded,
                title: 'Wishlist',
                subtitle: 'View your saved medicines',
                onTap: () {
                  // Wishlist screen will be connected later.
                },
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('Support'),

              const SizedBox(height: 12),

              _buildProfileOption(
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'Manage your app preferences',
                onTap: () {
                  // Settings screen will be added later.
                },
              ),

              _buildProfileOption(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                subtitle: 'Get help with Barakaa Pharmacy',
                onTap: () {
                  // Help & Support screen will be added later.
                },
              ),

              const SizedBox(height: 24),

              _buildLogoutButton(),

              const SizedBox(height: 20),

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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.12),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.18),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 48,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Abual',
            style: TextStyle(
              color: AppColors.brandBlue,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'abual@example.com',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),

          const SizedBox(height: 16),

          OutlinedButton.icon(
            onPressed: () {
              context.push(AppRoutes.editProfile);
            },
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text(
              'Edit Profile',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            ),
          ),
        ],
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

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
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
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          // Firebase logout will be connected later.
        },
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text(
          'Logout',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: BorderSide(color: Colors.red.withOpacity(0.35)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
