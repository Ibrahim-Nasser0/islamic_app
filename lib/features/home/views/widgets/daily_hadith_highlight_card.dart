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
import '../../../../core/widgets/custom_skeleton.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../hadith/domain/entities/daily_hadith_entry.dart';
import '../../../hadith/presentation/cubit/daily_hadith_cubit.dart';
import '../../../hadith/presentation/cubit/daily_hadith_state.dart';

/// Daily random highlighted Hadith banner card backed by [DailyHadithCubit].
class DailyHadithHighlightCard extends StatelessWidget {
  const DailyHadithHighlightCard({super.key});

  String _bookTitleKey(String bookId) {
    return switch (bookId) {
      'bukhari' => 'sahih_bukhari',
      'muslim' => 'sahih_muslim',
      'riyad' => 'riyad_assalihin',
      _ => 'nawawi_forty',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return BlocBuilder<DailyHadithCubit, DailyHadithState>(
      builder: (context, state) {
        if (state.isLoading && state.entry == null) {
          return CustomSkeleton(height: 168.h, borderRadius: 18);
        }
        final entry = state.entry;
        return _buildCard(context, theme, appColors, entry);
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
    final referenceText =
        entry != null ? entry.hadith.reference : 'narrated_by_bukhari_muslim'.tr();
    final bookLabel = entry != null ? _bookTitleKey(entry.bookId).tr() : null;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                appColors.accentGold.withValues(alpha: 0.14),
                appColors.navActivePillBg,
              ],
            ),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: appColors.accentGold.withValues(alpha: 0.4),
              width: 1.0,
            ),
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
              child: Padding(
                padding: EdgeInsets.all(18.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RubElHizbMark(size: 14.w, color: appColors.accentGold),
                        Gap(8.w),
                        Expanded(
                          child: Text(
                            'hadith_of_the_day'.tr(),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: appColors.accentGold,
                            ),
                          ),
                        ),
                        if (bookLabel != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: appColors.accentGold.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Text(
                              bookLabel,
                              style: TextStyle(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w600,
                                color: appColors.accentGold,
                              ),
                            ),
                          ),
                        Gap(6.w),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.w),
                          padding: EdgeInsets.zero,
                          tooltip: 'hadith_shuffle_tooltip'.tr(),
                          icon: Icon(Icons.autorenew_rounded, size: 18.sp, color: appColors.accentGold),
                          onPressed: () {
                            AppHaptics.selection();
                            context.read<DailyHadithCubit>().shuffleHadith();
                          },
                        ),
                      ],
                    ),
                    Gap(10.h),
                    Text(
                      hadithText,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.quranAyah.copyWith(
                        fontSize: 17.sp,
                        height: 1.65,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Gap(10.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            referenceText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12.sp, color: appColors.textMuted),
                          ),
                        ),
                        if (entry != null) ...[
                          Gap(8.w),
                          Text(
                            'hadith_read_more'.tr(),
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                              color: appColors.accentGold,
                            ),
                          ),
                          Gap(3.w),
                          Icon(Icons.arrow_forward_ios_rounded, size: 11.sp, color: appColors.accentGold),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const IgnorePointer(child: ManuscriptCorners(inset: 8, length: 11)),
      ],
    );
  }
}
