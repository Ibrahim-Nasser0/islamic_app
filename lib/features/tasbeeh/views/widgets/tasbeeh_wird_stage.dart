import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../presentation/cubit/tasbeeh_cubit.dart';
import '../../presentation/cubit/tasbeeh_state.dart';
import 'sanctuary_astrolabe_dial.dart';
import 'tasbeeh_phrase_stage.dart';
import 'wird_empty_card.dart';
import 'wird_items_horizontal_list.dart';
import 'wird_progress_header.dart';

/// Daily Structured Wird stage with completion celebration and empty-state safety.
class TasbeehWirdStage extends StatelessWidget {
  final TasbeehState state;
  final TasbeehCubit cubit;
  final VoidCallback onCustomize;
  final bool twoColumns;

  const TasbeehWirdStage({
    super.key,
    required this.state,
    required this.cubit,
    required this.onCustomize,
    required this.twoColumns,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final enabled = state.enabledWirdItems;
    final active = state.activeWirdItem;

    final header = WirdProgressHeader(
      completedCount: state.wirdCompletedCount,
      totalCount: state.wirdTotalEnabled,
      progress: state.wirdOverallProgress,
      onCustomize: onCustomize,
      onReset: cubit.resetWird,
    );

    if (enabled.isEmpty || active == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          Gap(20.h),
          WirdEmptyCard(onCustomize: onCustomize),
        ],
      );
    }

    final activeIdx = enabled.indexOf(active).clamp(0, enabled.length - 1);
    final rem = (active.targetCount - active.currentCount).clamp(0, 1 << 30);
    final targetLabel = active.isCompleted
        ? 'item_completed'.tr()
        : 'remaining_count'.tr(namedArgs: {'count': '$rem'});

    final stepper = WirdItemsHorizontalList(
      items: enabled,
      activeIndex: activeIdx,
      onSelect: (idx) => cubit.selectWirdItem(state.wirdItems.indexOf(enabled[idx])),
    );

    final phraseStage = TasbeehPhraseStage(
      arabicText: active.arabicText,
      virtueText: 'target_count'.tr(namedArgs: {'count': '${active.targetCount}'}),
      highlighted: active.isCompleted,
    );

    final undoPill = Align(
      alignment: AlignmentDirectional.centerEnd,
      child: InkWell(
        onTap: active.currentCount > 0 ? cubit.decrementWird : null,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: appColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: appColors.cardBorder, width: 0.8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.undo_rounded,
                size: 14.sp,
                color: active.currentCount > 0
                    ? appColors.accentGold
                    : appColors.textMuted,
              ),
              Gap(4.w),
              Text(
                '-1',
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.bold,
                  color: active.currentCount > 0
                      ? appColors.accentGold
                      : appColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget buildDial(double d) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: cubit.incrementWird,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SanctuaryAstrolabeDial(
                count: active.currentCount,
                cycleBadge: 'daily_wird'.tr(),
                targetLabel: targetLabel,
                progress: active.progress,
                isCompleted: active.isCompleted,
                diameter: d,
                onTap: cubit.incrementWird,
              ),
              Gap(10.h),
              Text(
                'tap_anywhere_to_count'.tr(),
                style: TextStyle(fontSize: 11.5.sp, color: appColors.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    if (twoColumns) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [header, Gap(12.h), stepper, Gap(12.h), phraseStage, Gap(10.h), undoPill],
            ),
          ),
          Gap(20.w),
          Expanded(flex: 5, child: Center(child: buildDial(248.0))),
        ],
      );
    }

    final screenH = MediaQuery.sizeOf(context).height;
    final screenW = MediaQuery.sizeOf(context).width;
    final dialSize = (screenH * 0.28).clamp(184.0, 248.0).clamp(170.0, screenW * 0.68);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [header, Gap(10.h), stepper, Gap(10.h), phraseStage, Gap(8.h), buildDial(dialSize), undoPill],
    );
  }
}
