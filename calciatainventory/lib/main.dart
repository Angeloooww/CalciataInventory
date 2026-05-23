import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase/firebase_options.dart';
import 'login_page.dart';
import 'admin/dashboard.dart';
import 'staff/staff_menu_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CalciataInventoryApp());
}

class CalciataInventoryApp extends StatelessWidget {
  const CalciataInventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeanStock – Calciata Inventory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF8B5E3C),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // ── Still connecting ──────────────────────────────────────────
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // ── Not logged in ─────────────────────────────────────────────
          if (!snapshot.hasData || snapshot.data == null) {
            return const LoginPage();
          }

          // ── Logged in — check role from Firestore ─────────────────────
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, roleSnap) {
              // Waiting for Firestore
              if (roleSnap.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              // No user doc or error — send back to login
              if (roleSnap.hasError ||
                  !roleSnap.hasData ||
                  !roleSnap.data!.exists) {
                FirebaseAuth.instance.signOut();
                return const LoginPage();
              }

              final role =
                  (roleSnap.data!.data() as Map<String, dynamic>?)?['role']
                      as String?;

              if (role == 'admin') {
                return const DashboardPage();
              } else if (role == 'staff') {
                return const StaffMenuPage();
              } else {
                // Unknown role — sign out and back to login
                FirebaseAuth.instance.signOut();
                return const LoginPage();
              }
            },
          );
        },
      ),
    );
  }
}