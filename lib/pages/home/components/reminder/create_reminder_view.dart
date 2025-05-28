import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/components/app_textarea.dart';
import 'package:reminder_app/components/app_textfield.dart';
import 'package:reminder_app/components/button.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/components/show_toast.dart';
import 'package:reminder_app/services/auth_service.dart';
import 'package:reminder_app/utils/helpers.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';
import 'package:toastification/toastification.dart';

import '../../home_state.dart';
import 'create_reminder_state.dart';

enum ReminderFrequency { daily, oneTime, multipleDates, weekday, weekend }

class CreateReminderView extends StatefulWidget {
  const CreateReminderView({super.key});

  @override
  State<CreateReminderView> createState() => _CreateReminderViewState();
}

class _CreateReminderViewState extends State<CreateReminderView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  ReminderFrequency _selectedFrequency = ReminderFrequency.oneTime;
  final List<DateTime> _selectedDates = [];
  final List<bool> _selectedWeekDays = List.generate(7, (index) => false);
  final EasyDatePickerController _datePickerController =
      EasyDatePickerController();

  @override
  void initState() {
    super.initState();
    // Normalize initial _selectedDate to remove time components
    _selectedDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    // Defer jumpToDate until after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _datePickerController.jumpToDate(_selectedDate);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _datePickerController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      initialDateRange: DateTimeRange(
        start: _selectedDate,
        end: _selectedDate.add(const Duration(days: 30)),
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedDates.clear();
        DateTime current = picked.start;
        while (!current.isAfter(picked.end)) {
          _selectedDates.add(
            DateTime(current.year, current.month, current.day),
          );
          current = current.add(const Duration(days: 1));
        }
      });
    }
  }

  Widget _buildDateTimeline() {
    return Theme(
      data: Theme.of(
        context,
      ).copyWith(colorScheme: ColorScheme.fromSeed(seedColor: primaryColor)),
      child: EasyDateTimeLinePicker.itemBuilder(
        controller: _datePickerController,
        selectionMode: SelectionMode.autoCenter(),
        firstDate: DateTime.now().subtract(const Duration(days: 7)),
        lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
        focusedDate: _selectedDate,
        currentDate: DateTime.now(),
        itemExtent: 64.0,
        daySeparatorPadding: 10,
        disableStrategy: DisableStrategy.beforeToday(),
        locale: const Locale('en', 'US'),
        timelineOptions: const TimelineOptions(height: 100),
        headerOptions: HeaderOptions(
          headerType: HeaderType.picker,
          headerBuilder: (context, date, onTap) {
            return InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  DateFormat.yMMMM().format(date),
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontFamily: "Sora",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
        monthYearPickerOptions: const MonthYearPickerOptions(
          initialCalendarMode: EasyDatePickerMode.month,
          cancelText: 'Cancel',
          confirmText: 'Confirm',
        ),
        itemBuilder: (context, date, isSelected, isDisabled, isToday, onTap) {
          final weekday = date.weekday;
          bool shouldDisable = isDisabled;

          // Additional weekday/weekend restrictions
          if (!shouldDisable) {
            switch (_selectedFrequency) {
              case ReminderFrequency.weekday:
                shouldDisable = weekday > 5; // Disable Sat (6) and Sun (7)
                break;
              case ReminderFrequency.weekend:
                shouldDisable = weekday <= 5; // Disable Mon (1) through Fri (5)
                break;
              default:
                break;
            }
          }

          // Check if this date is selected in multiple dates mode
          bool isDateSelected = false;
          if (_selectedFrequency == ReminderFrequency.multipleDates ||
              _selectedFrequency == ReminderFrequency.weekday ||
              _selectedFrequency == ReminderFrequency.weekend ||
              _selectedFrequency == ReminderFrequency.daily) {
            isDateSelected = _selectedDates.any(
              (d) =>
                  d.year == date.year &&
                  d.month == date.month &&
                  d.day == date.day,
            );
          } else {
            isDateSelected = isSelected;
          }

          return InkResponse(
            onTap: shouldDisable ? null : onTap,
            child: Container(
              decoration: BoxDecoration(
                color:
                    isDateSelected
                        ? primaryColor
                        : isToday
                        ? primaryColor.withOpacity(0.1)
                        : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isToday
                          ? primaryColor
                          : isDateSelected
                          ? Colors.white
                          : Colors.grey.withOpacity(0.2),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('MMM').format(date),
                    style: TextStyle(
                      color:
                          isDateSelected
                              ? Colors.white
                              : isToday
                              ? primaryColor
                              : shouldDisable
                              ? Colors.grey
                              : textColorSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const VerticalSpace(4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color:
                          isDateSelected
                              ? Colors.white
                              : isToday
                              ? primaryColor
                              : shouldDisable
                              ? Colors.grey
                              : textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const VerticalSpace(4),
                  Text(
                    DateFormat('EEE').format(date),
                    style: TextStyle(
                      color:
                          isDateSelected
                              ? Colors.white
                              : isToday
                              ? primaryColor
                              : shouldDisable
                              ? Colors.grey
                              : textColorSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        onDateChange: (selectedDate) {
          setState(() {
            // Normalize selectedDate to remove time components
            final normalizedDate = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
            );

            switch (_selectedFrequency) {
              case ReminderFrequency.multipleDates:
              case ReminderFrequency.weekday:
              case ReminderFrequency.weekend:
              case ReminderFrequency.daily:
                if (!_selectedDates.any(
                  (d) =>
                      d.year == normalizedDate.year &&
                      d.month == normalizedDate.month &&
                      d.day == normalizedDate.day,
                )) {
                  _selectedDates.add(normalizedDate);
                  _selectedDates.sort(); // Sort dates for consistent display
                }
                break;
              default:
                _selectedDate = normalizedDate;
                _datePickerController.animateToDate(_selectedDate);
            }
          });
        },
      ),
    );
  }

  Widget _buildFrequencySpecificInput() {
    switch (_selectedFrequency) {
      case ReminderFrequency.multipleDates:
      case ReminderFrequency.weekday:
      case ReminderFrequency.weekend:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Selected Dates',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sora',
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha(50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_selectedDates.length} selected',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Sora',
                    ),
                  ),
                ),
              ],
            ),
            const VerticalSpace(12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 8,
                runSpacing: 8,
                children:
                    _selectedDates.map((date) {
                      return TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 200),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, double value, child) {
                          return Transform.scale(scale: value, child: child);
                        },
                        child: Chip(
                          label: Text(
                            formatDateToHumanReadable(date),
                            style: TextStyle(
                              color: textColor,
                              fontFamily: 'Sora',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onDeleted: () {
                            setState(() {
                              _selectedDates.remove(date);
                            });
                          },
                          backgroundColor: backgroundColor,
                          deleteIconColor: primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: primaryColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          elevation: 0,
                        ),
                      );
                    }).toList(),
              ),
            ),
            const VerticalSpace(16),
            ClipRRect(child: _buildDateTimeline()),
          ],
        );
      case ReminderFrequency.daily:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Date Range',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sora',
                  ),
                ),

                TextButton.icon(
                  onPressed: () => _selectDateRange(context),
                  icon: const Icon(LucideIcons.calendar, color: textColor),
                  label: const Text(
                    'Choose Range',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sora',
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            const VerticalSpace(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: secondaryColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.info, size: 16, color: secondaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Daily Reminder is initially set for 30 days automatically',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Sora',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const VerticalSpace(16),
            if (_selectedDates.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: secondaryColor.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.calendar, size: 16, color: secondaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Daily Reminder from ${formatDateToHumanReadable(_selectedDates.first)} to ${formatDateToHumanReadable(_selectedDates.last)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Sora',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const VerticalSpace(16),
            ClipRRect(child: _buildDateTimeline()),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Date',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sora',
              ),
            ),
            const VerticalSpace(16),
            Container(child: _buildDateTimeline()),
            const VerticalSpace(12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.calendar, size: 20, color: textColor),
                  const SizedBox(width: 8),
                  Text(
                    'Selected Date: ${formatDateToHumanReadable(_selectedDate)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Sora',
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }

  void _printReminderDetails() {
    print('\n=== Reminder Details ===');
    print('Title: ${_titleController.text}');
    print('Description: ${_descriptionController.text}');
    print('Time: ${_selectedTime.format(context)}');
    print('Frequency: ${_selectedFrequency.toString().split('.').last}');

    switch (_selectedFrequency) {
      case ReminderFrequency.oneTime:
        print('Date: ${formatDateToHumanReadable(_selectedDate)}');
        break;
      case ReminderFrequency.multipleDates:
        print('Selected Dates (${_selectedDates.length}):');
        for (var date in _selectedDates) {
          print('  - ${formatDateToHumanReadable(date)}');
        }
        break;
      case ReminderFrequency.weekday:
        print('Weekday Reminder (${_selectedDates.length} days):');
        print(
          '  Start Date: ${formatDateToHumanReadable(_selectedDates.first)}',
        );
        print('  End Date: ${formatDateToHumanReadable(_selectedDates.last)}');
        print('  Selected Days: Monday to Friday');
        break;
      case ReminderFrequency.weekend:
        print('Weekend Reminder (${_selectedDates.length} days):');
        print(
          '  Start Date: ${formatDateToHumanReadable(_selectedDates.first)}',
        );
        print('  End Date: ${formatDateToHumanReadable(_selectedDates.last)}');
        print('  Selected Days: Saturday and Sunday');
        break;
      case ReminderFrequency.daily:
        print('Daily Reminder (${_selectedDates.length} days):');
        print(
          '  Start Date: ${formatDateToHumanReadable(_selectedDates.first)}',
        );
        print('  End Date: ${formatDateToHumanReadable(_selectedDates.last)}');
        break;
    }
    print('======================\n');
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (context) => CreateReminderState(
            Provider.of<AuthService>(context, listen: false),
          ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: CustomAppBar(
          displayMode: LeadingDisplayMode.backWithText,
          leadingText: 'Create Reminder',
          onNotificationPressed: () {},
          showNotification: false,
        ),
        body: Consumer<CreateReminderState>(
          builder: (context, state, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      hintText: 'Reminder Title',
                      initialValue: _titleController.text,
                      onChanged: (value) {
                        _titleController.text = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a reminder title';
                        }
                        return null;
                      },
                    ),
                    const VerticalSpace(16),
                    AppTextArea(
                      hintText: 'Reminder Description',
                      labelText: 'Reminder Description',
                      onChanged: (value) {
                        _descriptionController.text = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a reminder description';
                        }
                        return null;
                      },
                      maxLength: 200,
                      maxLines: 6,
                      minLines: 2,
                    ),
                    const VerticalSpace(16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _selectTime(context),

                            icon: const Icon(
                              LucideIcons.clock,
                              color: textColor,
                            ),
                            label: Text(
                              // '${_selectedTime.hour}:${_selectedTime.minute}'
                              'Selected Time: ${_selectedTime.format(context)}',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Sora',
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const VerticalSpace(16),
                    DropdownButtonFormField<ReminderFrequency>(
                      value: _selectedFrequency,
                      decoration: InputDecoration(
                        labelText: 'Reminder Frequency',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: secondaryColor.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // border: OutlineInputBorder(),
                      ),
                      items:
                          ReminderFrequency.values.map((frequency) {
                            String label;
                            switch (frequency) {
                              case ReminderFrequency.daily:
                                label = 'Daily';
                                break;
                              case ReminderFrequency.oneTime:
                                label = 'One-time';
                                break;
                              case ReminderFrequency.multipleDates:
                                label = 'Multiple Dates';
                                break;
                              case ReminderFrequency.weekday:
                                label = 'Weekday (Mon-Fri)';
                                break;
                              case ReminderFrequency.weekend:
                                label = 'Weekend (Sat-Sun)';
                                break;
                            }
                            return DropdownMenuItem<ReminderFrequency>(
                              value: frequency,
                              child: Text(label),
                            );
                          }).toList(),
                      onChanged: (ReminderFrequency? newValue) {
                        if (newValue != null &&
                            newValue != _selectedFrequency) {
                          setState(() {
                            _selectedFrequency = newValue;
                            _selectedDates.clear();
                            _selectedWeekDays.fillRange(0, 7, false);
                            final now = DateTime.now();
                            final today = DateTime(
                              now.year,
                              now.month,
                              now.day,
                            );

                            switch (newValue) {
                              case ReminderFrequency.oneTime:
                              case ReminderFrequency.multipleDates:
                                _selectedDate = today;
                                break;
                              case ReminderFrequency.daily:
                                _selectedDate = today;
                                // Generate dates for the next 30 days
                                _selectedDates.clear();
                                for (int i = 0; i < 30; i++) {
                                  _selectedDates.add(
                                    today.add(Duration(days: i)),
                                  );
                                }

                                break;
                              case ReminderFrequency.weekday:
                                _selectedWeekDays.fillRange(
                                  0,
                                  5,
                                  true,
                                ); // Mon-Fri
                                _selectedDate =
                                    now.weekday <= 5
                                        ? today
                                        : DateTime(
                                          now.year,
                                          now.month,
                                          now.day + (8 - now.weekday),
                                        );
                                // Generate dates for the next 30 weekdays
                                _selectedDates.clear();
                                DateTime weekdayDate = _selectedDate;
                                int weekdayCount = 0;
                                while (weekdayCount < 30) {
                                  if (weekdayDate.weekday <= 5) {
                                    // Only add weekdays (Mon-Fri)
                                    _selectedDates.add(
                                      DateTime(
                                        weekdayDate.year,
                                        weekdayDate.month,
                                        weekdayDate.day,
                                      ),
                                    );
                                    weekdayCount++;
                                  }
                                  weekdayDate = weekdayDate.add(
                                    const Duration(days: 1),
                                  );
                                }
                                break;
                              case ReminderFrequency.weekend:
                                _selectedWeekDays[5] = true; // Sat
                                _selectedWeekDays[6] = true; // Sun
                                _selectedDate =
                                    now.weekday >= 6
                                        ? today
                                        : DateTime(
                                          now.year,
                                          now.month,
                                          now.day + (6 - now.weekday),
                                        );
                                // Generate dates for the next 30 weekends
                                _selectedDates.clear();
                                DateTime weekendDate = _selectedDate;
                                int weekendCount = 0;
                                while (weekendCount < 30) {
                                  if (weekendDate.weekday >= 6) {
                                    // Only add weekends (Sat-Sun)
                                    _selectedDates.add(
                                      DateTime(
                                        weekendDate.year,
                                        weekendDate.month,
                                        weekendDate.day,
                                      ),
                                    );
                                    weekendCount++;
                                  }
                                  weekendDate = weekendDate.add(
                                    const Duration(days: 1),
                                  );
                                }
                                break;
                            }
                            _datePickerController.animateToDate(_selectedDate);
                          });
                        }
                      },
                    ),
                    const VerticalSpace(16),
                    _buildFrequencySpecificInput(),
                    const VerticalSpace(32),
                    if (state.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (state.error != null)
                      Center(
                        child: Text(
                          state.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    else
                      CustomButton(
                        title: 'Create Reminder',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool isValid = true;
                            String? errorMessage;

                            // Validate _selectedDate is not in the past for oneTime
                            final today = DateTime.now();
                            final normalizedToday = DateTime(
                              today.year,
                              today.month,
                              today.day,
                            );
                            if (_selectedFrequency ==
                                    ReminderFrequency.oneTime &&
                                _selectedDate.isBefore(normalizedToday)) {
                              isValid = false;
                              errorMessage =
                                  'Selected date cannot be in the past';
                            }

                            // Validate frequency-specific inputs
                            switch (_selectedFrequency) {
                              case ReminderFrequency.multipleDates:
                              case ReminderFrequency.weekday:
                              case ReminderFrequency.weekend:
                              case ReminderFrequency.daily:
                                if (_selectedDates.isEmpty) {
                                  isValid = false;
                                  errorMessage =
                                      'Please select at least one date';
                                } else if (_selectedDates.any(
                                  (date) => date.isBefore(normalizedToday),
                                )) {
                                  isValid = false;
                                  errorMessage =
                                      'Selected dates cannot be in the past';
                                }
                                break;
                              default:
                                break;
                            }

                            if (!isValid) {
                              showToast(
                                context,
                                type: ToastificationType.error,
                                title: 'Invalid Input',
                                description: errorMessage!,
                              );
                              return;
                            }

                            _printReminderDetails();

                            // Format dates for API
                            String startDate =
                                _selectedFrequency == ReminderFrequency.oneTime
                                    ? DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(_selectedDate)
                                    : DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(_selectedDates.first);

                            String endDate =
                                _selectedFrequency == ReminderFrequency.oneTime
                                    ? DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(_selectedDate)
                                    : DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(_selectedDates.last);

                            // Format time for API
                            String time =
                                '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

                            // Get selected days based on frequency
                            List<String> selectedDays = [];
                            switch (_selectedFrequency) {
                              case ReminderFrequency.weekday:
                                selectedDays = [
                                  'Monday',
                                  'Tuesday',
                                  'Wednesday',
                                  'Thursday',
                                  'Friday',
                                ];
                                break;
                              case ReminderFrequency.weekend:
                                selectedDays = ['Saturday', 'Sunday'];
                                break;
                              case ReminderFrequency.daily:
                                selectedDays = [
                                  'Monday',
                                  'Tuesday',
                                  'Wednesday',
                                  'Thursday',
                                  'Friday',
                                  'Saturday',
                                  'Sunday',
                                ];
                                break;
                              case ReminderFrequency.multipleDates:
                                selectedDays =
                                    _selectedDates
                                        .map(
                                          (date) => _getDayName(date.weekday),
                                        )
                                        .toList();
                                break;
                              case ReminderFrequency.oneTime:
                                selectedDays = [
                                  _getDayName(_selectedDate.weekday),
                                ];
                                break;
                            }

                            final success = await state.createReminder(
                              title: _titleController.text,
                              description: _descriptionController.text,
                              time: time,
                              frequency:
                                  _selectedFrequency.toString().split('.').last,
                              startDate: startDate,
                              endDate: endDate,
                              selectedDays: selectedDays,
                            );

                            if (success) {
                              showToast(
                                context,
                                type: ToastificationType.success,
                                title: 'Reminder Created!',
                                description:
                                    'Reminder ${_titleController.text} created successfully',
                              );
                              if (mounted) {
                                // Pop back to home and refresh
                                context.pop();
                                // Find the HomeState using Provider and refresh
                                final homeState = Provider.of<HomeState>(
                                  context,
                                  listen: false,
                                );
                                await homeState.loadEvents();
                              }
                            } else {
                              showToast(
                                context,
                                type: ToastificationType.error,
                                title: 'Failed to Create Reminder',
                                description:
                                    state.error ??
                                    'An error occurred while creating the reminder',
                              );
                            }
                          }
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
