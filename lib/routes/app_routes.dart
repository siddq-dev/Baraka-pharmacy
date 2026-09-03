import 'package:go_router/go_router.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/home/home_screen.dart';
import '../features/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

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
    ],
  );
}
