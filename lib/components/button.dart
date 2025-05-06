import 'package:flutter/material.dart';
import 'package:reminder_app/components/loading_spinner.dart';
import 'package:reminder_app/utils/get_context.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;

  const CustomButton({
    super.key,
    required this.title,
    this.onPressed,
    this.isLoading = false,
    this.height = 55,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,

      child: ElevatedButton(
        onPressed: isLoading ? () {} : onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child:
            isLoading
                ? LoadingSpinner(color: getColorScheme(context).onPrimary)
                : Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "Sora",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
      ),
    );
  }
}
