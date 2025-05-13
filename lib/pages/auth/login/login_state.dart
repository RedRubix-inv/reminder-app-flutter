import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reminder_app/components/show_toast.dart';
import 'package:reminder_app/services/auth_service.dart';
import 'package:reminder_app/utils/router.dart';
import 'package:toastification/toastification.dart';

class LoginState extends ChangeNotifier {
  final AuthService _authService;
  final formKey = GlobalKey<FormState>();
  StreamSubscription<User?>? _authStateSubscription;

  LoginState(this._authService) {
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
      showToast(
        context,
        type: ToastificationType.error,
        title: "Invalid Input",
        description: "Please enter a valid email",
      );
      return;
    }

    // Validate password is not empty
    if (_password == null || _password!.isEmpty) {
      showToast(
        context,
        type: ToastificationType.error,
        title: "Invalid Input",
        description: "Please enter a password",
      );
      return;
    }

    _setLoading(true);

    try {
      final credential = await _authService.signInWithEmailAndPassword(
        trimmedEmail,
        _password!,
      );

      final user = credential.user;

      if (user != null && context.mounted) {
        // Show success message
        showToast(
          context,
          type: ToastificationType.success,
          title: "Success",
          description: "Logged in successfully",
          duration: const Duration(seconds: 3),
        );

        // Navigate to home page
        GoRouter.of(context).go(RouteName.home);
      } else {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Unable to retrieve user after authentication.',
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');

      if (context.mounted) {
        String title = "Login Failed";
        String errorMessage;

        if (e is String) {
          // This is the error message returned from AuthService._handleAuthException
          errorMessage = e;
        } else {
          errorMessage = e.toString();
        }

        showToast(
          context,
          type: ToastificationType.error,
          title: title,
          description: errorMessage,
          duration: const Duration(seconds: 6),
        );
      }
    } finally {
      if (context.mounted) {
        _setLoading(false);
      }
    }
  }

  void handleSignUp(BuildContext context) {
    GoRouter.of(context).go(RouteName.signUp);
  }
}
