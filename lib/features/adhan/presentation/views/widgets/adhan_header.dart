import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/utils/haptics.dart';

class AdhanHeader extends StatelessWidget {
  final String prayerName;
  final DateTime prayerTime;
  final String muezzinName;
  final VoidCallback onClose;

  const AdhanHeader({
    super.key,
    required this.prayerName,
    required this.prayerTime,
    required this.muezzinName,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('hh:mm a').format(prayerTime);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      child: Column(
        children: [
          _buildTopRow(),
          SizedBox(height: 10.h),
          _buildPrayerTitle(),
          SizedBox(height: 6.h),
          _buildTimePill(formattedTime),
          SizedBox(height: 12.h),
          _buildMuezzinBadge(),
        ],
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 40),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: const Color(0xFFE0B866).withValues(alpha: 0.35),
              width: 0.8.w,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star_rounded,
                size: 13.sp,
                color: const Color(0xFFFFD54F),
              ),
              SizedBox(width: 6.w),
              Text(
                'now_adhan_time'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.95),
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
        _buildCloseButton(),
      ],
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: () {
        AppHaptics.light();
        onClose();
      },
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.08),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.16),
            width: 0.8.w,
          ),
        ),
        child: Icon(
          Icons.close_rounded,
          color: Colors.white.withValues(alpha: 0.9),
          size: 18.sp,
        ),
      ),
    );
  }

  Widget _buildPrayerTitle() {
    return Text(
      prayerName,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 34.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'Amiri',
        height: 1.2,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16.r,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePill(String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.access_time_rounded,
          size: 14.sp,
          color: Colors.white.withValues(alpha: 0.75),
        ),
        SizedBox(width: 5.w),
        Text(
          time,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.85),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMuezzinBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
          width: 0.9.w,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.record_voice_over_rounded,
            size: 15.sp,
            color: const Color(0xFFFFD54F),
          ),
          SizedBox(width: 8.w),
          Text(
            muezzinName,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
