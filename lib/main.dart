import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/add_product_provider.dart';
import 'providers/product_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),

        ChangeNotifierProvider<addProductProvider>(
          create: (_) => addProductProvider(),
        ),

        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider()..startListening(),
        ),
      ],
      child: const BarakaPharmacyApp(),
    ),
  );
}
