import 'package:flutter/material.dart';
import 'package:reminder_app/pages/home/home_state.dart';

class CalendarState extends ChangeNotifier {
  static CalendarState? _instance;
  final HomeState _homeState;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Map<String, dynamic>>> _eventsMap = {};

  // Private constructor
  CalendarState._(this._homeState) {
    // debugPrint(
    //   'CalendarState initialized with ${_homeState.events.length} events',
    // );
    _loadEvents();
    // Listen to changes in HomeState
    _homeState.addListener(_onHomeStateChanged);
  }

  // Factory constructor to return the singleton instance
  factory CalendarState(HomeState homeState) {
    _instance ??= CalendarState._(homeState);
    return _instance!;
  }

  @override
  void dispose() {
    _homeState.removeListener(_onHomeStateChanged);
    super.dispose();
  }

  void _onHomeStateChanged() {
    // debugPrint('HomeState changed, reloading events');
    _loadEvents();
  }

  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;
  Map<DateTime, List<Map<String, dynamic>>> get eventsMap => _eventsMap;

  void setSelectedDay(DateTime? day) {
    _selectedDay = day;
    notifyListeners();
  }

  void setFocusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  void _loadEvents() {
    // debugPrint('Loading events from HomeState');
    _eventsMap = _getEventsMap(_homeState.events);
    // debugPrint('Mapped events: ${_eventsMap.length} days have events');
    notifyListeners();
  }

  List<Map<String, dynamic>> getEventsForDay(DateTime day) {
    // Use HomeState's getEventsForDate method
    final events = _homeState.getEventsForDate(day);

    return events;
  }

  /// Converts the list of events to a map of DateTime -> List of events for TableCalendar
  Map<DateTime, List<Map<String, dynamic>>> _getEventsMap(
    List<Map<String, dynamic>> events,
  ) {
    // debugPrint('Converting ${events.length} events to map');
    final Map<DateTime, List<Map<String, dynamic>>> eventsMap = {};

    // Get the current month's start and end dates
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    // Generate all dates in the current month
    DateTime current = firstDayOfMonth;
    while (current.isBefore(lastDayOfMonth) ||
        current.isAtSameMomentAs(lastDayOfMonth)) {
      final eventsForDay = _homeState.getEventsForDate(current);
      if (eventsForDay.isNotEmpty) {
        eventsMap[current] = eventsForDay;
      }
      current = current.add(const Duration(days: 1));
    }

    return eventsMap;
  }

  void refreshEvents() {
    // debugPrint('Manually refreshing events');
    _loadEvents();
  }
}
