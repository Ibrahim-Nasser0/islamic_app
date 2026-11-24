import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/utils/haptics.dart';

class AdhanPostDuaaCard extends StatelessWidget {
  const AdhanPostDuaaCard({super.key});

  static const String _duaaArabicText =
      'اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ، وَالصَّلَاةِ القَائِمَةِ، '
      'آتِ مُحَمَّدًا الوَسِيلَةَ وَالفَضِيلَةَ، '
      'وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ';

  static const String _hadithReference = 'صحيح البخاري • حديث 614';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: const Color(0xFFE0B866).withValues(alpha: 0.32),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 20.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDecorativeTopBanner(context),
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 16.h),
            child: Column(
              children: [
                _buildDuaaText(),
                SizedBox(height: 12.h),
                _buildReferenceBadge(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeTopBanner(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE0B866).withValues(alpha: 0.12),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(23.r),
          topRight: Radius.circular(23.r),
        ),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE0B866).withValues(alpha: 0.22),
            width: 0.8.w,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_stories_rounded,
                size: 16.sp,
                color: const Color(0xFFFFD54F),
              ),
              SizedBox(width: 8.w),
              Text(
                'post_adhan_duaa'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          _buildCopyButton(context),
        ],
      ),
    );
  }

  Widget _buildCopyButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _copyDuaa(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 0.8.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.copy_rounded,
              size: 13.sp,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            SizedBox(width: 4.w),
            Text(
              'copy_duaa'.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuaaText() {
    return Text(
      _duaaArabicText,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16.5.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 2.0,
        fontFamily: 'Amiri',
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8.r,
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        _hadithReference,
        style: TextStyle(
          fontSize: 11.sp,
          color: const Color(0xFFE0B866).withValues(alpha: 0.9),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _copyDuaa(BuildContext context) {
    AppHaptics.light();
    Clipboard.setData(const ClipboardData(text: _duaaArabicText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
            SizedBox(width: 8.w),
            Text(
              'duaa_copied'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1F2937),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
