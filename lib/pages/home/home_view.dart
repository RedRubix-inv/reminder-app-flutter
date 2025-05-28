import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/pages/home/components/reminder/reminder_card.dart';
import 'package:reminder_app/pages/home/components/reminder/reminder_details_view.dart';
import 'package:reminder_app/pages/home/home_state.dart';
import 'package:reminder_app/utils/router.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeState>();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        displayMode: LeadingDisplayMode.avatarOnly,
        avatarImageUrl: 'assets/images/profile.png',
        showNotification: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getScreenWidth(context) * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.firstName != null
                  ? "Hello, ${state.firstName}!"
                  : "Hello there!",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const VerticalSpace(8),
            Text(
              'Check your schedule and reminders.',
              style: TextStyle(fontSize: 16, color: textColorSecondary),
            ),
            const VerticalSpace(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Reminders (${state.events.length})',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const HorizontalSpace(16),
                IconButton(
                  onPressed: () {
                    context.push(RouteName.createReminder);
                  },
                  icon: const Icon(
                    LucideIcons.bellPlus,
                    color: textColor,
                    size: 30,
                  ),
                ),
              ],
            ),
            const VerticalSpace(16),
            if (state.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (state.error != null)
              Center(
                child: Text(state.error!, style: TextStyle(color: Colors.red)),
              )
            else if (state.events.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.bellOff,
                        size: 64,
                        color: textColorSecondary,
                      ),
                      const VerticalSpace(16),
                      Text(
                        'No reminders yet',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const VerticalSpace(8),
                      Text(
                        'Create your first reminder to get started',
                        style: TextStyle(
                          fontSize: 16,
                          color: textColorSecondary,
                        ),
                      ),
                      const VerticalSpace(24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.push(RouteName.createReminder);
                        },
                        icon: const Icon(LucideIcons.bellPlus),
                        label: const Text('Create Reminder'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final state = context.read<HomeState>();
                    await state.loadEvents(forceRefresh: true);
                  },
                  child: ListView.builder(
                    itemCount: state.events.length,
                    itemBuilder: (context, index) {
                      final event = state.events[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ReminderCard(
                          title: event['title'] ?? '',
                          description: event['description'] ?? '',
                          time: _parseTimeOfDay(event['time'] ?? '00:00'),
                          dates: _parseDates(
                            event['start_date'],
                            event['end_date'],
                            event['selected_days'],
                          ),
                          frequency: event['frequency'] ?? '',
                          type: 'personal',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ReminderDetailsView(
                                      title: event['title'] ?? '',
                                      description: event['description'] ?? '',
                                      time: _parseTimeOfDay(
                                        event['time'] ?? '00:00',
                                      ),
                                      dates: _parseDates(
                                        event['start_date'],
                                        event['end_date'],
                                        event['selected_days'],
                                      ),
                                      frequency: event['frequency'] ?? '',
                                      teamMembers: const [],
                                    ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  List<DateTime> _parseDates(
    String? startDate,
    String? endDate,
    List<dynamic>? selectedDays,
  ) {
    if (startDate == null || endDate == null) return [];

    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    final days = selectedDays?.cast<String>() ?? [];

    List<DateTime> dates = [];
    DateTime current = start;

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      final dayName = _getDayName(current.weekday);
      if (days.contains(dayName)) {
        dates.add(current);
      }
      current = current.add(const Duration(days: 1));
    }

    return dates;
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
