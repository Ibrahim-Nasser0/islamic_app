import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import 'package:quran/quran.dart' as quran;

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';

/// Islamic ornamental header banner displayed at the beginning of each Surah
class SurahHeaderBanner extends StatelessWidget {
  final int surahNumber;

  const SurahHeaderBanner({
    super.key,
    required this.surahNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final isMakki = quran.getPlaceOfRevelation(surahNumber) == 'Makkah';
    final totalVerses = quran.getVerseCount(surahNumber);
    final surahName = quran.getSurahNameArabic(surahNumber);
    final showBasmala = surahNumber != 1 && surahNumber != 9;

    return Column(
      children: [
        // Ornamental Arch Frame
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: appColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: appColors.accentGold.withValues(alpha: 0.4),
              width: 1.0,
            ),
          ),
          child: Column(
            children: [
              Text(
                'سُورَةُ $surahName',
                textAlign: TextAlign.center,
                style: AppTypography.quranAyah.copyWith(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: appColors.accentGold,
                ),
              ),
              Gap(4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isMakki ? 'makki'.tr() : 'madani'.tr(),
                    style: TextStyle(fontSize: 11.sp, color: appColors.textMuted),
                  ),
                  Gap(8.w),
                  Text('•', style: TextStyle(color: appColors.textMuted)),
                  Gap(8.w),
                  Text(
                    'ayahs_count'.tr(namedArgs: {'count': '$totalVerses'}),
                    style: TextStyle(fontSize: 11.sp, color: appColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
        Gap(14.h),

        // Noble Basmala (except Surah At-Tawbah)
        if (showBasmala) ...[
          Text(
            quran.basmala,
            textAlign: TextAlign.center,
            style: AppTypography.quranAyah.copyWith(
              fontSize: 21.sp,
              color: theme.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
          Gap(16.h),
        ],
      ],
    );
  }
}
