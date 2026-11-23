import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_bottom_sheet.dart';
import '../../../core/widgets/custom_segmented_control.dart';
import '../presentation/cubit/tasbeeh_cubit.dart';
import '../presentation/cubit/tasbeeh_state.dart';
import 'widgets/tasbeeh_controls_bar.dart';
import 'widgets/tasbeeh_counter_dial.dart';
import 'widgets/tasbeeh_dhikr_selector.dart';
import 'widgets/wird_active_card.dart';
import 'widgets/wird_customization_sheet.dart';
import 'widgets/wird_items_horizontal_list.dart';
import 'widgets/wird_progress_header.dart';

/// Full-screen Smart Tasbeeh supporting both Free Counter and Daily Wird modes
class TasbeehScreen extends StatelessWidget {
  const TasbeehScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TasbeehCubit(),
      child: const _TasbeehContent(),
    );
  }
}

class _TasbeehContent extends StatelessWidget {
  const _TasbeehContent();

  void _openCustomizationSheet(BuildContext context) {
    final cubit = context.read<TasbeehCubit>();
    showCustomBottomSheet(
      context: context,
      child: WirdCustomizationSheet(
        items: cubit.state.wirdItems,
        onToggle: cubit.toggleWirdItem,
        onTargetChanged: cubit.updateWirdItemTarget,
        onApplyAllTargets: cubit.setAllTargets,
        onAddCustom: cubit.addCustomWirdItem,
        onDeleteCustom: cubit.removeWirdItem,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'smart_tasbeeh'.tr(),
        showBackButton: true,
        showSettingsButton: false,
      ),
      body: SafeArea(
        child: BlocConsumer<TasbeehCubit, TasbeehState>(
          listener: (context, state) {
            if (state.isWirdCompleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'all_wird_completed'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  duration: const Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: appColors.statusSuccess,
                ),
              );
            }
          },
          builder: (context, state) {
            final isWirdMode = state.mode == TasbeehMode.wird;

            return Column(
              children: [
                Gap(10.h),
                // 1. Mode Switcher (Free Tasbeeh vs Daily Wird)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CustomSegmentedControl(
                    options: ['free_tasbeeh'.tr(), 'daily_wird'.tr()],
                    selectedIndex: isWirdMode ? 1 : 0,
                    onValueChanged: (index) {
                      context.read<TasbeehCubit>().setMode(
                            index == 1 ? TasbeehMode.wird : TasbeehMode.free,
                          );
                    },
                  ),
                ),
                Gap(12.h),

                // 2. Mode Content
                if (!isWirdMode) ...[
                  // Free Tasbeeh Carousel
                  TasbeehDhikrSelector(
                    items: state.items,
                    selectedIndex: state.selectedIndex,
                    onSelect: (index) =>
                        context.read<TasbeehCubit>().selectDhikr(index),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TasbeehCounterDial(
                            item: state.currentItem,
                            target: state.target,
                            progress: state.progress,
                            onTap: () =>
                                context.read<TasbeehCubit>().increment(),
                          ),
                          Gap(14.h),
                          Text(
                            'tap_to_count'.tr(),
                            style: TextStyle(fontSize: 12.sp, color: appColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    child: TasbeehControlsBar(
                      activeTarget: state.target,
                      sessionTotal: state.sessionTotal,
                      currentCount: state.currentItem.currentCount,
                      onTargetChanged: (t) =>
                          context.read<TasbeehCubit>().setTarget(t),
                      onReset: () =>
                          context.read<TasbeehCubit>().resetCurrent(),
                    ),
                  ),
                ] else ...[
                  // Daily Wird HUD Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: WirdProgressHeader(
                      completedCount: state.wirdCompletedCount,
                      totalCount: state.wirdTotalEnabled,
                      progress: state.wirdOverallProgress,
                      onCustomize: () => _openCustomizationSheet(context),
                      onReset: () => context.read<TasbeehCubit>().resetWird(),
                    ),
                  ),
                  Gap(12.h),

                  // Enabled Wird Items Horizontal Stepper
                  WirdItemsHorizontalList(
                    items: state.enabledWirdItems,
                    activeIndex: state.enabledWirdItems.indexOf(state.activeWirdItem ?? state.enabledWirdItems.first),
                    onSelect: (index) {
                      final item = state.enabledWirdItems[index];
                      final origIndex = state.wirdItems.indexOf(item);
                      context.read<TasbeehCubit>().selectWirdItem(origIndex);
                    },
                  ),

                  // Active Wird Center Dial
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state.activeWirdItem != null)
                            WirdActiveCard(
                              item: state.activeWirdItem!,
                              onTap: () =>
                                  context.read<TasbeehCubit>().incrementWird(),
                            ),
                          Gap(14.h),
                          Text(
                            'tap_to_count'.tr(),
                            style: TextStyle(fontSize: 12.sp, color: appColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
