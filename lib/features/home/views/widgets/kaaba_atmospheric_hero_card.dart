import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/widgets.dart';
import '../../presentation/models/time_of_day_atmosphere.dart';
import 'hero_card_countdown_badge.dart';
import 'hero_card_meta_bar.dart';
import 'hero_card_progress_track.dart';
import 'home_staggered_entry.dart';
import 'kaaba_silhouette_art.dart';

/// Atmospheric Sanctuary Hero Card with Mecca skyline, dates, prayer countdown, and interval progress.
class KaabaAtmosphericHeroCard extends StatelessWidget {
  final String location;
  final String hijriDate;
  final String gregorianDate;
  final String nextPrayerName;
  final String nextPrayerTime;
  final String remainingTime;
  final String? prevPrayerLabel;
  final double intervalProgress;
  final bool isManualLocation;
  final bool isRefreshingLocation;
  final VoidCallback? onLocationTap;

  const KaabaAtmosphericHeroCard({
    super.key,
    this.location = 'القاهرة، مصر',
    this.hijriDate = '15 شعبان 1448 هـ',
    this.gregorianDate = '23 نوفمبر',
    this.nextPrayerName = 'الظهر',
    this.nextPrayerTime = '11:45 ص',
    this.remainingTime = '01:15:00',
    this.prevPrayerLabel,
    this.intervalProgress = 0.0,
    this.isManualLocation = false,
    this.isRefreshingLocation = false,
    this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    final atmosphere = DayAtmosphere.resolveCurrent();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: atmosphere.gradientColors,
        ),
        border: Border.all(
          color: atmosphere.accentColor.withValues(alpha: 0.36),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: atmosphere.gradientColors.first.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          ManuscriptCorners(color: atmosphere.accentColor.withValues(alpha: 0.45)),
          PositionedDirectional(
            bottom: -4.h,
            end: -6.w,
            child: Opacity(
              opacity: 0.34,
              child: KaabaSilhouetteArt(
                goldColor: atmosphere.accentColor,
                phase: atmosphere.phase,
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                  colors: [
                    atmosphere.gradientColors.first.withValues(alpha: 0.42),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeroCardMetaBar(
                  location: location, hijriDate: hijriDate, gregorianDate: gregorianDate,
                  atmosphere: atmosphere, isManualLocation: isManualLocation,
                  isRefreshingLocation: isRefreshingLocation, onLocationTap: onLocationTap,
                ),
                Gap(16.h),
                _NextPrayerRow(nextPrayerName: nextPrayerName, atmosphere: atmosphere),
                Gap(14.h),
                HeroCardCountdownBadge(
                  nextPrayerTime: nextPrayerTime, remainingTime: remainingTime, atmosphere: atmosphere,
                ),
                Gap(14.h),
                HeroCardProgressTrack(
                  prevPrayerLabel: prevPrayerLabel, nextPrayerName: nextPrayerName,
                  progress: intervalProgress, atmosphere: atmosphere,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NextPrayerRow extends StatelessWidget {
  final String nextPrayerName;
  final DayAtmosphere atmosphere;

  const _NextPrayerRow({required this.nextPrayerName, required this.atmosphere});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 6.w,
                runSpacing: 4.h,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: atmosphere.accentColor.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      RubElHizbMark(size: 10.w, color: atmosphere.accentColor),
                      SizedBox(width: 5.w),
                      Text(
                        'next_prayer'.tr(),
                        style: TextStyle(fontSize: 11.sp, color: atmosphere.accentColor, fontWeight: FontWeight.bold),
                      ),
                    ]),
                  ),
                  Text(
                    atmosphere.phaseLabelKey.tr(),
                    style: TextStyle(fontSize: 10.5.sp, color: Colors.white.withValues(alpha: 0.72), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Gap(6.h),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'prayer_name_format'.tr(namedArgs: {'name': nextPrayerName}),
                  style: AppTypography.quranAyah.copyWith(fontSize: 25.sp, fontWeight: FontWeight.bold, color: Colors.white, height: 1.25),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        SanctuaryBreathingPulse(
          child: Container(
            width: 44.w, height: 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.22),
              border: Border.all(color: atmosphere.accentColor.withValues(alpha: 0.38), width: 1.0),
            ),
            child: Icon(atmosphere.skyIcon, size: 22.sp, color: atmosphere.accentColor),
          ),
        ),
      ],
    );
  }
}
