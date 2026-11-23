import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/haptics.dart';
import '../../presentation/models/time_of_day_atmosphere.dart';
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
                _buildTopMetaBar(atmosphere),
                Gap(18.h),
                _buildNextPrayerHeader(atmosphere),
                Gap(16.h),
                _buildTimeAndCountdown(atmosphere),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopMetaBar(DayAtmosphere atmosphere) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location Pill (Flexible to prevent any overflow)
        Flexible(
          child: InkWell(
            onTap: () {
              AppHaptics.light();
              onLocationTap?.call();
            },
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: atmosphere.accentColor.withValues(alpha: 0.25),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 14.sp,
                    color: atmosphere.accentColor,
                  ),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: Text(
                      location,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Gap(12.w),

        // Date Column: Hijri on top, Gregorian underneath
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              hijriDate,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: atmosphere.accentColor,
                letterSpacing: 0.2,
              ),
            ),
            Gap(2.h),
            Text(
              gregorianDate,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ],
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
                  Icon(
                    Icons.access_time_filled_rounded,
                    size: 11.sp,
                    color: atmosphere.accentColor,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'الصلاة القادمة',
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
              'صلاة $nextPrayerName',
              style: AppTypography.h2.copyWith(
                fontSize: 23.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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

  Widget _buildTimeAndCountdown(DayAtmosphere atmosphere) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          nextPrayerTime,
          style: AppTypography.h1.copyWith(
            fontSize: 34.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
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
