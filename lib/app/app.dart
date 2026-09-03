import 'package:barakaa/routes/app_routes.dart';
import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

class BarakaPharmacyApp extends StatelessWidget {
  const BarakaPharmacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Barakaa Pharmacy',
      theme: AppTheme.light,
      routerConfig: AppRoutes.router,
    );
  }
}
