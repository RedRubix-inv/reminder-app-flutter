import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:reminder_app/components/appbar_backbutton.dart';
import 'package:reminder_app/utils/router.dart';
import 'package:reminder_app/utils/theme.dart';

enum LeadingDisplayMode { avatarOnly, backWithText }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final LeadingDisplayMode displayMode;
  final VoidCallback? onBackPressed;
  final String? avatarImageUrl;
  final VoidCallback? onNotificationPressed;
  final String? leadingText;

  const CustomAppBar({
    super.key,
    this.displayMode = LeadingDisplayMode.avatarOnly,
    this.onBackPressed,
    this.avatarImageUrl,
    this.onNotificationPressed,
    this.leadingText,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;
    Widget? titleWidget;

    switch (displayMode) {
      case LeadingDisplayMode.avatarOnly:
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
        break;
      case LeadingDisplayMode.backWithText:
        leadingWidget = appBarBackButton(context);
        titleWidget =
            leadingText != null
                ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    leadingText!,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Sora",
                    ),
                  ),
                )
                : null;
        break;
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
        leading: leadingWidget,
        title: titleWidget != null ? Center(child: titleWidget) : null,
        centerTitle: true,
        actions: [
          if (onNotificationPressed != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () => context.push(RouteName.notifications),
                child: Icon(LucideIcons.bell, color: textColor, size: 30),
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
