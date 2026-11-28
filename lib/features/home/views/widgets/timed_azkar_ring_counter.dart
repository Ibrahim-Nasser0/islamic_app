import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../../azkar/domain/entities/dhikr_item.dart';

/// Animated circular rosary tap indicator showing remaining repetitions inside
/// a smooth sweeping ring without neon blooms (`Rule 9`).
class TimedAzkarRingCounter extends StatelessWidget {
  final DhikrItem active;

  const TimedAzkarRingCounter({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final progress = active.progress;

    return Container(
      width: 54.w,
      height: 54.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: appColors.dhikrCounterBg,
        border: Border.all(
          color: appColors.accentGold.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 48.w,
            height: 48.w,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              builder: (_, value, _) => CircularProgressIndicator(
                value: value == 0 ? 0.04 : value,
                strokeWidth: 2.8.w,
                strokeCap: StrokeCap.round,
                backgroundColor: appColors.cardBorder.withValues(alpha: 0.35),
                valueColor: AlwaysStoppedAnimation<Color>(appColors.accentGold),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${active.remainingCount}',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  height: 1.05,
                  color: appColors.accentGold,
                ),
              ),
              Text(
                'timed_azkar_tap_circle'.tr(),
                style: TextStyle(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w600,
                  color: appColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
