import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/services/api-service/base_http_service.dart';
import 'package:reminder_app/services/api-service/event_service.dart';
import 'package:reminder_app/services/auth_service.dart';

class HomeState extends ChangeNotifier {
  static HomeState? _instance;
  final AuthService _authService;
  final EventService _eventService = EventService();
  String? firstName;
  List<Map<String, dynamic>> events = [];
  bool isLoading = false;
  String? error;
  DateTime? _lastLoadTime;
  static const _cacheDuration = Duration(minutes: 5);

  // Private constructor
  HomeState._(this._authService) {
    debugPrint('HomeState initialized');
    _loadUserData();
    loadEvents();
  }

  // Factory constructor to return the singleton instance
  factory HomeState(AuthService authService) {
    _instance ??= HomeState._(authService);
    return _instance!;
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      firstName = user.displayName?.split(' ').first;
      notifyListeners();
    }
  }

  // Add new event to local state
  void addEvent(Map<String, dynamic> event) {
    debugPrint('Adding new event: ${event['title']}');
    events.insert(0, event); // Add to beginning of list
    notifyListeners();
  }

  Future<void> loadEvents({bool forceRefresh = false}) async {
    debugPrint('Loading events (forceRefresh: $forceRefresh)');
    // Check if we should use cached data
    if (!forceRefresh &&
        _lastLoadTime != null &&
        DateTime.now().difference(_lastLoadTime!) < _cacheDuration &&
        events.isNotEmpty) {
      debugPrint('Using cached events (${events.length} events)');
      return;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        debugPrint('Fetching events for user: ${user.uid}');
        final response = await _eventService.getEvents(user.uid);
        if (response is SuccessResponse) {
          final List<dynamic> rawEvents = response.data['events'] ?? [];
          events =
              rawEvents.map((event) {
                // Ensure all required fields are present
                return {
                  'title': event['title'] ?? 'Untitled',
                  'time': event['time'] ?? '00:00',
                  'frequency': event['frequency'] ?? 'Once',
                  'description': event['description'] ?? '',
                  'start_date':
                      event['start_date'] ?? DateTime.now().toIso8601String(),
                  'end_date':
                      event['end_date'] ?? DateTime.now().toIso8601String(),
                  'selected_days': event['selected_days'] ?? [],
                };
              }).toList();
          _lastLoadTime = DateTime.now();
          debugPrint('Loaded ${events.length} events');
        } else {
          error = 'Failed to load events';
          debugPrint('Error loading events: $error');
        }
      }
    } catch (e) {
      error = e.toString();
      debugPrint('Exception loading events: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createEvent({
    required String title,
    required String time,
    required String frequency,
    required String description,
    required String startDate,
    required String endDate,
    required List<String> selectedDays,
  }) async {
    debugPrint('Creating new event: $title');
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        error = 'User not authenticated';
        debugPrint('Error: $error');
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
        // Add the new event to local state
        final newEvent = {
          'title': title,
          'time': time,
          'frequency': frequency,
          'description': description,
          'start_date': startDate,
          'end_date': endDate,
          'selected_days': selectedDays,
        };
        addEvent(newEvent);
        debugPrint('Event created successfully');
        return true;
      } else {
        error = 'Failed to create event';
        debugPrint('Error creating event: $error');
        return false;
      }
    } catch (e) {
      error = e.toString();
      debugPrint('Exception creating event: $error');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Helper method to get events for a specific date
  List<Map<String, dynamic>> getEventsForDate(DateTime date) {
    // debugPrint('Getting events for date: ${date.toString()}');
    return events.where((event) {
      final startDate = DateTime.parse(event['start_date']);
      final endDate = DateTime.parse(event['end_date']);
      final selectedDays = List<String>.from(event['selected_days'] ?? []);

      // Check if the date is within the event's date range
      if (date.isBefore(startDate) || date.isAfter(endDate)) {
        return false;
      }

      // Check if the day of week is selected
      final dayName = _getDayName(date.weekday);
      return selectedDays.contains(dayName);
    }).toList();
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }
}
