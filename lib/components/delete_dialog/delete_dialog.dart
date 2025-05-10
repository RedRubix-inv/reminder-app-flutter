import 'package:flutter/material.dart';
import 'package:reminder_app/utils/theme.dart';

class DeleteDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onDelete;
  final String? deleteButtonText;
  final String? cancelButtonText;

  const DeleteDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onDelete,
    this.deleteButtonText,
    this.cancelButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Sora',
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          color: textColorSecondary,
          fontSize: 16,
          fontFamily: 'Sora',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            cancelButtonText ?? 'Cancel',
            style: TextStyle(
              color: textColorSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Sora',
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDelete();
          },
          child: Text(
            deleteButtonText ?? 'Delete',
            style: TextStyle(
              color: errorColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Sora',
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
