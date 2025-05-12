import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reminder_app/services/auth_service.dart';
import 'package:reminder_app/utils/router.dart';
import 'package:toastification/toastification.dart';

class LoginState extends ChangeNotifier {
  final AuthService _authService;
  final formKey = GlobalKey<FormState>();
  StreamSubscription<User?>? _authStateSubscription;

  LoginState(this._authService) {
    // Listen to auth state changes
    _authStateSubscription = _authService.authStateChanges.listen((user) {
      debugPrint('Auth state changed: ${user?.email}');
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  String? _email;
  String? get email => _email;

  String? _password;
  String? get password => _password;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void onEmailChanged(String value) {
    _email = value;
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    _password = value;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> handleLogin(BuildContext context) async {
    // Validate form fields
    if (!formKey.currentState!.validate()) return;

    // Trim email and validate it's not empty
    final trimmedEmail = _email?.trim();
    if (trimmedEmail == null || trimmedEmail.isEmpty) {
      _showErrorToast(context, 'Please enter a valid email');
      return;
    }

    // Validate password is not empty
    if (_password == null || _password!.isEmpty) {
      _showErrorToast(context, 'Please enter a password');
      return;
    }

    _setLoading(true);

    try {
      // Attempt to sign in with detailed logging
      debugPrint('Attempting to sign in with email: $trimmedEmail');

      final credential = await _authService.signInWithEmailAndPassword(
        trimmedEmail,
        _password!,
      );

      // Log the user object details
      final user = credential.user;
      debugPrint('User signed in: ${user?.email}');
      debugPrint('User UID: ${user?.uid}');

      // Verify current user is set
      final currentUser = _authService.currentUser;
      debugPrint('AuthService current user: ${currentUser?.email}');

      if (user != null && context.mounted) {
        // Show success message
        toastification.show(
          context: context,
          type: ToastificationType.success,
          title: const Text('Success'),
          description: const Text('Logged in successfully'),
          autoCloseDuration: const Duration(seconds: 2),
        );

        // Navigate to home page
        GoRouter.of(context).go(RouteName.home);
      } else {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Unable to retrieve user after authentication',
        );
      }
    } catch (e) {
      // Detailed error handling and logging
      debugPrint('Login error: $e');

      if (context.mounted) {
        String errorMessage = 'An unexpected error occurred';

        if (e is FirebaseAuthException) {
          debugPrint('Firebase Auth Error Code: ${e.code}');

          switch (e.code) {
            case 'user-not-found':
              errorMessage = 'No user found with this email.';
              break;
            case 'wrong-password':
              errorMessage = 'Incorrect password. Please try again.';
              break;
            case 'invalid-email':
              errorMessage = 'The email address is not valid.';
              break;
            case 'user-disabled':
              errorMessage = 'This user account has been disabled.';
              break;
            case 'too-many-requests':
              errorMessage = 'Too many login attempts. Please try again later.';
              break;
            default:
              errorMessage = e.message ?? 'Login failed. Please try again.';
          }
        }

        // Show error toast
        _showErrorToast(context, errorMessage);
      }
    } finally {
      if (context.mounted) {
        _setLoading(false);
      }
    }
  }

  void _showErrorToast(BuildContext context, String message) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      title: const Text('Login Failed'),
      description: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  void handleSignUp(BuildContext context) {
    GoRouter.of(context).go(RouteName.signUp);
  }

  // Other methods remain the same...
}
