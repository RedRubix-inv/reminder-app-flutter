import 'package:flutter/material.dart';

class FaqState extends ChangeNotifier {
  final List<FaqItem> faqs = [
    FaqItem(
      question: 'How do I create a reminder?',
      answer: 'Tap the "+" button on the home screen to add a new reminder.',
    ),
    FaqItem(
      question: 'Can I set recurring reminders?',
      answer: 'Yes, you can set daily, weekly, or custom recurring reminders.',
    ),
    FaqItem(
      question: 'Will I get notifications?',
      answer: 'You will receive notifications based on your reminder settings.',
    ),
  ];
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}
