import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/utils/theme.dart';

import 'faq_state.dart';

class FaqView extends StatelessWidget {
  const FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FaqState(),
      child: const _FaqViewContent(),
    );
  }
}

class _FaqViewContent extends StatefulWidget {
  const _FaqViewContent();

  @override
  State<_FaqViewContent> createState() => _FaqViewContentState();
}

class _FaqViewContentState extends State<_FaqViewContent> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<FaqState>();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        displayMode: LeadingDisplayMode.backWithText,
        leadingText: "FAQs",
        showNotification: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primaryColor.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView.builder(
            itemCount: state.faqs.length,
            itemBuilder: (context, index) {
              final faq = state.faqs[index];
              return _buildFaqItem(faq.question, faq.answer);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontFamily: 'Sora',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            answer,
            style: const TextStyle(
              fontFamily: 'Sora',
              fontSize: 14,
              color: textColorSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
