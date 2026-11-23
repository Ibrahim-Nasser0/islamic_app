import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../domain/entities/quran_bookmark.dart';

/// Hero Card for Last Read Ayah with quick resume action
class QuranLastReadCard extends StatelessWidget {
  final QuranBookmark? lastRead;
  final VoidCallback onResume;

  const QuranLastReadCard({
    super.key,
    required this.lastRead,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final title = lastRead != null
        ? '${lastRead!.surahName} - آية ${lastRead!.ayahNumber}'
        : 'surah_al_kahf_last_read'.tr();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: appColors.accentGold.withValues(alpha: 0.35),
          width: 0.8,
        ),
        boxShadow: appColors.cardShadow,
      ),
      child: InkWell(
        onTap: () {
          AppHaptics.medium();
          onResume();
        },
        borderRadius: BorderRadius.circular(18.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: appColors.accentGold.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  FlutterIslamicIcons.solidQuran2,
                  color: appColors.accentGold,
                  size: 24.sp,
                ),
              ),
              Gap(14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'last_read'.tr(),
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w500,
                        color: appColors.textMuted,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      title,
                      style: AppTypography.h4.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: appColors.accentGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: appColors.accentGold.withValues(alpha: 0.4),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'resume_reading'.tr(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: appColors.accentGold,
                      ),
                    ),
                    Gap(4.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14.sp,
                      color: appColors.accentGold,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
