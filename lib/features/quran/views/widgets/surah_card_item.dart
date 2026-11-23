import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../domain/entities/surah_info.dart';

/// Card item representing a single Surah in the Quran Index
class SurahCardItem extends StatelessWidget {
  final SurahInfo surah;
  final VoidCallback onTap;

  const SurahCardItem({
    super.key,
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: appColors.cardBorder, width: 0.8),
        boxShadow: appColors.cardShadow,
      ),
      child: InkWell(
        onTap: () {
          AppHaptics.light();
          onTap();
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              // Surah Number Badge
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: appColors.accentGold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: appColors.accentGold.withValues(alpha: 0.35),
                    width: 0.8,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${surah.number}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: appColors.accentGold,
                  ),
                ),
              ),
              Gap(12.w),

              // Surah English Name & Revelation / Ayahs Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.nameEnglish,
                      style: AppTypography.h5.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Gap(3.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: surah.isMakki
                                ? appColors.accentGold.withValues(alpha: 0.12)
                                : theme.colorScheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            surah.isMakki ? 'makki'.tr() : 'madani'.tr(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: surah.isMakki
                                  ? appColors.accentGold
                                  : theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        Gap(8.w),
                        Text(
                          'ayahs_count'.tr(namedArgs: {'count': '${surah.totalVerses}'}),
                          style: TextStyle(fontSize: 11.sp, color: appColors.textMuted),
                        ),
                        Gap(8.w),
                        Text(
                          '${"juz".tr()} ${surah.juzNumber}',
                          style: TextStyle(fontSize: 11.sp, color: appColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arabic Calligraphic Surah Name
              Text(
                surah.nameArabic,
                style: AppTypography.quranAyah.copyWith(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.bold,
                  color: appColors.accentGold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
