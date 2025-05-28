import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:reminder_app/components/appbar_backbutton.dart';
import 'package:reminder_app/utils/router.dart';
import 'package:reminder_app/utils/theme.dart';

enum LeadingDisplayMode { avatarOnly, backWithText, backButton, title }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final LeadingDisplayMode displayMode;
  final VoidCallback? onBackPressed;
  final String? avatarImageUrl;
  final VoidCallback? onNotificationPressed;
  final String? leadingText;
  final bool showNotification;

  const CustomAppBar({
    super.key,
    this.displayMode = LeadingDisplayMode.avatarOnly,
    this.onBackPressed,
    this.avatarImageUrl,
    this.onNotificationPressed,
    this.leadingText,
    this.showNotification = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;

    // Setup leading widget based on display mode
    if (displayMode == LeadingDisplayMode.avatarOnly) {
      leadingWidget =
          avatarImageUrl != null
              ? Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(avatarImageUrl!),
                  backgroundColor: Colors.grey.shade200,
                ),
              )
              : null;
    } else if (displayMode == LeadingDisplayMode.backButton) {
      // Use the appBarBackButton directly as the leading widget
      leadingWidget = appBarBackButton(context, onPressed: onBackPressed);
    } else if (displayMode == LeadingDisplayMode.backWithText) {
      // For backWithText mode, use the backButton as the leading widget
      leadingWidget = appBarBackButton(context, onPressed: onBackPressed);
    } else {
      // For avatarOnly and title modes, leadingWidget is handled separately or null
      leadingWidget = null;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [primaryColor, primaryColor.withAlpha(0)],
        ),
      ),
      child: AppBar(
        // Set leading widget based on display mode
        leading: leadingWidget,
        automaticallyImplyLeading: false, // Don't automatically add back button
        // For backWithText mode, create a layout that has the back button on the left and centered text
        title:
            (displayMode == LeadingDisplayMode.backWithText ||
                        displayMode == LeadingDisplayMode.title) &&
                    leadingText != null
                ? displayMode == LeadingDisplayMode.backWithText
                    ? Text(
                      leadingText!,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Sora",
                      ),
                    )
                    : Text(
                      leadingText!,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Sora",
                      ),
                    )
                : null,
        centerTitle: true,
        actions: [
          if (showNotification)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  if (onNotificationPressed != null) {
                    onNotificationPressed!();
                  } else {
                    context.push(RouteName.notifications);
                  }
                },
                child: Icon(LucideIcons.bellRing, color: textColor, size: 30),
              ),
            ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
