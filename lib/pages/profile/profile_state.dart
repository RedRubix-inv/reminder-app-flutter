import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reminder_app/components/show_toast.dart';
import 'package:reminder_app/services/auth_service.dart';
import 'package:reminder_app/utils/router.dart';
import 'package:toastification/toastification.dart';

class ProfileState extends ChangeNotifier {
  final AuthService _authService;

  ProfileState(this._authService);

  String? get userEmail => _authService.currentUser?.email;
  String? get userName => _authService.currentUser?.displayName;
  String? get userPhotoUrl => _authService.currentUser?.photoURL;

  Future<void> handleSignOut(BuildContext context) async {
    try {
      await _authService.signOut();

      if (context.mounted) {
        // Show success message
        showToast(
          context,
          type: ToastificationType.success,
          title: 'Success',
          description: 'Signed out successfully',
          duration: const Duration(seconds: 3),
        );

        // Ensure we're redirected to login
        await Future.delayed(const Duration(milliseconds: 100));
        if (context.mounted) {
          GoRouter.of(context).go(RouteName.login);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showToast(
          context,
          type: ToastificationType.error,
          title: 'Error',
          description: 'Failed to sign out: ${e.toString()}',
          duration: const Duration(seconds: 6),
        );
      }
    }
  }
}
