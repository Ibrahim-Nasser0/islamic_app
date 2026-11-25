import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../presentation/models/time_of_day_atmosphere.dart';

/// Architectural Prayer Window Track displaying elapsed time from previous to next prayer.
class HeroCardProgressTrack extends StatelessWidget {
  final String? prevPrayerLabel;
  final String nextPrayerName;
  final double progress;
  final DayAtmosphere atmosphere;

  const HeroCardProgressTrack({
    super.key,
    this.prevPrayerLabel,
    required this.nextPrayerName,
    required this.progress,
    required this.atmosphere,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    final pct = (clamped * 100).round();
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (prevPrayerLabel != null && prevPrayerLabel!.isNotEmpty)
              Flexible(
                child: Text(
                  prevPrayerLabel!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
            Text(
              '$nextPrayerName · $pct%',
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w700,
                color: atmosphere.accentColor.withValues(alpha: 0.95),
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        Gap(7.h),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final beadSize = 9.r;
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: clamped),
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOutCubic,
              builder: (context, animVal, _) {
                final fillWidth = (width * animVal).clamp(6.0, width);
                final rawOffset = (width * animVal) - (beadSize / 2);
                final beadPos =
                    rawOffset.clamp(0.0, (width - beadSize).clamp(0.0, width));

                return SizedBox(
                  height: 12.r,
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      Container(
                        height: 4.h,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Container(
                          height: 4.h,
                          width: fillWidth,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                atmosphere.accentColor.withValues(alpha: 0.55),
                                atmosphere.accentColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                      ),
                      Positioned(
                        left: isRtl ? null : beadPos,
                        right: isRtl ? beadPos : null,
                        child: Container(
                          width: beadSize,
                          height: beadSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: atmosphere.accentColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
