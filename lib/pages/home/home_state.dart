import 'package:flutter/material.dart';
import 'package:reminder_app/services/auth_service.dart';

class HomeState extends ChangeNotifier {
  final AuthService _authService;

  HomeState(this._authService);

  String? get firstName {
    final displayName = _authService.currentUser?.displayName;
    if (displayName != null) {
      return displayName.split(' ').first;
    }
    return null;
  }
}
