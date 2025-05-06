import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reminder_app/components/app-textarea.dart';
import 'package:reminder_app/components/app_textfield.dart';
import 'package:reminder_app/components/button.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/components/show_toast.dart';
import 'package:reminder_app/utils/router.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';
import 'package:toastification/toastification.dart';

class CreateMeetingView extends StatefulWidget {
  const CreateMeetingView({super.key});

  @override
  State<CreateMeetingView> createState() => _CreateMeetingViewState();
}

class _CreateMeetingViewState extends State<CreateMeetingView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _agendaController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedPriority = 'Medium';
  final List<String> _invitedEmails = [];

  @override
  void dispose() {
    _titleController.dispose();
    _agendaController.dispose();
    _emailController.dispose();
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

  void _addEmail() {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        _invitedEmails.add(_emailController.text);
        _emailController.clear();
      });
    }
  }

  void _removeEmail(String email) {
    setState(() {
      _invitedEmails.remove(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        displayMode: LeadingDisplayMode.backWithText,
        leadingText: 'Create Meeting',
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
                hintText: 'Meeting Title',
                initialValue: _titleController.text,
                onChanged: (value) {
                  _titleController.text = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a meeting title';
                  }
                  return null;
                },
              ),
              const VerticalSpace(16),
              // AppTextField(
              //   hintText: 'Agenda & Description',
              //   maxLines: 3,
              //   initialValue: _agendaController.text,
              //   onChanged: (value) {
              //     _agendaController.text = value;
              //   },
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter an agenda';
              //     }
              //     return null;
              //   },
              // ),
              AppTextArea(
                hintText: "Agendas & Description",
                labelText: "Agendas & Description",
                onChanged: (value) {
                  _agendaController.text = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter agendas & description";
                  }
                  return null;
                },
                maxLength: 200, // Optional character limit
                maxLines: 6, // Optional: override default max lines
                minLines: 2, // Optional: override default min lines
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
                  const HorizontalSpace(16),
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
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items:
                    ['Low', 'Medium', 'High'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Sora",
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedPriority = newValue;
                    });
                  }
                },
              ),
              const VerticalSpace(24),
              const Text(
                'Invite Members',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const VerticalSpace(8),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      hintText: 'Enter email address',
                      initialValue: _emailController.text,
                      onChanged: (value) {
                        _emailController.text = value;
                      },
                    ),
                  ),
                  const HorizontalSpace(8),
                  IconButton(
                    onPressed: _addEmail,
                    icon: const Icon(Icons.add_circle),
                    color: primaryColor,
                  ),
                ],
              ),
              const VerticalSpace(8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    _invitedEmails.map((email) {
                      return Chip(
                        label: Text(email),
                        onDeleted: () => _removeEmail(email),
                        backgroundColor: primaryColor.withOpacity(0.1),
                        labelStyle: TextStyle(color: primaryColor),
                      );
                    }).toList(),
              ),
              const VerticalSpace(32),
              CustomButton(
                title: 'Create Meeting',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Implement meeting creation
                    showToast(
                      context,
                      type: ToastificationType.success,
                      title: 'Meeting Created!',
                      description:
                          'Meeting ${_titleController.text} created successfully',
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
