import 'package:go_router/go_router.dart';

// Customer screens
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/home/home_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/profile/edit_profile_screen.dart';
import '../features/orders/orders_screen.dart';
import '../features/profile/wishlist_page.dart';
import '../features/profile/settings_screen.dart';
import '../features/profile/help_support_screen.dart';
import '../features/cart/cart_screen.dart';

// Super Admin screens
import '../superadmin/admins/admin_management_screen.dart';
import '../superadmin/analytics/analytics_screen.dart';
import '../superadmin/customers/customers_screen.dart';
import '../superadmin/dashboard/superadmin_dashboard_screen.dart';
import '../superadmin/delivery/delivery_partners_screen.dart';
import '../superadmin/doctors/doctor_management_screen.dart';
import '../superadmin/inventory/inventory_screen.dart';
import '../superadmin/layout/superadmin_shell.dart';
import '../superadmin/orders/admin_orders_screen.dart';
import '../superadmin/products/product_management_screen.dart';
import '../superadmin/settings/admin_settings_screen.dart';

// Admin screens
import '../admin/admin_dashboard_screen.dart';

// Doctor screens
import '../doctor/doctor_dashboard_screen.dart';

// Delivery screens
import '../delivery/delivery_dashboard_screen.dart';

class AppRoutes {
  // ============================================================
  // CUSTOMER ROUTES
  // ============================================================

  static const String splash = '/';

  static const String login = '/login';

  static const String register = '/register';

  static const String home = '/home';

  static const String profile = '/profile';

  static const String editProfile = '/profile/edit';

  static const String orders = '/orders';

  static const String wishlist = '/profile/wishlist';

  static const String settings = '/profile/settings';

  static const String helpsupport = '/profile/help-support';

  static const String cart = '/cart';

  // ============================================================
  // SUPER ADMIN ROUTES
  // ============================================================

  static const String superAdminDashboard = '/superadmin';

  static const String superAdminManagement = '/superadmin/admin-management';

  static const String superAdminProductManagement =
      '/superadmin/product-management';

  static const String superAdminInventory = '/superadmin/inventory';

  static const String superAdminOrders = '/superadmin/orders';

  static const String superAdminCustomers = '/superadmin/customers';

  static const String superAdminDoctorManagement =
      '/superadmin/doctor-management';

  static const String superAdminDeliveryPartners =
      '/superadmin/delivery-partners';

  static const String superAdminAnalytics = '/superadmin/analytics';

  static const String superAdminSettings = '/superadmin/settings';

  // ============================================================
  // OTHER ROLE ROUTES (placeholders until real dashboards exist)
  // ============================================================

  static const String admin = '/admin';

  static const String doctor = '/doctor';

  static const String delivery = '/delivery';

  // ============================================================
  // ROUTER
  // ============================================================

  static final GoRouter router = GoRouter(
    initialLocation: splash,

    routes: [
      // ========================================================
      // CUSTOMER APP
      // ========================================================
      GoRoute(
        path: splash,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      GoRoute(
        path: login,
        builder: (context, state) {
          return const LoginScreen();
        },
      ),

      GoRoute(
        path: register,
        builder: (context, state) {
          return const RegisterScreen();
        },
      ),

      GoRoute(
        path: home,
        builder: (context, state) {
          return const HomeScreen();
        },
      ),

      GoRoute(
        path: profile,
        builder: (context, state) {
          return const ProfileScreen();
        },
      ),

      GoRoute(
        path: editProfile,
        builder: (context, state) {
          return const EditProfileScreen();
        },
      ),

      GoRoute(
        path: orders,
        builder: (context, state) {
          return const OrdersScreen();
        },
      ),

      GoRoute(
        path: wishlist,
        builder: (context, state) {
          return const WishlistScreen();
        },
      ),

      GoRoute(
        path: settings,
        builder: (context, state) {
          return const SettingsScreen();
        },
      ),

      GoRoute(
        path: helpsupport,
        builder: (context, state) {
          return const HelpSupportScreen();
        },
      ),

      GoRoute(
        path: cart,
        builder: (context, state) {
          return const CartScreen();
        },
      ),

      // ========================================================
      // SUPER ADMIN APP
      // ========================================================
      ShellRoute(
        builder: (context, state, child) {
          return SuperAdminShell(child: child);
        },

        routes: [
          // Dashboard
          GoRoute(
            path: superAdminDashboard,
            builder: (context, state) {
              return const SuperAdminDashboardScreen();
            },
          ),

          // Admin Management
          GoRoute(
            path: superAdminManagement,
            builder: (context, state) {
              return const AdminManagementScreen();
            },
          ),

          // Product Management
          GoRoute(
            path: superAdminProductManagement,
            builder: (context, state) {
              return const ProductManagementScreen();
            },
          ),

          // Inventory
          GoRoute(
            path: superAdminInventory,
            builder: (context, state) {
              return const InventoryScreen();
            },
          ),

          // Orders
          GoRoute(
            path: superAdminOrders,
            builder: (context, state) {
              return const AdminOrdersScreen();
            },
          ),

          // Customers
          GoRoute(
            path: superAdminCustomers,
            builder: (context, state) {
              return const CustomersScreen();
            },
          ),

          // Doctor Management
          GoRoute(
            path: superAdminDoctorManagement,
            builder: (context, state) {
              return const DoctorManagementScreen();
            },
          ),

          // Delivery Partners
          GoRoute(
            path: superAdminDeliveryPartners,
            builder: (context, state) {
              return const DeliveryPartnersScreen();
            },
          ),

          // Analytics
          GoRoute(
            path: superAdminAnalytics,
            builder: (context, state) {
              return const AnalyticsScreen();
            },
          ),

          // Settings
          GoRoute(
            path: superAdminSettings,
            builder: (context, state) {
              return const AdminSettingsScreen();
            },
          ),
        ],
      ),

      // ========================================================
      // ADMIN APP (placeholder — replace with real dashboard + shell)
      // ========================================================
      GoRoute(
        path: admin,
        builder: (context, state) {
          return const AdminDashboardScreen();
        },
      ),

      // ========================================================
      // DOCTOR APP (placeholder — replace with real dashboard + shell)
      // ========================================================
      GoRoute(
        path: doctor,
        builder: (context, state) {
          return const DoctorDashboardScreen();
        },
      ),

      // ========================================================
      // DELIVERY APP (placeholder — replace with real dashboard + shell)
      // ========================================================
      GoRoute(
        path: delivery,
        builder: (context, state) {
          return const DeliveryDashboardScreen();
        },
      ),
    ],
  );
}
