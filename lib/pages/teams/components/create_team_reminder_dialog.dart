import 'package:flutter/material.dart';
import 'package:reminder_app/models/team.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';

class CreateTeamReminderDialog extends StatefulWidget {
  final Team team;
  final Function(TeamReminder) onCreateReminder;

  const CreateTeamReminderDialog({
    super.key,
    required this.team,
    required this.onCreateReminder,
  });

  @override
  State<CreateTeamReminderDialog> createState() =>
      _CreateTeamReminderDialogState();
}

class _CreateTeamReminderDialogState extends State<CreateTeamReminderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  ReminderFrequency _selectedFrequency = ReminderFrequency.oneTime;
  String? _selectedAssignedTo;
  List<DateTime> _multipleDates = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
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

  Future<void> _selectMultipleDates(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange:
          _multipleDates.isEmpty
              ? DateTimeRange(
                start: DateTime.now(),
                end: DateTime.now().add(const Duration(days: 7)),
              )
              : DateTimeRange(
                start: _multipleDates.first,
                end: _multipleDates.last,
              ),
    );
    if (picked != null) {
      setState(() {
        _multipleDates = List.generate(
          picked.end.difference(picked.start).inDays + 1,
          (index) => picked.start.add(Duration(days: index)),
        );
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final reminder = TeamReminder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        dateTime: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
        frequency: _selectedFrequency,
        multipleDates:
            _selectedFrequency == ReminderFrequency.multipleDates
                ? _multipleDates
                : null,
        assignedToEmail: _selectedAssignedTo ?? widget.team.members.first.email,
        createdByEmail:
            widget.team.members.first.email, // TODO: Get current user
        createdAt: DateTime.now(),
      );
      widget.onCreateReminder(reminder);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create Team Reminder',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const VerticalSpace(24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Reminder Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const VerticalSpace(16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const VerticalSpace(16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                    ),
                  ),
                  const HorizontalSpace(8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectTime(context),
                      icon: const Icon(Icons.access_time),
                      label: Text(_selectedTime.format(context)),
                    ),
                  ),
                ],
              ),
              const VerticalSpace(16),
              DropdownButtonFormField<ReminderFrequency>(
                value: _selectedFrequency,
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                  border: OutlineInputBorder(),
                ),
                items:
                    ReminderFrequency.values.map((frequency) {
                      return DropdownMenuItem(
                        value: frequency,
                        child: Text(frequency.toString().split('.').last),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedFrequency = value;
                    });
                  }
                },
              ),
              if (_selectedFrequency == ReminderFrequency.multipleDates) ...[
                const VerticalSpace(16),
                OutlinedButton.icon(
                  onPressed: () => _selectMultipleDates(context),
                  icon: const Icon(Icons.calendar_month),
                  label: Text(
                    _multipleDates.isEmpty
                        ? 'Select Multiple Dates'
                        : '${_multipleDates.length} dates selected',
                  ),
                ),
              ],
              const VerticalSpace(16),
              DropdownButtonFormField<String>(
                value: _selectedAssignedTo,
                decoration: const InputDecoration(
                  labelText: 'Assign To',
                  border: OutlineInputBorder(),
                ),
                items:
                    widget.team.members.map((member) {
                      return DropdownMenuItem(
                        value: member.email,
                        child: Text(member.email),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedAssignedTo = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an assignee';
                  }
                  return null;
                },
              ),
              const VerticalSpace(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const HorizontalSpace(8),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Create Reminder'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
