import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import 'ayah_end_symbol.dart';

/// Single Ayah Tile in Ayah-by-Ayah reading mode with bookmark and copy actions
class QuranAyahTile extends StatelessWidget {
  final int surahNumber;
  final int ayahNumber;
  final String verseText;
  final double fontSize;
  final bool isBookmarked;
  final VoidCallback onToggleBookmark;
  final VoidCallback onSetLastRead;

  const QuranAyahTile({
    super.key,
    required this.surahNumber,
    required this.ayahNumber,
    required this.verseText,
    required this.fontSize,
    required this.isBookmarked,
    required this.onToggleBookmark,
    required this.onSetLastRead,
  });

  void _copyToClipboard(BuildContext context) {
    AppHaptics.light();
    Clipboard.setData(ClipboardData(text: '$verseText [$ayahNumber]'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ الآية الكريمة', textAlign: TextAlign.center),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isBookmarked
              ? appColors.accentGold
              : appColors.cardBorder,
          width: isBookmarked ? 1.2 : 0.8,
        ),
        boxShadow: appColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ayah Controls Bar: Number, Bookmark, Copy, Set Last Read
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AyahEndSymbol(
                ayahNumber: ayahNumber,
                fontSize: 22,
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.bookmark_add_outlined,
                      size: 20.sp,
                      color: appColors.textMuted,
                    ),
                    tooltip: 'تحديد كآخر قراءة',
                    onPressed: () {
                      AppHaptics.light();
                      onSetLastRead();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      size: 20.sp,
                      color: isBookmarked ? appColors.accentGold : appColors.textMuted,
                    ),
                    onPressed: onToggleBookmark,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.copy_rounded,
                      size: 18.sp,
                      color: appColors.textMuted,
                    ),
                    onPressed: () => _copyToClipboard(context),
                  ),
                ],
              ),
            ],
          ),
          Gap(10.h),

          // Sacred Ayah Text
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$verseText ',
                  style: AppTypography.quranAyah.copyWith(
                    fontSize: fontSize.sp,
                    color: theme.colorScheme.onSurface,
                    height: 1.85,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: AyahEndSymbol(
                    ayahNumber: ayahNumber,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
