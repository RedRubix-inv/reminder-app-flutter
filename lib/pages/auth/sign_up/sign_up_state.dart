import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reminder_app/components/show_toast.dart';
import 'package:reminder_app/services/auth_service.dart';
import 'package:reminder_app/utils/router.dart';
import 'package:toastification/toastification.dart';

class SignUpState extends ChangeNotifier {
  final AuthService _authService;
  final formKey = GlobalKey<FormState>();

  SignUpState(this._authService) {
    // Listen to auth state changes
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        // User is signed in
        notifyListeners();
      }
    });
  }

  String? _email;
  String? get email => _email;

  String? _fullName;
  String? get fullName => _fullName;

  String? _password;
  String? get password => _password;

  String? _confirmPassword;
  String? get confirmPassword => _confirmPassword;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void onEmailChanged(String value) {
    _email = value;
    notifyListeners();
  }

  void onFullNameChanged(String value) {
    _fullName = value;
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    _password = value;
    notifyListeners();
  }

  void onConfirmPasswordChanged(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> handleSignUp(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    _setLoading(true);

    try {
      // Clear any previous error messages
      formKey.currentState?.reset();

      // Create user with email and password
      final credential = await _authService.registerWithEmailAndPassword(
        _email!.trim(),
        _password!,
        _fullName!.trim(),
      );

      // Update user profile with full name
      if (credential.user != null) {
        // Show success message
        if (context.mounted) {
          showToast(
            context,
            type: ToastificationType.success,
            title: "Success",
            description: 'Account created successfully!',
            duration: const Duration(seconds: 3),
          );

          // Navigate to home page after a short delay to show the toast
          await Future.delayed(const Duration(seconds: 1));
          if (context.mounted) {
            GoRouter.of(context).go(RouteName.home);
          }
        }
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        showToast(
          context,
          type: ToastificationType.error,
          title: 'Sign Up Failed',
          description: e.toString(),
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      if (context.mounted) {
        _setLoading(false);
      }
    }
  }

  void handleLogin(BuildContext context) {
    GoRouter.of(context).go(RouteName.login);
  }
}

final navigatorKey = GlobalKey<NavigatorState>();
