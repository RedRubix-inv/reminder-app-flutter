import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:reminder_app/utils/theme.dart';

class LoadingSpinner extends StatelessWidget {
  final double size;
  final Color color;
  final bool isButton;
  const LoadingSpinner({
    super.key,
    this.size = 30.0,
    this.color = primaryColor,
    this.isButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          isButton
              ? LoadingAnimationWidget.progressiveDots(color: color, size: 45)
              : SizedBox(
                height: size,
                width: size,
                child: CircularProgressIndicator(
                  strokeWidth: size / 10,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
    );
  }
}
