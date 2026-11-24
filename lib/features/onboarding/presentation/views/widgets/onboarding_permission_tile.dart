import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../core/utils/extensions.dart';
import '../../../../../core/widgets/widgets.dart';

/// Interactive permission status card displayed inside the Onboarding readiness slide.
class OnboardingPermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final bool granted;
  final VoidCallback onTap;

  const OnboardingPermissionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
    required this.granted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: granted
              ? appColors.statusSuccess.withValues(alpha: 0.45)
              : appColors.cardBorder,
          width: 0.9,
        ),
      ),
      child: Row(
        children: [
          OctagonalIconFrame(
            size: 40,
            active: granted,
            child: Icon(icon, size: 18.sp, color: appColors.accentGold),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Gap(2.h),
                Text(desc, style: TextStyle(fontSize: 11.sp, color: appColors.textMuted)),
              ],
            ),
          ),
          Gap(8.w),
          InkWell(
            onTap: granted ? null : onTap,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: granted
                    ? appColors.statusSuccess.withValues(alpha: 0.14)
                    : appColors.navActivePillBg,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: granted ? appColors.statusSuccess : appColors.accentGold.withValues(alpha: 0.45),
                  width: 0.8,
                ),
              ),
              child: Text(
                granted ? 'perm_granted'.tr() : 'perm_grant_now'.tr(),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: granted ? appColors.statusSuccess : appColors.accentGold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
