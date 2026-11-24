import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/../../../core/utils/haptics.dart';

class AdhanPostDuaaCard extends StatelessWidget {
  const AdhanPostDuaaCard({super.key});

  static const String _duaaArabicText =
      'اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ، وَالصَّلَاةِ القَائِمَةِ، '
      'آتِ مُحَمَّدًا الوَسِيلَةَ وَالفَضِيلَةَ، '
      'وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ';

  static const String _hadithReference = 'رواه البخاري (حديث 614)';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
          width: 1.w,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          SizedBox(height: 12.h),
          Text(
            _duaaArabicText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.9,
              fontFamily: 'Amiri',
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            _hadithReference,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withValues(alpha: 0.75),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 18.sp,
              color: const Color(0xFFFFD54F),
            ),
            SizedBox(width: 8.w),
            Text(
              'post_adhan_duaa'.tr(),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => _copyDuaa(context),
          icon: Icon(
            Icons.copy_rounded,
            size: 18.sp,
            color: Colors.white.withValues(alpha: 0.85),
          ),
          tooltip: 'copy_duaa'.tr(),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  void _copyDuaa(BuildContext context) {
    AppHaptics.light();
    Clipboard.setData(const ClipboardData(text: _duaaArabicText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'duaa_copied'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
