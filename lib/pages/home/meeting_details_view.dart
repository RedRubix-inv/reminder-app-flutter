import 'package:flutter/material.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/pages/home/components/meeting_details.dart';
import 'package:reminder_app/utils/theme.dart';

class MeetingDetailsView extends StatelessWidget {
  final String title;
  final DateTime dateTime;
  final String priority;
  final String agendas;
  final String createdBy;
  final List<String> participants;

  const MeetingDetailsView({
    super.key,
    required this.title,
    required this.dateTime,
    required this.priority,
    required this.agendas,
    required this.createdBy,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        displayMode: LeadingDisplayMode.backWithText,
        leadingText: 'Meeting Details',
        onNotificationPressed: () {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MeetingDetails(
          title: title,
          dateTime: dateTime,
          priority: priority,
          createdBy: createdBy,
          agendas: agendas,
          participants: participants,
        ),
      ),
    );
  }
}
