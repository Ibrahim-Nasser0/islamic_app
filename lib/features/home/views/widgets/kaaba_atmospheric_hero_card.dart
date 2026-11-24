import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/widgets.dart';
import '../../presentation/models/time_of_day_atmosphere.dart';
import 'hero_card_countdown_badge.dart';
import 'hero_card_meta_bar.dart';
import 'kaaba_silhouette_art.dart';

/// Cinematic Atmospheric Hero Card with Dynamic Sky, Dates & Kaaba Silhouette
class KaabaAtmosphericHeroCard extends StatelessWidget {
  final String location;
  final String hijriDate;
  final String gregorianDate;
  final String nextPrayerName;
  final String nextPrayerTime;
  final String remainingTime;
  final VoidCallback? onLocationTap;

  const KaabaAtmosphericHeroCard({
    super.key,
    this.location = 'القاهرة، مصر',
    this.hijriDate = '15 شعبان 1448 هـ',
    this.gregorianDate = '23 نوفمبر',
    this.nextPrayerName = 'الظهر',
    this.nextPrayerTime = '11:45 ص',
    this.remainingTime = '01:15:00',
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
          color: atmosphere.accentColor.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: atmosphere.gradientColors.first.withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          ManuscriptCorners(
            color: atmosphere.accentColor.withValues(alpha: 0.45),
          ),
          Positioned(
            bottom: -10.h,
            left: -15.w,
            child: Opacity(
              opacity: 0.22,
              child: KaabaSilhouetteArt(goldColor: atmosphere.accentColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeroCardMetaBar(
                  location: location,
                  hijriDate: hijriDate,
                  gregorianDate: gregorianDate,
                  atmosphere: atmosphere,
                  onLocationTap: onLocationTap,
                ),
                Gap(18.h),
                _buildNextPrayerHeader(atmosphere),
                Gap(16.h),
                HeroCardCountdownBadge(
                  nextPrayerTime: nextPrayerTime,
                  remainingTime: remainingTime,
                  atmosphere: atmosphere,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextPrayerHeader(DayAtmosphere atmosphere) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: atmosphere.accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RubElHizbMark(size: 11.w, color: atmosphere.accentColor),
                  SizedBox(width: 5.w),
                  Text(
                    'next_prayer'.tr(),
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: atmosphere.accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Gap(6.h),
            Text(
              'prayer_name_format'.tr(namedArgs: {'name': nextPrayerName}),
              style: AppTypography.quranAyah.copyWith(
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.25,
              ),
            ),
          ],
        ),
        Container(
          width: 46.w,
          height: 46.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: 0.2),
            border: Border.all(
              color: atmosphere.accentColor.withValues(alpha: 0.35),
              width: 1.0,
            ),
          ),
          child: Icon(
            atmosphere.skyIcon,
            size: 24.sp,
            color: atmosphere.accentColor,
          ),
        ),
      ],
    );
  }
}
