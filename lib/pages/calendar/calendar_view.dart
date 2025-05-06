import 'package:flutter/material.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/pages/calendar/components/create_event_dialog.dart';
import 'package:reminder_app/pages/calendar/components/event_card.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final Map<DateTime, List<Event>> _events = {};

  final DateTime _firstDay = DateTime.now().subtract(const Duration(days: 1));
  final DateTime _lastDay = DateTime.now().add(const Duration(days: 90));

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    if (_focusedDay.isAfter(_lastDay)) {
      _focusedDay = _lastDay;
    } else if (_focusedDay.isBefore(_firstDay)) {
      _focusedDay = _firstDay;
    }
    _selectedDay = _focusedDay;
    // Add some sample events
    _events[DateTime.now()] = [
      Event(
        title: 'Team Meeting',
        description: 'Weekly team sync',
        startTime: DateTime.now().add(const Duration(hours: 10)),
        endTime: DateTime.now().add(const Duration(hours: 11)),
        type: 'Meeting',
      ),
      Event(
        title: 'Project Deadline',
        description: 'Submit final deliverables',
        startTime: DateTime.now().add(const Duration(hours: 14)),
        endTime: DateTime.now().add(const Duration(hours: 15)),
        type: 'Deadline',
      ),
    ];
  }

  void _showCreateEventDialog() {
    showDialog(
      context: context,
      builder:
          (context) => CreateEventDialog(
            onCreateEvent: (event) {
              setState(() {
                final date = DateTime(
                  event.startTime.year,
                  event.startTime.month,
                  event.startTime.day,
                );
                if (_events[date] == null) {
                  _events[date] = [];
                }
                _events[date]!.add(event);
              });
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        avatarImageUrl: 'assets/images/profile.png',
        displayMode: LeadingDisplayMode.avatarOnly,
        onNotificationPressed: () {},
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getScreenWidth(context) * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Calendar',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _showCreateEventDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Create Event'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const VerticalSpace(20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TableCalendar(
                      firstDay: _firstDay,
                      lastDay: _lastDay,
                      focusedDay: _focusedDay,
                      selectedDayPredicate:
                          (day) => isSameDay(_selectedDay, day),
                      calendarFormat: _calendarFormat,
                      eventLoader: (day) => _events[day] ?? [],
                      startingDayOfWeek: StartingDayOfWeek.sunday,
                      calendarStyle: const CalendarStyle(
                        outsideDaysVisible: false,
                        weekendTextStyle: TextStyle(color: Colors.red),
                      ),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                    ),
                    const VerticalSpace(20),
                    if (_selectedDay != null && _events[_selectedDay] != null)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _events[_selectedDay]!.length,
                        itemBuilder: (context, index) {
                          final event = _events[_selectedDay]![index];
                          return EventCard(
                            event: event,
                            onDelete: () {
                              setState(() {
                                _events[_selectedDay]!.removeAt(index);
                                if (_events[_selectedDay]!.isEmpty) {
                                  _events.remove(_selectedDay);
                                }
                              });
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Event {
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String type;

  Event({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.type,
  });
}
