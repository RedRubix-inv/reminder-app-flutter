enum TeamRole { admin, member, moderator }

class TeamMember {
  final String email;
  final TeamRole role;
  final String? name;

  TeamMember({required this.email, required this.role, this.name});
}

enum ReminderFrequency { oneTime, multipleDates, weekday, weekend }

class TeamReminder {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final ReminderFrequency frequency;
  final List<DateTime>? multipleDates;
  final String assignedToEmail;
  final String createdByEmail;
  final DateTime createdAt;
  final bool isCompleted;

  TeamReminder({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.frequency,
    this.multipleDates,
    required this.assignedToEmail,
    required this.createdByEmail,
    required this.createdAt,
    this.isCompleted = false,
  });
}

class Team {
  final String id;
  final String name;
  final String description;

  final List<TeamMember> members;
  final List<TeamReminder> reminders;

  Team({
    required this.id,
    required this.name,
    required this.description,

    required this.members,
    this.reminders = const [],
  });

  int get memberCount => members.length;
}
