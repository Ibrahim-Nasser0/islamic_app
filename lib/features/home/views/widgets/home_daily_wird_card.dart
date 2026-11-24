import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../quran/domain/entities/daily_wird_verse.dart';
import '../../../quran/presentation/cubit/daily_wird_cubit.dart';
import '../../../quran/presentation/cubit/daily_wird_state.dart';
import 'daily_wird_actions_bar.dart';
import 'daily_wird_verses_box.dart';

/// Sequential Mushaf Daily Quran Wird card rendered beneath Timed Azkar.
class HomeDailyWirdCard extends StatelessWidget {
  const HomeDailyWirdCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return BlocBuilder<DailyWirdCubit, DailyWirdState>(
      builder: (context, state) {
        if (state.isLoading || state.slice == null) {
          return CustomSkeleton(height: 220.h, borderRadius: 18);
        }
        final slice = state.slice!;
        final cubit = context.read<DailyWirdCubit>();
        final completed = state.isCompletedForCurrentBatch;
        final badge = 'daily_wird_surah_prefix'
            .tr(namedArgs: {'name': slice.verses.first.surahNameAr});

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SanctuarySectionHeader(title: 'daily_wird_title'.tr(), badgeText: badge),
            Gap(10.h),
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(
                      color: completed
                          ? appColors.statusSuccess.withValues(alpha: 0.45)
                          : appColors.accentGold.withValues(alpha: 0.35),
                      width: 1.0,
                    ),
                    boxShadow: appColors.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildMetaHeader(context, slice, completed),
                      Gap(12.h),
                      DailyWirdVersesBox(slice: slice),
                      Gap(12.h),
                      DailyWirdActionsBar(
                        slice: slice,
                        cubit: cubit,
                        completed: completed,
                      ),
                    ],
                  ),
                ),
                const ManuscriptCorners(inset: 8, length: 12),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetaHeader(
    BuildContext context,
    DailyWirdSlice slice,
    bool completed,
  ) {
    final appColors = context.appColors;
    final first = slice.verses.first;
    final surahText =
        'daily_wird_surah_prefix'.tr(namedArgs: {'name': first.surahNameAr});
    final pageText =
        'daily_wird_page'.tr(namedArgs: {'page': '${first.pageNumber}'});

    return Row(
      children: [
        Expanded(
          child: Text(
            '$surahText • $pageText',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: appColors.accentGold,
            ),
          ),
        ),
        if (completed)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: appColors.statusSuccess.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              'daily_wird_completed_badge'.tr(),
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.bold,
                color: appColors.statusSuccess,
              ),
            ),
          )
        else
          InkWell(
            onTap: () {
              AppHaptics.light();
              AppRouter.navigateTo(
                context,
                Routes.quranReader,
                arguments: {
                  'surahNumber': first.surahNumber,
                  'initialAyah': first.ayahNumber,
                },
              );
            },
            child: Text(
              'daily_wird_open_mushaf'.tr(),
              style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.bold,
                color: appColors.accentGold,
              ),
            ),
          ),
      ],
    );
  }
}
