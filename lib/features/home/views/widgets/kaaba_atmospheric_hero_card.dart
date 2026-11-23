import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../presentation/models/time_of_day_atmosphere.dart';
import 'kaaba_silhouette_art.dart';

/// Cinematic Atmospheric Hero Card with Dynamic Sky & Kaaba Silhouette
class KaabaAtmosphericHeroCard extends StatelessWidget {
  final String location;
  final String hijriDate;
  final String gregorianDate;
  final String nextPrayerName;
  final String nextPrayerTime;
  final String remainingTime;

  const KaabaAtmosphericHeroCard({
    super.key,
    this.location = 'القاهرة، مصر',
    this.hijriDate = '15 شعبان 1448 هـ',
    this.gregorianDate = '23 نوفمبر',
    this.nextPrayerName = 'الظهر',
    this.nextPrayerTime = '11:45 ص',
    this.remainingTime = 'متبقي 01 س و 15 د',
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
                Gap(20.h),
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
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 0.8),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on_rounded, size: 14.sp, color: atmosphere.accentColor),
              SizedBox(width: 4.w),
              Text(
                location,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ],
          ),
        ),
        Text(
          '$hijriDate • $gregorianDate',
          style: TextStyle(fontSize: 12.sp, color: Colors.white.withValues(alpha: 0.85)),
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
            Text(
              'الصلاة القادمة',
              style: TextStyle(fontSize: 13.sp, color: atmosphere.accentColor, fontWeight: FontWeight.w600),
            ),
            Gap(4.h),
            Text(
              'صلاة $nextPrayerName',
              style: AppTypography.h2.copyWith(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.12),
          ),
          child: Icon(atmosphere.skyIcon, size: 26.sp, color: atmosphere.accentColor),
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
            fontSize: 36.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: atmosphere.accentColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: atmosphere.accentColor.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            remainingTime,
            style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.bold, color: const Color(0xFF141A16)),
          ),
        ),
      ],
    );
  }
}
