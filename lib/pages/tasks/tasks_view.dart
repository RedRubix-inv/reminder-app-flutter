import 'package:flutter/material.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/pages/tasks/components/create_task_dialog.dart';
import 'package:reminder_app/pages/tasks/components/task_card.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  final List<Task> _tasks = [
    Task(
      name: 'Design System Update',
      description: 'Update the design system with new components',
      priority: 'High',
      deadline: DateTime.now().add(const Duration(days: 2)),
      status: 'In Progress',
      assignedTo: 'John Doe',
      reminders: [
        Reminder(
          type: 'Daily',
          time: DateTime.now().add(const Duration(hours: 2)),
          isEnabled: true,
        ),
      ],
    ),
    Task(
      name: 'API Integration',
      description: 'Integrate new payment gateway API',
      priority: 'Medium',
      deadline: DateTime.now().add(const Duration(days: 5)),
      status: 'Pending',
      assignedTo: 'Jane Smith',
      reminders: [
        Reminder(
          type: 'Weekly',
          time: DateTime.now().add(const Duration(days: 1)),
          isEnabled: true,
        ),
      ],
    ),
    Task(
      name: 'API Integration',
      description: 'Integrate new payment gateway API',
      priority: 'Medium',
      deadline: DateTime.now().add(const Duration(days: 5)),
      status: 'Pending',
      assignedTo: 'Jane Smith',
      reminders: [
        Reminder(
          type: 'Weekly',
          time: DateTime.now().add(const Duration(days: 1)),
          isEnabled: true,
        ),
      ],
    ),
    Task(
      name: 'API Integration',
      description: 'Integrate new payment gateway API',
      priority: 'Medium',
      deadline: DateTime.now().add(const Duration(days: 5)),
      status: 'Pending',
      assignedTo: 'Jane Smith',
      reminders: [
        Reminder(
          type: 'Weekly',
          time: DateTime.now().add(const Duration(days: 1)),
          isEnabled: true,
        ),
      ],
    ),
  ];

  void _showCreateTaskDialog() {
    showDialog(
      context: context,
      builder:
          (context) => CreateTaskDialog(
            onCreateTask: (task) {
              setState(() {
                _tasks.add(task);
              });
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
                  'Tasks',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _showCreateTaskDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Create Task'),
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return TaskCard(task: task);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  final String name;
  final String description;
  final String priority;
  final DateTime deadline;
  final String status;
  final String assignedTo;
  final List<Reminder> reminders;

  Task({
    required this.name,
    required this.description,
    required this.priority,
    required this.deadline,
    required this.status,
    required this.assignedTo,
    required this.reminders,
  });
}

class Reminder {
  final String type;
  final DateTime time;
  final bool isEnabled;

  Reminder({required this.type, required this.time, required this.isEnabled});
}
