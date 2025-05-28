import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/services/api-service/base_http_service.dart';
import 'package:reminder_app/services/api-service/event_service.dart';
import 'package:reminder_app/services/auth_service.dart';

class CreateReminderState extends ChangeNotifier {
  final AuthService _authService;
  final EventService _eventService = EventService();
  bool isLoading = false;
  String? error;

  CreateReminderState(this._authService);

  Future<bool> createReminder({
    required String title,
    required String description,
    required String time,
    required String frequency,
    required String startDate,
    required String endDate,
    required List<String> selectedDays,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        error = 'User not authenticated';
        return false;
      }

      final response = await _eventService.createEvent(
        title: title,
        time: time,
        frequency: frequency,
        description: description,
        startDate: startDate,
        endDate: endDate,
        selectedDays: selectedDays,
        userId: user.uid,
      );

      if (response is SuccessResponse) {
        return true;
      } else {
        error = 'Failed to create reminder';
        return false;
      }
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
