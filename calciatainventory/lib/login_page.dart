import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'admin/dashboard.dart';
import 'staff/staff_dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool    _isLoading       = false;
  bool    _obscurePassword = true;
  String? _errorMessage;
  String  _selectedRole    = 'staff'; // default selection

  // ── Coffee brand colors ──────────────────────────────────────────────────
  static const Color _coffeeBrown = Color(0xFFB07040);
  static const Color _cardGray    = Color(0xFFF0F0F0);
  static const Color _borderGray  = Color(0xFFCCCCCC);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Firebase sign-in + role verification ────────────────────────────────
  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading    = true;
      _errorMessage = null;
    });

    try {
      // 1. Authenticate with Firebase
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email:    _emailController.text.trim(),
        password: _passwordController.text,
      );

      // 2. Fetch role from Firestore
      final uid = credential.user!.uid;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!doc.exists) {
        await FirebaseAuth.instance.signOut();
        setState(() => _errorMessage =
            'Account not found in the system. Contact your administrator.');
        return;
      }

      final role = doc.data()?['role'] as String?;

      // 3. Verify selected role matches Firestore role
      if (role != _selectedRole) {
        await FirebaseAuth.instance.signOut();
        setState(() => _errorMessage =
            'This account is not registered as ${_selectedRole == 'admin' ? 'an Admin' : 'a Staff'}. Please select the correct role.');
        return;
      }

      if (!mounted) return;

      // 4. Navigate based on verified role
      if (role == 'admin') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardPage()),
        );
      } else if (role == 'staff') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const StaffDashboardPage()),
        );
      } else {
        await FirebaseAuth.instance.signOut();
        setState(() => _errorMessage =
            'Your account has no assigned role. Contact your administrator.');
      }

    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _friendlyError(e.code));
    } catch (e) {
      setState(() => _errorMessage = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _friendlyError(String code) {
    switch (code) {
      case 'user-not-found':    return 'No account found with that email.';
      case 'wrong-password':    return 'Incorrect password. Please try again.';
      case 'invalid-email':     return 'Please enter a valid email address.';
      case 'user-disabled':     return 'This account has been disabled.';
      case 'too-many-requests': return 'Too many attempts. Please wait and try again.';
      default:                  return 'Sign-in failed. Please check your credentials.';
    }
  }

  // ── Forgot password ──────────────────────────────────────────────────────
  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter your email first, then tap Forgot password.'),
        ),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reset link sent to $email')),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_friendlyError(e.code))),
      );
    }
  }

  // ── Role selector widget ─────────────────────────────────────────────────
  Widget _buildRoleSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderGray),
      ),
      child: Row(
        children: [
          _RoleButton(
            label: 'Admin',
            icon: Icons.admin_panel_settings_outlined,
            isSelected: _selectedRole == 'admin',
            onTap: () => setState(() {
              _selectedRole = 'admin';
              _errorMessage = null;
            }),
            activeColor: _coffeeBrown,
          ),
          _RoleButton(
            label: 'Staff',
            icon: Icons.badge_outlined,
            isSelected: _selectedRole == 'staff',
            onTap: () => setState(() {
              _selectedRole = 'staff';
              _errorMessage = null;
            }),
            activeColor: _coffeeBrown,
          ),
        ],
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 420,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 44),
            decoration: BoxDecoration(
              color: _cardGray,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ── Logo ────────────────────────────────────────────────
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: ClipRect(
                      child: OverflowBox(
                        maxWidth: 200,
                        maxHeight: 200,
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.coffee,
                            size: 120,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Headline ─────────────────────────────────────────────
                  const Text(
                    'Welcome to BeanStock!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please enter your email and password to access your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Role selector ────────────────────────────────────────
                  _buildRoleSelector(),
                  const SizedBox(height: 28),

                  // ── Email field ──────────────────────────────────────────
                  const _FieldLabel(text: 'Email'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    decoration: _inputDecoration('Enter your email'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Email is required';
                      if (!v.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // ── Password field ───────────────────────────────────────
                  const _FieldLabel(text: 'Password'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _signIn(),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    decoration: _inputDecoration('Enter your password').copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.black38,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password is required';
                      if (v.length < 6) return 'At least 6 characters';
                      return null;
                    },
                  ),

                  // ── Forgot password ──────────────────────────────────────
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _forgotPassword,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        foregroundColor: Colors.black54,
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // ── Error message ────────────────────────────────────────
                  if (_errorMessage != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                            color: Colors.red.shade700, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Sign-in button ───────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _coffeeBrown,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: _coffeeBrown.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Sign in as ${_selectedRole == 'admin' ? 'Admin' : 'Staff'}',
                            ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _borderGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _borderGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _coffeeBrown, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade300),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
      ),
    );
  }
}

// ── Role toggle button ───────────────────────────────────────────────────────
class _RoleButton extends StatelessWidget {
  const _RoleButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
  });

  final String   label;
  final IconData icon;
  final bool     isSelected;
  final VoidCallback onTap;
  final Color    activeColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : Colors.black45,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Field label helper ───────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}