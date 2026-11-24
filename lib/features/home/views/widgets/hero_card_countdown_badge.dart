import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../presentation/models/time_of_day_atmosphere.dart';

/// Bottom row in Hero Card showing Next Prayer Time & Pill Countdown
class HeroCardCountdownBadge extends StatelessWidget {
  final String nextPrayerTime;
  final String remainingTime;
  final DayAtmosphere atmosphere;

  const HeroCardCountdownBadge({
    super.key,
    required this.nextPrayerTime,
    required this.remainingTime,
    required this.atmosphere,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              nextPrayerTime,
              style: AppTypography.h1.copyWith(
                fontSize: 34.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: atmosphere.accentColor,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: atmosphere.accentColor.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.hourglass_top_rounded,
                size: 13.sp,
                color: const Color(0xFF141A16),
              ),
              SizedBox(width: 5.w),
              Text(
                remainingTime,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF141A16),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
