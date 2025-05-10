import 'package:flutter/material.dart';
import 'package:reminder_app/models/team.dart';
import 'package:reminder_app/pages/teams/components/create_team_reminder_dialog.dart';
import 'package:reminder_app/pages/teams/components/team_reminder_card.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';

class TeamRemindersView extends StatefulWidget {
  final Team team;

  const TeamRemindersView({super.key, required this.team});

  @override
  State<TeamRemindersView> createState() => _TeamRemindersViewState();
}

class _TeamRemindersViewState extends State<TeamRemindersView> {
  String? _selectedAssignedTo;
  ReminderFrequency? _selectedFrequency;
  DateTimeRange? _selectedDateRange;

  List<TeamReminder> get _filteredReminders {
    return widget.team.reminders.where((reminder) {
      if (_selectedAssignedTo != null &&
          reminder.assignedToEmail != _selectedAssignedTo) {
        return false;
      }
      if (_selectedFrequency != null &&
          reminder.frequency != _selectedFrequency) {
        return false;
      }
      if (_selectedDateRange != null) {
        final reminderDate = reminder.dateTime;
        if (reminderDate.isBefore(_selectedDateRange!.start) ||
            reminderDate.isAfter(_selectedDateRange!.end)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  void _showCreateReminderDialog() {
    showDialog(
      context: context,
      builder:
          (context) => CreateTeamReminderDialog(
            team: widget.team,
            onCreateReminder: (reminder) {
              setState(() {
                widget.team.reminders.add(reminder);
              });
            },
          ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Filter Reminders',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const VerticalSpace(16),
                DropdownButtonFormField<String>(
                  value: _selectedAssignedTo,
                  decoration: const InputDecoration(
                    labelText: 'Assigned To',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Members'),
                    ),
                    ...widget.team.members.map((member) {
                      return DropdownMenuItem(
                        value: member.email,
                        child: Text(member.name ?? member.email),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedAssignedTo = value;
                    });
                    Navigator.pop(context);
                  },
                ),
                const VerticalSpace(16),
                DropdownButtonFormField<ReminderFrequency>(
                  value: _selectedFrequency,
                  decoration: const InputDecoration(
                    labelText: 'Frequency',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Frequencies'),
                    ),
                    ...ReminderFrequency.values.map((frequency) {
                      return DropdownMenuItem(
                        value: frequency,
                        child: Text(frequency.toString().split('.').last),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedFrequency = value;
                    });
                    Navigator.pop(context);
                  },
                ),
                const VerticalSpace(16),
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialDateRange: _selectedDateRange,
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDateRange = picked;
                      });
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    _selectedDateRange == null
                        ? 'Select Date Range'
                        : '${_selectedDateRange!.start.toString().split(' ')[0]} - ${_selectedDateRange!.end.toString().split(' ')[0]}',
                  ),
                ),
                const VerticalSpace(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedAssignedTo = null;
                          _selectedFrequency = null;
                          _selectedDateRange = null;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Clear Filters'),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.team.name} Reminders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_selectedAssignedTo != null ||
              _selectedFrequency != null ||
              _selectedDateRange != null)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 16),
                  const HorizontalSpace(8),
                  Expanded(
                    child: Text(
                      [
                        if (_selectedAssignedTo != null)
                          'Assigned to: ${widget.team.members.firstWhere((m) => m.email == _selectedAssignedTo).name ?? _selectedAssignedTo}',
                        if (_selectedFrequency != null)
                          'Frequency: ${_selectedFrequency.toString().split('.').last}',
                        if (_selectedDateRange != null)
                          'Date Range: ${_selectedDateRange!.start.toString().split(' ')[0]} - ${_selectedDateRange!.end.toString().split(' ')[0]}',
                      ].join(', '),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedAssignedTo = null;
                        _selectedFrequency = null;
                        _selectedDateRange = null;
                      });
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),
          Expanded(
            child:
                _filteredReminders.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_none,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const VerticalSpace(16),
                          Text(
                            'No reminders found',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const VerticalSpace(8),
                          Text(
                            'Create a new reminder to get started',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredReminders.length,
                      itemBuilder: (context, index) {
                        final reminder = _filteredReminders[index];
                        return TeamReminderCard(
                          reminder: reminder,
                          team: widget.team,
                          onEdit: () {
                            // TODO: Implement edit functionality
                          },
                          onDelete: () {
                            setState(() {
                              widget.team.reminders.remove(reminder);
                            });
                          },
                          onComplete: () {
                            setState(() {
                              final index = widget.team.reminders.indexOf(
                                reminder,
                              );
                              widget.team.reminders[index] = TeamReminder(
                                id: reminder.id,
                                title: reminder.title,
                                description: reminder.description,
                                dateTime: reminder.dateTime,
                                frequency: reminder.frequency,
                                multipleDates: reminder.multipleDates,
                                assignedToEmail: reminder.assignedToEmail,
                                createdByEmail: reminder.createdByEmail,
                                createdAt: reminder.createdAt,
                                isCompleted: !reminder.isCompleted,
                              );
                            });
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateReminderDialog,
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
