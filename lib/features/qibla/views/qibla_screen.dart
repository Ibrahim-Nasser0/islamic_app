import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_skeleton.dart';
import '../presentation/cubit/qibla_cubit.dart';
import '../presentation/cubit/qibla_state.dart';
import 'widgets/qibla_calibration_hint.dart';
import 'widgets/qibla_compass_dial.dart';
import 'widgets/qibla_info_card.dart';

/// Full-screen Qibla Compass Finder with live heading tracking and Astrolabe styling
class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QiblaCubit>()..initQibla(),
      child: const _QiblaContent(),
    );
  }
}

class _QiblaContent extends StatelessWidget {
  const _QiblaContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'qibla_direction'.tr(),
        showBackButton: true,
        showSettingsButton: false,
      ),
      body: SafeArea(
        child: BlocBuilder<QiblaCubit, QiblaState>(
          builder: (context, state) {
            if (state is QiblaLoading) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSkeleton(
                        width: 290.w,
                        height: 290.w,
                        borderRadius: 145,
                      ),
                      Gap(28.h),
                      CustomSkeleton(height: 80.h, borderRadius: 20),
                    ],
                  ),
                ),
              );
            }

            if (state is QiblaLoaded) {
              final data = state.data;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  children: [
                    // Location Pill Badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: appColors.badgeBackground,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: appColors.accentGold.withValues(alpha: 0.3),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 14.sp,
                            color: appColors.accentGold,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            data.locationName.isNotEmpty
                                ? data.locationName
                                : 'cairo_egypt'.tr(),
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(18.h),

                    // 1. Compass Dial (Astrolabe GPU Rendered with continuous pulse)
                    Center(child: QiblaCompassDial(data: data)),
                    Gap(26.h),

                    // 2. Info & Metrics Card with steering instructions
                    QiblaInfoCard(data: data),
                    Gap(14.h),

                    // 3. Sensor Calibration Tip
                    QiblaCalibrationHint(hasCompass: data.hasCompass),
                    Gap(16.h),
                  ],
                ),
              );
            }

            if (state is QiblaError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
