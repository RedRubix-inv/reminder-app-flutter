import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:reminder_app/models/team.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';

class TeamMembersDialog extends StatelessWidget {
  final List<TeamMember> teamMembers;
  final String title;

  const TeamMembersDialog({
    super.key,
    required this.teamMembers,
    this.title = 'Team Members',
  });

  Color _getRoleColor(TeamRole role) {
    switch (role) {
      case TeamRole.admin:
        return textColor;
      case TeamRole.moderator:
        return primaryColor;
      case TeamRole.member:
        return primaryColor;
    }
  }

  Widget _buildTeamMemberCard(TeamMember member) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name ?? member.email.split('@')[0],
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Sora',
                  ),
                ),
                const VerticalSpace(2),
                Text(
                  member.email,
                  style: TextStyle(
                    color: textColorSecondary,
                    fontSize: 14,
                    fontFamily: 'Sora',
                  ),
                ),
                const VerticalSpace(4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getRoleColor(member.role).withAlpha(30),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    member.role.toString().split('.').last.toUpperCase(),
                    style: TextStyle(
                      color: _getRoleColor(member.role),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Sora',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 800,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    LucideIcons.users2,
                    color: primaryColor,
                    size: 16,
                  ),
                ),
                const HorizontalSpace(12),
                Expanded(
                  child: Text(
                    '$title (${teamMembers.length})',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sora',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    LucideIcons.x,
                    color: textColorSecondary,
                    size: 24,
                  ),
                ),
              ],
            ),
            const VerticalSpace(16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children:
                      teamMembers
                          .map(
                            (member) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _buildTeamMemberCard(member),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
