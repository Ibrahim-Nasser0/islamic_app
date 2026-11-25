import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/responsive/responsive_content_frame.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_bottom_sheet.dart';
import '../../../core/widgets/custom_segmented_control.dart';
import '../domain/entities/tasbeeh_feedback_mode.dart';
import '../presentation/cubit/tasbeeh_cubit.dart';
import '../presentation/cubit/tasbeeh_state.dart';
import 'widgets/tasbeeh_free_stage.dart';
import 'widgets/tasbeeh_wird_stage.dart';
import 'widgets/wird_customization_sheet.dart';

/// Full-screen Smart Tasbeeh supporting Free Counter and Daily Wird modes.
class TasbeehScreen extends StatelessWidget {
  const TasbeehScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TasbeehCubit>(),
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
      child: BlocProvider.value(
        value: cubit,
        child: BlocBuilder<TasbeehCubit, TasbeehState>(
          builder: (ctx, state) => WirdCustomizationSheet(
            items: state.wirdItems,
            onToggle: cubit.toggleWirdItem,
            onTargetChanged: cubit.updateWirdItemTarget,
            onApplyAllTargets: cubit.setAllTargets,
            onAddCustom: cubit.addCustomWirdItem,
            onDeleteCustom: cubit.removeWirdItem,
          ),
        ),
      ),
    );
  }

  IconData _feedbackIcon(TasbeehFeedbackMode mode) {
    switch (mode) {
      case TasbeehFeedbackMode.haptic:
        return Icons.vibration_rounded;
      case TasbeehFeedbackMode.soundAndHaptic:
        return Icons.volume_up_rounded;
      case TasbeehFeedbackMode.silent:
        return Icons.volume_off_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return BlocConsumer<TasbeehCubit, TasbeehState>(
      listenWhen: (prev, curr) => !prev.isWirdCompleted && curr.isWirdCompleted,
      listener: (context, state) {
        context.showSuccessSnackBar('all_wird_completed'.tr());
      },
      builder: (context, state) {
        final cubit = context.read<TasbeehCubit>();
        final isWirdMode = state.mode == TasbeehMode.wird;

        return Scaffold(
          appBar: CustomAppBar(
            title: 'smart_tasbeeh'.tr(),
            showBackButton: true,
            showSettingsButton: false,
            extraActions: [
              IconButton(
                icon: Icon(
                  _feedbackIcon(state.feedbackMode),
                  color: appColors.accentGold,
                ),
                iconSize: 21.sp,
                tooltip: state.feedbackMode.labelKey.tr(),
                onPressed: cubit.cycleFeedbackMode,
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: ResponsiveContentFrame(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final twoColumns = constraints.maxWidth >= 720;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomSegmentedControl(
                          options: ['free_tasbeeh'.tr(), 'daily_wird'.tr()],
                          selectedIndex: isWirdMode ? 1 : 0,
                          onValueChanged: (idx) => cubit.setMode(
                            idx == 1 ? TasbeehMode.wird : TasbeehMode.free,
                          ),
                        ),
                        Gap(14.h),
                        if (!isWirdMode)
                          TasbeehFreeStage(
                            state: state,
                            cubit: cubit,
                            twoColumns: twoColumns,
                          )
                        else
                          TasbeehWirdStage(
                            state: state,
                            cubit: cubit,
                            onCustomize: () => _openCustomizationSheet(context),
                            twoColumns: twoColumns,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
