import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

class BarakaPharmacyApp extends StatelessWidget {
  const BarakaPharmacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Baraka Pharmacy',

      theme: AppTheme.light,

      home: const Scaffold(
        body: Center(
          child: Text(
            'Baraka Pharmacy',
          ),
        ),
      ),
    );
  }
}