import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/components/app_textarea.dart';
import 'package:reminder_app/components/app_textfield.dart';
import 'package:reminder_app/components/button.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/components/show_toast.dart';
import 'package:reminder_app/utils/router.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';
import 'package:toastification/toastification.dart';

enum ReminderFrequency { oneTime, multipleDates, weekday, weekend }

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

  Widget _buildDateTimeline() {
    return Theme(
      data: Theme.of(
        context,
      ).copyWith(colorScheme: ColorScheme.fromSeed(seedColor: primaryColor)),
      child: Builder(
        builder:
            (context) => EasyTheme(
              data: EasyTheme.of(context).copyWithState(
                selectedDayTheme: DayThemeData(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  border: BorderSide(color: primaryColor),
                  middleElementStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  topElementStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                unselectedDayTheme: DayThemeData(
                  backgroundColor: Colors.white,
                  foregroundColor: textColor,
                  border: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  middleElementStyle: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  topElementStyle: TextStyle(
                    color: textColorSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                selectedCurrentDayTheme: DayThemeData(
                  backgroundColor: primaryColor.withOpacity(0.8),
                  foregroundColor: Colors.white,
                  border: const BorderSide(color: Colors.white),
                  middleElementStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  topElementStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                unselectedCurrentDayTheme: DayThemeData(
                  backgroundColor: primaryColor.withOpacity(0.1),
                  foregroundColor: primaryColor,
                  border: BorderSide(color: primaryColor),
                  middleElementStyle: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  topElementStyle: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                disabledDayTheme: DayThemeData(
                  backgroundColor: Colors.grey.shade100,
                  foregroundColor: Colors.grey,
                  border: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  middleElementStyle: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                  topElementStyle: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
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
                itemBuilder: (
                  context,
                  date,
                  isSelected,
                  isDisabled,
                  isToday,
                  onTap,
                ) {
                  final weekday = date.weekday;
                  bool shouldDisable = isDisabled;

                  // Additional weekday/weekend restrictions
                  if (!shouldDisable) {
                    switch (_selectedFrequency) {
                      case ReminderFrequency.weekday:
                        shouldDisable =
                            weekday > 5; // Disable Sat (6) and Sun (7)
                        break;
                      case ReminderFrequency.weekend:
                        shouldDisable =
                            weekday <= 5; // Disable Mon (1) through Fri (5)
                        break;
                      default:
                        break;
                    }
                  }

                  // Check if this date is selected in multiple dates mode
                  bool isDateSelected = false;
                  if (_selectedFrequency == ReminderFrequency.multipleDates ||
                      _selectedFrequency == ReminderFrequency.weekday ||
                      _selectedFrequency == ReminderFrequency.weekend) {
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
                        if (!_selectedDates.any(
                          (d) =>
                              d.year == normalizedDate.year &&
                              d.month == normalizedDate.month &&
                              d.day == normalizedDate.day,
                        )) {
                          _selectedDates.add(normalizedDate);
                          _selectedDates
                              .sort(); // Sort dates for consistent display
                        }
                        break;
                      default:
                        _selectedDate = normalizedDate;
                        _datePickerController.animateToDate(_selectedDate);
                    }
                  });
                },
              ),
            ),
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
                    fontSize: 16,
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
                            DateFormat('dd/MM/yyyy').format(date),
                            style: TextStyle(
                              color: textColor,
                              fontFamily: 'Sora',
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
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Date',
              style: TextStyle(
                fontSize: 16,
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
                  Icon(Icons.calendar_today, size: 16, color: primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Selected Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
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
    print('=== Reminder Created ===');
    print('Title: ${_titleController.text}');
    print('Description: ${_descriptionController.text}');
    print('Time: ${_selectedTime.format(context)}');
    print('Frequency: ${_selectedFrequency.toString().split('.').last}');

    switch (_selectedFrequency) {
      case ReminderFrequency.oneTime:
        print('Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}');
        break;
      case ReminderFrequency.multipleDates:
      case ReminderFrequency.weekday:
      case ReminderFrequency.weekend:
        print('Selected Dates:');
        for (var date in _selectedDates) {
          print('  - ${DateFormat('dd/MM/yyyy').format(date)}');
        }
        break;
    }
    print('======================');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        displayMode: LeadingDisplayMode.backWithText,
        leadingText: 'Create Reminder',
        onNotificationPressed: () {},
      ),
      body: SingleChildScrollView(
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
                      icon: const Icon(Icons.access_time),
                      label: Text(_selectedTime.format(context)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const VerticalSpace(16),
              DropdownButtonFormField<ReminderFrequency>(
                value: _selectedFrequency,
                decoration: const InputDecoration(
                  labelText: 'Reminder Frequency',
                  border: OutlineInputBorder(),
                ),
                items:
                    ReminderFrequency.values.map((frequency) {
                      String label;
                      switch (frequency) {
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
                  if (newValue != null && newValue != _selectedFrequency) {
                    setState(() {
                      _selectedFrequency = newValue;
                      _selectedDates.clear();
                      _selectedWeekDays.fillRange(0, 7, false);
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);

                      switch (newValue) {
                        case ReminderFrequency.oneTime:
                        case ReminderFrequency.multipleDates:
                          _selectedDate = today;
                          break;
                        case ReminderFrequency.weekday:
                          _selectedWeekDays.fillRange(0, 5, true); // Mon-Fri
                          _selectedDate =
                              now.weekday <= 5
                                  ? today
                                  : DateTime(
                                    now.year,
                                    now.month,
                                    now.day + (8 - now.weekday),
                                  );
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
              CustomButton(
                title: 'Create Reminder',
                onPressed: () {
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
                    if (_selectedFrequency == ReminderFrequency.oneTime &&
                        _selectedDate.isBefore(normalizedToday)) {
                      isValid = false;
                      errorMessage = 'Selected date cannot be in the past';
                    }

                    // Validate frequency-specific inputs
                    switch (_selectedFrequency) {
                      case ReminderFrequency.multipleDates:
                      case ReminderFrequency.weekday:
                      case ReminderFrequency.weekend:
                        if (_selectedDates.isEmpty) {
                          isValid = false;
                          errorMessage = 'Please select at least one date';
                        } else if (_selectedDates.any(
                          (date) => date.isBefore(normalizedToday),
                        )) {
                          isValid = false;
                          errorMessage = 'Selected dates cannot be in the past';
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

                    showToast(
                      context,
                      type: ToastificationType.success,
                      title: 'Reminder Created!',
                      description:
                          'Reminder ${_titleController.text} created successfully',
                    );
                    GoRouter.of(context).go(RouteName.home);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
