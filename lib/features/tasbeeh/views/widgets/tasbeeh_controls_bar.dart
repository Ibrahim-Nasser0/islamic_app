import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/dialogs.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';

/// Control panel containing targets picker, reset button, and session counter
class TasbeehControlsBar extends StatelessWidget {
  final int activeTarget;
  final int sessionTotal;
  final int currentCount;
  final ValueChanged<int> onTargetChanged;
  final VoidCallback onReset;

  const TasbeehControlsBar({
    super.key,
    required this.activeTarget,
    required this.sessionTotal,
    required this.currentCount,
    required this.onTargetChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final targets = [33, 100, 0];

    return Column(
      children: [
        // 1. Target Selector Row & Reset Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Target Pills
            Row(
              children: targets.map((t) {
                final isSelected = t == activeTarget;
                final label = t > 0 ? '$t' : 'open_target'.tr();

                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: InkWell(
                    onTap: () => onTargetChanged(t),
                    borderRadius: BorderRadius.circular(16.r),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? appColors.accentGold
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isSelected
                              ? appColors.accentGold
                              : appColors.cardBorder,
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.black
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Reset Button with Confirmation
            InkWell(
              onTap: () async {
                if (currentCount == 0) return;
                AppHaptics.heavy();
                final confirmed = await AppDialogs.confirm(
                  context,
                  title: 'reset_confirm_title'.tr(),
                  message: 'reset_confirm_message'.tr(),
                  confirmText: 'reset_counter'.tr(),
                );
                if (confirmed == true) {
                  onReset();
                }
              },
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: appColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: appColors.cardBorder,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      size: 16.sp,
                      color: currentCount > 0 ? theme.colorScheme.error : appColors.textMuted,
                    ),
                    Gap(6.w),
                    Text(
                      'reset_counter'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: currentCount > 0 ? theme.colorScheme.error : appColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Gap(14.h),

        // 2. Session Total Pill
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: appColors.cardBorder, width: 0.8),
            boxShadow: appColors.cardShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total_tasbeeh'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: appColors.textMuted,
                ),
              ),
              Text(
                '$sessionTotal',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: appColors.accentGold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
