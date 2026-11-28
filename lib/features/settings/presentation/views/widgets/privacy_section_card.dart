import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/extensions.dart';
import 'settings_icon_badge.dart';

/// Structured privacy disclosure card with icon badge, title, and body points.
class PrivacySectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const PrivacySectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: appColors.cardBorder, width: 0.8),
        boxShadow: appColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SettingsIconBadge(icon: icon, size: 36.w),
              Gap(12.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.h4.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          Gap(10.h),
          Divider(color: appColors.cardBorder, height: 1),
          Gap(10.h),
          Text(
            body,
            style: TextStyle(
              fontSize: 12.8.sp,
              height: 1.6,
              color: appColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
