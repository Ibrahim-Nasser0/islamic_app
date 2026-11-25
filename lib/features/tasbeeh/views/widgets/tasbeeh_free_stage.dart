import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../presentation/cubit/tasbeeh_cubit.dart';
import '../../presentation/cubit/tasbeeh_state.dart';
import 'sanctuary_astrolabe_dial.dart';
import 'tasbeeh_controls_bar.dart';
import 'tasbeeh_dhikr_selector.dart';
import 'tasbeeh_phrase_stage.dart';

/// Free Tasbeeh interactive sanctuary supporting compact & expanded layouts.
class TasbeehFreeStage extends StatelessWidget {
  final TasbeehState state;
  final TasbeehCubit cubit;
  final bool twoColumns;

  const TasbeehFreeStage({
    super.key,
    required this.state,
    required this.cubit,
    required this.twoColumns,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final item = state.currentItem;
    final virtue = item.virtueKey?.tr();

    final targetLabel = state.target > 0
        ? '${state.cycleCount} / ${state.target}'
        : 'open_target'.tr();
    final roundBadge = state.target > 0
        ? 'tasbeeh_round_badge'.tr(namedArgs: {
            'round': '${state.currentRound}',
            'total': '${item.totalCount}',
          })
        : 'tasbeeh_phrase_total'.tr(namedArgs: {'total': '${item.totalCount}'});

    final phraseStage = TasbeehPhraseStage(
      arabicText: item.arabicText,
      virtueText: virtue,
      highlighted: state.isTargetReached,
    );

    final controls = TasbeehControlsBar(
      activeTarget: state.target,
      sessionTotal: state.sessionTotal,
      lifetimeTotal: state.lifetimeTotal,
      currentCount: item.currentCount,
      onTargetChanged: cubit.setTarget,
      onDecrement: cubit.decrement,
      onReset: cubit.resetCurrent,
    );

    Widget buildDialSection(double dialDiameter) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: cubit.increment,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SanctuaryAstrolabeDial(
                count: state.cycleCount,
                cycleBadge: roundBadge,
                targetLabel: targetLabel,
                progress: state.progress,
                isMilestoneBeat: state.isTargetReached,
                diameter: dialDiameter,
                onTap: cubit.increment,
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
              children: [
                TasbeehDhikrSelector(
                  items: state.items,
                  selectedIndex: state.selectedIndex,
                  onSelect: cubit.selectDhikr,
                ),
                Gap(12.h),
                phraseStage,
                Gap(14.h),
                controls,
              ],
            ),
          ),
          Gap(20.w),
          Expanded(
            flex: 5,
            child: Center(child: buildDialSection(248.0)),
          ),
        ],
      );
    }

    final screenH = MediaQuery.sizeOf(context).height;
    final screenW = MediaQuery.sizeOf(context).width;
    final dialSize = (screenH * 0.28).clamp(184.0, 248.0).clamp(170.0, screenW * 0.68);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TasbeehDhikrSelector(
          items: state.items,
          selectedIndex: state.selectedIndex,
          onSelect: cubit.selectDhikr,
        ),
        Gap(10.h),
        phraseStage,
        Gap(8.h),
        buildDialSection(dialSize),
        Gap(8.h),
        controls,
      ],
    );
  }
}
