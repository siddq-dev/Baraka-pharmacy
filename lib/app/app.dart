import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import '../features/splash/splash_screen.dart';

class BarakaPharmacyApp extends StatelessWidget {
  const BarakaPharmacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Barakaa Pharmacy',

      theme: AppTheme.light,

      home: const SplashScreen(),
    );
  }
}