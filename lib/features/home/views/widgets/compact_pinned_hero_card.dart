import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/haptics.dart';
import '../../presentation/models/time_of_day_atmosphere.dart';

/// Compact HUD Hero Card pinned at the top when scrolling past the full Hero Card.
class CompactPinnedHeroCard extends StatelessWidget {
  final bool visible;
  final String location;
  final String nextPrayerName;
  final String nextPrayerTime;
  final String remainingTime;
  final double intervalProgress;
  final bool isManualLocation;
  final VoidCallback? onLocationTap;
  final VoidCallback? onTapToTop;

  const CompactPinnedHeroCard({
    super.key, required this.visible, required this.location,
    required this.nextPrayerName, required this.nextPrayerTime,
    required this.remainingTime, required this.intervalProgress,
    this.isManualLocation = false, this.onLocationTap, this.onTapToTop,
  });

  @override
  Widget build(BuildContext context) {
    final atmosphere = DayAtmosphere.resolveCurrent();
    final clamped = intervalProgress.clamp(0.0, 1.0);

    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, -0.35),
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Semantics(
            label: 'prayer_name_format'.tr(namedArgs: {'name': nextPrayerName}),
            child: GestureDetector(
              onTap: onTapToTop,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: atmosphere.gradientColors),
                  border: Border.all(color: atmosphere.accentColor.withValues(alpha: 0.42), width: 0.9),
                  boxShadow: [BoxShadow(color: atmosphere.gradientColors.first.withValues(alpha: 0.16), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                        child: Row(
                          children: [
                            _SkyBadge(atmosphere: atmosphere),
                            Gap(10.w),
                            Expanded(
                              child: _CompactLocationInfo(
                                nextPrayerName: nextPrayerName, location: location,
                                isManualLocation: isManualLocation, accentColor: atmosphere.accentColor,
                                onLocationTap: onLocationTap,
                              ),
                            ),
                            Gap(8.w),
                            _CompactTimeColumn(nextPrayerTime: nextPrayerTime, remainingTime: remainingTime, accentColor: atmosphere.accentColor),
                          ],
                        ),
                      ),
                      LinearProgressIndicator(
                        value: clamped, minHeight: 2.5.h,
                        backgroundColor: Colors.white.withValues(alpha: 0.14),
                        valueColor: AlwaysStoppedAnimation<Color>(atmosphere.accentColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SkyBadge extends StatelessWidget {
  final DayAtmosphere atmosphere;
  const _SkyBadge({required this.atmosphere});

  @override
  Widget build(BuildContext context) => Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.24),
          border: Border.all(color: atmosphere.accentColor.withValues(alpha: 0.40), width: 0.9),
        ),
        child: Icon(atmosphere.skyIcon, size: 17.sp, color: atmosphere.accentColor),
      );
}

class _CompactLocationInfo extends StatelessWidget {
  final String nextPrayerName, location;
  final bool isManualLocation;
  final Color accentColor;
  final VoidCallback? onLocationTap;

  const _CompactLocationInfo({
    required this.nextPrayerName,
    required this.location,
    required this.isManualLocation,
    required this.accentColor,
    this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'prayer_name_format'.tr(namedArgs: {'name': nextPrayerName}),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.quranAyah.copyWith(fontSize: 15.5.sp, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
        ),
        Gap(2.h),
        GestureDetector(
          onTap: () { AppHaptics.light(); onLocationTap?.call(); },
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(isManualLocation ? Icons.location_city_rounded : Icons.my_location_rounded, size: 10.5.sp, color: accentColor),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                location, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10.5.sp, color: Colors.white.withValues(alpha: 0.78), fontWeight: FontWeight.w500),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

class _CompactTimeColumn extends StatelessWidget {
  final String nextPrayerTime, remainingTime;
  final Color accentColor;
  const _CompactTimeColumn({required this.nextPrayerTime, required this.remainingTime, required this.accentColor});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(nextPrayerTime, style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.bold, color: Colors.white, fontFeatures: const [FontFeature.tabularFigures()])),
          Gap(3.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(14.r)),
            child: Text(
              '${'countdown_remaining'.tr()} $remainingTime',
              style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.bold, color: const Color(0xFF141A16), fontFeatures: const [FontFeature.tabularFigures()]),
            ),
          ),
        ],
      );
}
