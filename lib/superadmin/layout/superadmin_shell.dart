import 'package:flutter/material.dart';

import '../theme/admin_colors.dart';
import 'superadmin_sidebar.dart';
import 'superadmin_top_bar.dart';

class SuperAdminShell extends StatelessWidget {
  final Widget child;

  const SuperAdminShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      body: Row(
        children: [
          const SuperAdminSidebar(),

          Expanded(
            child: Column(
              children: [
                const SuperAdminTopBar(),

                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
