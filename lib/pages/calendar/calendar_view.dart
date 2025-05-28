import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/pages/calendar/calendar_state.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarState = context.watch<CalendarState>();
    final selectedDay = calendarState.selectedDay ?? DateTime.now();
    final selectedEvents = calendarState.getEventsForDay(selectedDay);

    debugPrint(
      'Building CalendarView with ${selectedEvents.length} events for $selectedDay',
    );

    return Scaffold(
      appBar: CustomAppBar(
        displayMode: LeadingDisplayMode.avatarOnly,
        avatarImageUrl: 'assets/images/profile.png',
        showNotification: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getScreenWidth(context) * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Calendar",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: calendarState.focusedDay,
                  selectedDayPredicate:
                      (day) => isSameDay(calendarState.selectedDay, day),
                  eventLoader: (day) {
                    final events = calendarState.getEventsForDay(day);

                    return events;
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    // debugPrint('Day selected: $selectedDay');
                    calendarState.setSelectedDay(selectedDay);
                    calendarState.setFocusedDay(focusedDay);
                  },
                  calendarStyle: CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    outsideDaysVisible: false,
                    weekendTextStyle: TextStyle(color: Colors.red[300]),
                    holidayTextStyle: TextStyle(color: Colors.red[300]),
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isEmpty) return null;
                      return Positioned(
                        bottom: 6,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    leftChevronIcon: Icon(
                      LucideIcons.chevronLeft,
                      color: textColor,
                    ),
                    rightChevronIcon: Icon(
                      LucideIcons.chevronRight,
                      color: textColor,
                    ),
                    titleTextStyle: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  rowHeight: 45,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                    weekendStyle: TextStyle(
                      color: Colors.red[300],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Reminders for ${selectedDay.toLocal().toString().split(' ')[0]}:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              if (selectedEvents.isEmpty)
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.calendarX,
                        size: 48,
                        color: textColorSecondary,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No reminders for this day',
                        style: TextStyle(
                          fontSize: 16,
                          color: textColorSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: selectedEvents.length,
                  itemBuilder: (context, index) {
                    final event = selectedEvents[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shadowColor: Colors.black.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event['title'] ?? 'Untitled',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (event['description']?.isNotEmpty ??
                                  false) ...[
                                SizedBox(height: 4),
                                Text(
                                  event['description'] ?? '',
                                  style: TextStyle(
                                    color: textColorSecondary,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: accentColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      LucideIcons.clock,
                                      size: 14,
                                      color: accentColor,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      event['time'] ?? '00:00',
                                      style: TextStyle(
                                        color: accentColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
