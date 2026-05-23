import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Roles supported by the app.
enum UserRole { admin, staff, unknown }

class RoleService {
  RoleService._();
  static final RoleService instance = RoleService._();

  final _db = FirebaseFirestore.instance;

  /// Fetch the role of the currently signed-in user.
  /// Firestore document path: users/{uid} → { role: "admin" | "staff" }
  Future<UserRole> fetchRole(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists) return UserRole.unknown;
      final role = doc.data()?['role'] as String?;
      switch (role) {
        case 'admin':
          return UserRole.admin;
        case 'staff':
          return UserRole.staff;
        default:
          return UserRole.unknown;
      }
    } catch (_) {
      return UserRole.unknown;
    }
  }

  /// Convenience: get role for the currently signed-in user.
  Future<UserRole> get currentUserRole async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return UserRole.unknown;
    return fetchRole(user.uid);
  }
}