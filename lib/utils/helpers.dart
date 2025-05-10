String getRemainingTime(DateTime meetingTime) {
  final now = DateTime.now();
  final difference = meetingTime.difference(now);

  if (difference.isNegative) {
    return 'Meeting has started';
  }

  final days = difference.inDays;
  final hours = difference.inHours.remainder(24);
  final minutes = difference.inMinutes.remainder(60);

  if (days > 0) {
    return '$days days, $hours hours remaining';
  } else if (hours > 0) {
    return '$hours hours, $minutes minutes remaining';
  } else {
    return '$minutes minutes remaining';
  }
}

String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  final meetingDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  String dateStr;
  if (meetingDate == today) {
    dateStr = 'Today';
  } else if (meetingDate == tomorrow) {
    dateStr = 'Tomorrow';
  } else {
    dateStr = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  final timeStr =
      '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  return '$dateStr at $timeStr';
}

String formatDateToHumanReadable(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  final day = date.day;
  final month = months[date.month - 1];
  final year = date.year;

  return '$month $day${getDaySuffix(day)}, $year';
}
