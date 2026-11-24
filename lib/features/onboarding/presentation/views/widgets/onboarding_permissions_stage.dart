import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import 'package:islamic_app/core/services/native/permission_readiness_cubit.dart';
import 'package:islamic_app/core/services/native/permission_readiness_state.dart';
import 'package:islamic_app/core/theme/typography.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/core/widgets/widgets.dart';
import '../../models/page_view_item_model.dart';
import 'onboarding_permission_tile.dart';

/// Interactive Onboarding slide requesting Notifications, Location, and Exact Alarm permissions.
class OnboardingPermissionsStage extends StatelessWidget {
  final PageViewItemModel model;
  const OnboardingPermissionsStage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: BlocBuilder<PermissionReadinessCubit, PermissionReadinessState>(
        builder: (context, state) {
          final cubit = context.read<PermissionReadinessCubit>();
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: appColors.badgeBackground,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: appColors.accentGold.withValues(alpha: 0.35)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RubElHizbMark(size: 12.w, color: appColors.accentGold),
                    Gap(6.w),
                    Text(
                      model.badgeText,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: appColors.accentGold,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(12.h),
              Text(
                model.title,
                textAlign: TextAlign.center,
                style: AppTypography.quranAyah.copyWith(
                  fontSize: 23.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  height: 1.35,
                ),
              ),
              Gap(6.h),
              Text(
                model.subtitle,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(color: appColors.textMuted),
              ),
              Gap(16.h),
              OnboardingPermissionTile(
                icon: Icons.notifications_active_rounded,
                title: 'perm_notif_title'.tr(),
                desc: 'perm_notif_desc'.tr(),
                granted: state.notificationsGranted,
                onTap: () {
                  AppHaptics.medium();
                  cubit.requestNotifications();
                },
              ),
              Gap(10.h),
              OnboardingPermissionTile(
                icon: Icons.location_on_rounded,
                title: 'perm_loc_title'.tr(),
                desc: 'perm_loc_desc'.tr(),
                granted: state.locationGranted,
                onTap: () {
                  AppHaptics.medium();
                  cubit.requestLocation();
                },
              ),
              Gap(10.h),
              OnboardingPermissionTile(
                icon: Icons.alarm_on_rounded,
                title: 'perm_exact_title'.tr(),
                desc: 'perm_exact_desc'.tr(),
                granted: state.exactAlarmsGranted && state.batteryUnrestricted,
                onTap: () {
                  AppHaptics.light();
                  if (!state.exactAlarmsGranted) {
                    cubit.fixExactAlarms();
                  } else {
                    cubit.fixBatteryOptimization();
                  }
                },
              ),
              if (!state.isCoreReady) ...[
                Gap(16.h),
                CustomButton(
                  text: 'perm_grant_all'.tr(),
                  isLoading: state.isBusy,
                  icon: Icons.verified_user_rounded,
                  onPressed: () {
                    AppHaptics.medium();
                    cubit.requestEssentialBatch();
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
