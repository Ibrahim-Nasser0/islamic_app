import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/onboarding/presentation/views/widgets/onboarding_permission_tile.dart';
import '../services/native/permission_readiness_cubit.dart';
import '../services/native/permission_readiness_state.dart';
import '../theme/typography.dart';
import '../utils/extensions.dart';
import '../utils/haptics.dart';
import 'custom_bottom_sheet.dart';
import 'custom_button.dart';
import 'islamic/octagonal_icon_frame.dart';

/// Guided interactive sheet listing all 5 Adhan, alert & location permissions.
class PermissionsChecklistSheet extends StatefulWidget {
  final VoidCallback? onUpdated;
  const PermissionsChecklistSheet({super.key, this.onUpdated});

  static Future<void> show(
    BuildContext context,
    PermissionReadinessCubit cubit, {
    VoidCallback? onUpdated,
  }) {
    cubit.refresh();
    return showCustomBottomSheet(
      context: context,
      child: BlocProvider.value(
        value: cubit,
        child: PermissionsChecklistSheet(onUpdated: onUpdated),
      ),
    );
  }

  @override
  State<PermissionsChecklistSheet> createState() =>
      _PermissionsChecklistSheetState();
}

class _PermissionsChecklistSheetState extends State<PermissionsChecklistSheet> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: () {
        if (!mounted) return;
        context.read<PermissionReadinessCubit>().refresh();
        widget.onUpdated?.call();
      },
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
      child: SingleChildScrollView(
        child: BlocBuilder<PermissionReadinessCubit, PermissionReadinessState>(
          builder: (context, state) {
            final cubit = context.read<PermissionReadinessCubit>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    OctagonalIconFrame(
                      size: 42,
                      active: state.isAllReady,
                      child: Icon(
                        state.isAllReady
                            ? Icons.verified_user_rounded
                            : Icons.notifications_active_rounded,
                        size: 20.sp,
                        color: state.isAllReady
                            ? appColors.statusSuccess
                            : appColors.accentGold,
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'perm_sheet_title'.tr(),
                            style: AppTypography.h3.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Gap(2.h),
                          Text(
                            state.isAllReady
                                ? 'perm_all_ready'.tr()
                                : 'perm_sheet_subtitle'.tr(),
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              color: appColors.textMuted,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                  granted: state.exactAlarmsGranted,
                  onTap: () {
                    AppHaptics.light();
                    cubit.fixExactAlarms();
                  },
                ),
                Gap(10.h),
                OnboardingPermissionTile(
                  icon: Icons.screen_lock_portrait_rounded,
                  title: 'perm_fullscreen_title'.tr(),
                  desc: 'perm_fullscreen_desc'.tr(),
                  granted: state.fullScreenIntentGranted,
                  onTap: () {
                    AppHaptics.light();
                    cubit.fixFullScreenIntent();
                  },
                ),
                Gap(10.h),
                OnboardingPermissionTile(
                  icon: Icons.battery_saver_rounded,
                  title: 'perm_battery_title'.tr(),
                  desc: 'perm_battery_desc'.tr(),
                  granted: state.batteryUnrestricted,
                  onTap: () {
                    AppHaptics.light();
                    cubit.fixBatteryOptimization();
                  },
                ),
                Gap(18.h),
                CustomButton(
                  text: state.isCoreReady ? 'ok'.tr() : 'perm_grant_all'.tr(),
                  isLoading: state.isBusy,
                  icon: state.isCoreReady
                      ? Icons.check_rounded
                      : Icons.verified_user_rounded,
                  onPressed: () async {
                    AppHaptics.medium();
                    if (state.isCoreReady) {
                      Navigator.of(context).pop();
                    } else {
                      await cubit.requestEssentialBatch();
                      widget.onUpdated?.call();
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
