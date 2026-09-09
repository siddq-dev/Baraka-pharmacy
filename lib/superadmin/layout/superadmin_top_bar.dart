import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import '../theme/admin_colors.dart';

class SuperAdminTopBar extends StatelessWidget {
  const SuperAdminTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentLocation = GoRouterState.of(context).uri.path;

    final String pageTitle = _getPageTitle(currentLocation);

    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AdminColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pageTitle,
                  style: const TextStyle(
                    color: AdminColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  'Manage your pharmacy operations',
                  style: TextStyle(
                    color: AdminColors.textSecondary,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          _buildSearch(),

          const SizedBox(width: 14),

          _buildNotificationButton(context),

          const SizedBox(width: 18),

          _buildProfile(),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return SizedBox(
      width: 260,
      height: 40,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: const TextStyle(
            color: AdminColors.textSecondary,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 19,
            color: AdminColors.textSecondary,
          ),
          filled: true,
          fillColor: AdminColors.background,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: AdminColors.primary,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          tooltip: 'Notifications',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notifications will be connected later.'),
              ),
            );
          },
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: AdminColors.textPrimary,
            size: 23,
          ),
        ),

        Positioned(
          right: 8,
          top: 7,
          child: Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AdminColors.danger,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfile() {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AdminColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              'SA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Super Admin',
              style: TextStyle(
                color: AdminColors.textPrimary,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 2),

            Text(
              'Administrator',
              style: TextStyle(
                color: AdminColors.textSecondary,
                fontSize: 10.5,
              ),
            ),
          ],
        ),

        const SizedBox(width: 6),

        const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AdminColors.textSecondary,
          size: 20,
        ),
      ],
    );
  }

  String _getPageTitle(String location) {
    if (location == AppRoutes.superAdminDashboard) {
      return 'Dashboard';
    }

    if (location == AppRoutes.superAdminManagement) {
      return 'Admin Management';
    }

    if (location == AppRoutes.superAdminProductManagement) {
      return 'Product Management';
    }

    if (location == AppRoutes.superAdminInventory) {
      return 'Inventory';
    }

    if (location == AppRoutes.superAdminOrders) {
      return 'Orders';
    }

    if (location == AppRoutes.superAdminCustomers) {
      return 'Customers';
    }

    if (location == AppRoutes.superAdminDoctorManagement) {
      return 'Doctor Management';
    }

    if (location == AppRoutes.superAdminDeliveryPartners) {
      return 'Delivery Partners';
    }

    if (location == AppRoutes.superAdminAnalytics) {
      return 'Analytics';
    }

    if (location == AppRoutes.superAdminSettings) {
      return 'Settings';
    }

    return 'Super Admin';
  }
}
