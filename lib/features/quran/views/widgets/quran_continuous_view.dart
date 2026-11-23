import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:quran/quran.dart' as quran;

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import 'ayah_end_symbol.dart';

/// Continuous Mushaf page view rendering verses in flowing Uthmani text
class QuranContinuousView extends StatelessWidget {
  final int surahNumber;
  final int totalVerses;
  final double fontSize;
  final Function(int ayahNumber) onAyahTap;

  const QuranContinuousView({
    super.key,
    required this.surahNumber,
    required this.totalVerses,
    required this.fontSize,
    required this.onAyahTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: appColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: appColors.accentGold.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      child: Text.rich(
        TextSpan(
          children: List.generate(totalVerses, (index) {
            final verseNum = index + 1;
            final verseText = quran.getVerse(
              surahNumber,
              verseNum,
              verseEndSymbol: false,
            );

            return TextSpan(
              children: [
                TextSpan(
                  text: '$verseText ',
                  style: AppTypography.quranAyah.copyWith(
                    fontSize: fontSize.sp,
                    color: theme.colorScheme.onSurface,
                    height: 2.2,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: AyahEndSymbol(
                    ayahNumber: verseNum,
                    fontSize: fontSize,
                    onTap: () => onAyahTap(verseNum),
                  ),
                ),
                const TextSpan(text: ' '),
              ],
            );
          }),
        ),
        textAlign: TextAlign.justify,
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
