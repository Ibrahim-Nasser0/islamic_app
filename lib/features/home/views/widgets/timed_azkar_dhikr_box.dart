import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../azkar/domain/entities/dhikr_item.dart';
import 'timed_azkar_ring_counter.dart';

/// Interactive sanctuary box for the active timed dhikr with animated transition
/// and circular rosary tap ring.
class TimedAzkarDhikrBox extends StatelessWidget {
  final DhikrItem active;
  final int currentStep;
  final int totalItems;
  final VoidCallback onTap;

  const TimedAzkarDhikrBox({
    super.key,
    required this.active,
    this.currentStep = 1,
    this.totalItems = 1,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          AppHaptics.selection();
          onTap();
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: appColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: appColors.accentGold.withValues(alpha: 0.28),
              width: 0.85,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: appColors.badgeBackground,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'timed_azkar_dhikr_progress'.tr(
                        namedArgs: {
                          'current': '$currentStep',
                          'total': '$totalItems',
                        },
                      ),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: appColors.accentGold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (active.reference != null && active.reference!.isNotEmpty)
                    Flexible(
                      child: Text(
                        active.reference!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: appColors.textMuted,
                        ),
                      ),
                    ),
                ],
              ),
              Gap(10.h),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Text(
                  active.arabicText,
                  key: ValueKey<String>(active.id),
                  textAlign: TextAlign.center,
                  style: AppTypography.quranAyah.copyWith(
                    fontSize: 16.5.sp,
                    color: theme.colorScheme.onSurface,
                    height: 1.8,
                  ),
                ),
              ),
              if (active.fadl != null && active.fadl!.isNotEmpty) ...[
                Gap(8.h),
                Text(
                  active.fadl!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: appColors.accentGold.withValues(alpha: 0.9),
                    height: 1.45,
                  ),
                ),
              ],
              Gap(12.h),
              Row(
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    size: 14.sp,
                    color: appColors.textMuted,
                  ),
                  Gap(5.w),
                  Expanded(
                    child: Text(
                      'timed_azkar_tap_hint'.tr(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: appColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TimedAzkarRingCounter(active: active),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
