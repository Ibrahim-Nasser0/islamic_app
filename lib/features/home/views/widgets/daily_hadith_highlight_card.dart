import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../hadith/domain/entities/daily_hadith_entry.dart';
import '../../../hadith/presentation/cubit/daily_hadith_cubit.dart';
import '../../../hadith/presentation/cubit/daily_hadith_state.dart';
import '../../../hadith/views/widgets/hadith_grade_badge.dart';
import 'daily_hadith_card_header.dart';

/// Illuminated Manuscript folio card showcasing one random Sahih Hadith daily.
class DailyHadithHighlightCard extends StatelessWidget {
  const DailyHadithHighlightCard({super.key});

  String _bookTitleKey(String bookId) => switch (bookId) {
        'bukhari' || 'sahih_bukhari' => 'sahih_bukhari',
        'muslim' || 'sahih_muslim' => 'sahih_muslim',
        'riyad' || 'riyad_assalihin' => 'riyad_assalihin',
        _ => 'nawawi_forty',
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return BlocBuilder<DailyHadithCubit, DailyHadithState>(
      builder: (context, state) {
        if (state.isLoading && state.entry == null) {
          return CustomSkeleton(height: 196.h, borderRadius: 18);
        }
        return _buildCard(context, theme, appColors, state.entry);
      },
    );
  }

  Widget _buildCard(
    BuildContext context,
    ThemeData theme,
    AppThemeColors appColors,
    DailyHadithEntry? entry,
  ) {
    final hadithText =
        entry != null ? '« ${entry.hadith.arabicText} »' : 'daily_hadith_text'.tr();
    final narratorText =
        entry != null ? entry.hadith.narrator : 'narrated_by_bukhari_muslim'.tr();
    final bookStamp = entry != null
        ? '${_bookTitleKey(entry.bookId).tr()} • ${entry.hadith.number}'
        : null;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: appColors.accentGold.withValues(alpha: 0.42),
              width: 0.9,
            ),
            boxShadow: appColors.cardShadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18.r),
              onTap: entry == null
                  ? null
                  : () {
                      AppHaptics.light();
                      AppRouter.navigateTo(
                        context,
                        Routes.hadithDetail,
                        arguments: {'hadith': entry.hadith},
                      );
                    },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DailyHadithCardHeader(
                    bookStamp: bookStamp,
                    onShuffle: () => context.read<DailyHadithCubit>().shuffleHadith(),
                  ),
                  const GoldHairlineDivider(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: 3.w,
                                decoration: BoxDecoration(
                                  color: appColors.accentGold.withValues(alpha: 0.72),
                                  borderRadius: BorderRadius.circular(999.r),
                                ),
                              ),
                              Gap(10.w),
                              Expanded(
                                child: Text(
                                  hadithText,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.quranAyah.copyWith(
                                    fontSize: 17.sp,
                                    height: 1.72,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(10.h),
                        Row(
                          children: [
                            Icon(
                              Icons.record_voice_over_rounded,
                              size: 13.sp,
                              color: appColors.accentGold,
                            ),
                            Gap(6.w),
                            Expanded(
                              child: Text(
                                narratorText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: appColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(10.h),
                        Row(
                          children: [
                            if (entry != null) ...[
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: HadithGradeBadge(
                                    hadith: entry.hadith,
                                    compact: true,
                                  ),
                                ),
                              ),
                              Gap(8.w),
                              Text(
                                'hadith_read_more'.tr(),
                                style: TextStyle(
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w700,
                                  color: appColors.accentGold,
                                ),
                              ),
                              Gap(3.w),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 11.sp,
                                color: appColors.accentGold,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const ManuscriptCorners(inset: 7, length: 10),
      ],
    );
  }
}
