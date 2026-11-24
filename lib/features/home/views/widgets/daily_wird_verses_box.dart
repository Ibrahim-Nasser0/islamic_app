import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../quran/domain/entities/daily_wird_verse.dart';

/// Parchment tablet displaying sequential Mushaf ayahs and surah separators.
class DailyWirdVersesBox extends StatelessWidget {
  final DailyWirdSlice slice;

  const DailyWirdVersesBox({super.key, required this.slice});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final List<Widget> blocks = [];
    int? prevSurah;

    for (final verse in slice.verses) {
      if (prevSurah != null && prevSurah != verse.surahNumber) {
        blocks.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              '— ${'daily_wird_surah_prefix'.tr(namedArgs: {'name': verse.surahNameAr})} —',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: appColors.accentGold,
              ),
            ),
          ),
        );
      }
      blocks.add(
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Text(
            verse.arabicText,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: AppTypography.quranAyah.copyWith(
              fontSize: 19.sp,
              color: appColors.quranAyahText,
              height: 1.9,
            ),
          ),
        ),
      );
      prevSurah = verse.surahNumber;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: appColors.quranPageBackground,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: appColors.accentGold.withValues(alpha: 0.28),
          width: 0.8,
        ),
      ),
      child: Column(children: blocks),
    );
  }
}
