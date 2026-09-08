import 'package:go_router/go_router.dart';

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

class AppRoutes {
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

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
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
    ],
  );
}
