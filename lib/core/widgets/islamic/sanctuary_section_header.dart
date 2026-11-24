import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import '../../theme/typography.dart';
import '../../utils/extensions.dart';
import 'rub_el_hizb_mark.dart';

/// Unified section heading anchored with a gold Rub el-Hizb emblem.
class SanctuarySectionHeader extends StatelessWidget {
  final String title;
  final String? badgeText;

  const SanctuarySectionHeader({
    super.key,
    required this.title,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Row(
      children: [
        RubElHizbMark(size: 16.w, color: appColors.accentGold),
        Gap(8.w),
        Expanded(
          child: Text(
            title,
            style: AppTypography.h4.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        if (badgeText != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: appColors.badgeBackground,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: appColors.accentGold.withValues(alpha: 0.25),
                width: 0.8,
              ),
            ),
            child: Text(
              badgeText!,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: appColors.accentGold,
              ),
            ),
          ),
      ],
    );
  }
}
