// staff_dashboard_page.dart
// Login routes staff here — we immediately show StaffMenuPage (the first staff tab)
import 'package:flutter/material.dart';
import 'staff_menu_page.dart';

class StaffDashboardPage extends StatelessWidget {
  const StaffDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StaffMenuPage();
  }
}