enum TeamRole { admin, member, viewer }

class TeamMember {
  final String email;
  final TeamRole role;
  final String? name;
  final String? avatarUrl;

  TeamMember({
    required this.email,
    required this.role,
    this.name,
    this.avatarUrl,
  });
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
  final String avatarUrl;
  final List<TeamMember> members;
  final List<TeamReminder> reminders;

  Team({
    required this.id,
    required this.name,
    required this.description,
    required this.avatarUrl,
    required this.members,
    this.reminders = const [],
  });

  int get memberCount => members.length;
}
