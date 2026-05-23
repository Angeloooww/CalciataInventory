import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'role_service.dart';
import 'login_page.dart';
import 'admin/dashboard.dart';
import 'staff/staff_dashboard_page.dart';

/// Listens to Firebase auth state and routes to the correct screen.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Still connecting
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingScreen();
        }

        // Not signed in → show login
        if (!snapshot.hasData) {
          return const LoginPage();
        }

        // Signed in → resolve role, then route
        return _RoleRouter(uid: snapshot.data!.uid);
      },
    );
  }
}

class _RoleRouter extends StatefulWidget {
  const _RoleRouter({required this.uid});
  final String uid;

  @override
  State<_RoleRouter> createState() => _RoleRouterState();
}

class _RoleRouterState extends State<_RoleRouter> {
  UserRole? _role;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    try {
      final role = await RoleService.instance.fetchRole(widget.uid);
      if (mounted) setState(() => _role = role);
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return _ErrorScreen(
        onRetry: () {
          setState(() {
            _role = null;
            _error = false;
          });
          _resolve();
        },
      );
    }

    if (_role == null) return const _LoadingScreen();

    switch (_role!) {
      case UserRole.admin:
        return const DashboardPage();
      case UserRole.staff:
        return const StaffDashboardPage();
      case UserRole.unknown:
        return _UnauthorizedScreen();
    }
  }
}

// ── Loading ────────────────────────────────────────────────────────────────────

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0D0D0D),
      body: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Color(0xFFF5F0E8),
          ),
        ),
      ),
    );
  }
}

// ── Error ──────────────────────────────────────────────────────────────────────

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Could not verify your account.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry', style: TextStyle(color: Color(0xFFF5F0E8))),
            ),
            TextButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: Text('Sign out',
                  style: TextStyle(color: Colors.white.withOpacity(0.4))),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Unauthorized ───────────────────────────────────────────────────────────────

class _UnauthorizedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ACCESS DENIED',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 11,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your account has no assigned role.\nContact your administrator.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.35),
                fontSize: 13,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text(
                'SIGN OUT',
                style: TextStyle(
                  color: Color(0xFFF5F0E8),
                  fontSize: 11,
                  letterSpacing: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}