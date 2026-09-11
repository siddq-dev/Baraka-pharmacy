import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import '../theme/admin_colors.dart';

class SuperAdminSidebar extends StatelessWidget {
  const SuperAdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentLocation = GoRouterState.of(context).uri.path;

    return Container(
      width: 260,
      color: AdminColors.sidebar,
      child: SafeArea(
        child: Column(
          children: [
            _buildBrand(),

            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionTitle('MAIN'),

                    _buildMenuItem(
                      context: context,
                      title: 'Dashboard',
                      icon: Icons.dashboard_outlined,
                      selectedIcon: Icons.dashboard,
                      route: AppRoutes.superAdminDashboard,
                      currentLocation: currentLocation,
                    ),

                    const SizedBox(height: 4),

                    _buildMenuItem(
                      context: context,
                      title: 'Admin Management',
                      icon: Icons.admin_panel_settings_outlined,
                      selectedIcon: Icons.admin_panel_settings,
                      route: AppRoutes.superAdminManagement,
                      currentLocation: currentLocation,
                    ),

                    _buildMenuItem(
                      context: context,
                      title: 'Product Management',
                      icon: Icons.inventory_2_outlined,
                      selectedIcon: Icons.inventory_2,
                      route: AppRoutes.superAdminProductManagement,
                      currentLocation: currentLocation,
                    ),

                    _buildMenuItem(
                      context: context,
                      title: 'Inventory',
                      icon: Icons.warehouse_outlined,
                      selectedIcon: Icons.warehouse,
                      route: AppRoutes.superAdminInventory,
                      currentLocation: currentLocation,
                    ),

                    _buildMenuItem(
                      context: context,
                      title: 'Orders',
                      icon: Icons.shopping_bag_outlined,
                      selectedIcon: Icons.shopping_bag,
                      route: AppRoutes.superAdminOrders,
                      currentLocation: currentLocation,
                    ),

                    _buildMenuItem(
                      context: context,
                      title: 'Customers',
                      icon: Icons.people_outline,
                      selectedIcon: Icons.people,
                      route: AppRoutes.superAdminCustomers,
                      currentLocation: currentLocation,
                    ),

                    _buildMenuItem(
                      context: context,
                      title: 'Doctor Management',
                      icon: Icons.medical_services_outlined,
                      selectedIcon: Icons.medical_services,
                      route: AppRoutes.superAdminDoctorManagement,
                      currentLocation: currentLocation,
                    ),

                    _buildMenuItem(
                      context: context,
                      title: 'Delivery Partners',
                      icon: Icons.delivery_dining_outlined,
                      selectedIcon: Icons.delivery_dining,
                      route: AppRoutes.superAdminDeliveryPartners,
                      currentLocation: currentLocation,
                    ),

                    const SizedBox(height: 20),

                    _buildSectionTitle('ANALYTICS'),

                    _buildMenuItem(
                      context: context,
                      title: 'Analytics',
                      icon: Icons.analytics_outlined,
                      selectedIcon: Icons.analytics,
                      route: AppRoutes.superAdminAnalytics,
                      currentLocation: currentLocation,
                    ),

                    const SizedBox(height: 20),

                    _buildSectionTitle('SYSTEM'),

                    _buildMenuItem(
                      context: context,
                      title: 'Settings',
                      icon: Icons.settings_outlined,
                      selectedIcon: Icons.settings,
                      route: AppRoutes.superAdminSettings,
                      currentLocation: currentLocation,
                    ),
                  ],
                ),
              ),
            ),

            _buildLogout(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBrand() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AdminColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_pharmacy,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BARAKAA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  'PHARMACY',
                  style: TextStyle(
                    color: AdminColors.textLight,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AdminColors.textLight,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required IconData selectedIcon,
    required String route,
    required String currentLocation,
  }) {
    final bool isSelected =
        currentLocation == route; // <-- exact match only, removed startsWith

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          if (!isSelected) {
            context.go(route);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AdminColors.sidebarSelected
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                size: 21,
                color: isSelected ? Colors.white : AdminColors.textLight,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AdminColors.textLight,
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
      child: Column(
        children: [
          Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),

          const SizedBox(height: 12),

          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                _showLogoutDialog(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 21,
                      color: AdminColors.textLight,
                    ),

                    SizedBox(width: 12),

                    Text(
                      'Logout',
                      style: TextStyle(
                        color: AdminColors.textLight,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout from the Super Admin panel?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Firebase logout will be connected later.'),
                  ),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
