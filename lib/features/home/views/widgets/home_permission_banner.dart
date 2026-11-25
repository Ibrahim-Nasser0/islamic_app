import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/services/native/permission_readiness_cubit.dart';
import '../../../../core/services/native/permission_readiness_state.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/permissions_checklist_sheet.dart';
import '../../../../core/widgets/widgets.dart';

/// Banner prompting the user when essential notification, alarm, or location permissions are missing.
class HomePermissionBanner extends StatefulWidget {
  final VoidCallback? onPermissionsUpdated;
  const HomePermissionBanner({super.key, this.onPermissionsUpdated});

  @override
  State<HomePermissionBanner> createState() => _HomePermissionBannerState();
}

class _HomePermissionBannerState extends State<HomePermissionBanner> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: () {
        if (!mounted) return;
        context.read<PermissionReadinessCubit>().refresh();
        widget.onPermissionsUpdated?.call();
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
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);

    return BlocBuilder<PermissionReadinessCubit, PermissionReadinessState>(
      builder: (context, state) {
        if (state.isAllReady) return const SizedBox.shrink();
        final cubit = context.read<PermissionReadinessCubit>();
        final needsCore = !state.isCoreReady;

        final ctaButton = _BannerCtaButton(
          isBusy: state.isBusy,
          label: needsCore
              ? 'perm_home_banner_cta'.tr()
              : 'perm_adhan_setup_cta'.tr(),
          appColors: appColors,
          onTap: () async {
            AppHaptics.medium();
            if (needsCore) {
              await cubit.requestEssentialBatch();
              widget.onPermissionsUpdated?.call();
              if (context.mounted && !cubit.state.isAllReady) {
                await PermissionsChecklistSheet.show(
                  context,
                  cubit,
                  onUpdated: widget.onPermissionsUpdated,
                );
              }
            } else {
              await PermissionsChecklistSheet.show(
                context,
                cubit,
                onUpdated: widget.onPermissionsUpdated,
              );
            }
          },
        );

        final bannerTitle = needsCore
            ? 'perm_home_banner_title'.tr()
            : '${'perm_adhan_setup_title'.tr()} (${'perm_missing_count'.tr(namedArgs: {'count': '${state.missingCount}'})})';

        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: appColors.accentGold.withValues(alpha: 0.45),
              width: 0.9,
            ),
            boxShadow: appColors.cardShadow,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stackCta = constraints.maxWidth < 310 || textScale >= 1.22;
              if (stackCta) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(children: [
                      _bannerIcon(appColors),
                      Gap(12.w),
                      Expanded(child: _bannerText(theme, bannerTitle)),
                    ]),
                    Gap(10.h),
                    Align(alignment: AlignmentDirectional.centerEnd, child: ctaButton),
                  ],
                );
              }
              return Row(children: [
                _bannerIcon(appColors),
                Gap(12.w),
                Expanded(child: _bannerText(theme, bannerTitle)),
                Gap(8.w),
                ctaButton,
              ]);
            },
          ),
        );
      },
    );
  }

  Widget _bannerIcon(AppThemeColors appColors) => OctagonalIconFrame(
        size: 38,
        active: true,
        child: Icon(
          Icons.notifications_active_rounded,
          size: 18.sp,
          color: appColors.accentGold,
        ),
      );

  Widget _bannerText(ThemeData theme, String title) => Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
          height: 1.4,
        ),
      );
}

class _BannerCtaButton extends StatelessWidget {
  final bool isBusy;
  final String label;
  final AppThemeColors appColors;
  final VoidCallback onTap;

  const _BannerCtaButton({
    required this.isBusy,
    required this.label,
    required this.appColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isBusy ? null : onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [appColors.emeraldBevelTop, appColors.emeraldBevelBottom],
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: appColors.accentGold.withValues(alpha: 0.5),
            width: 0.9,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: appColors.accentGold),
        ),
      ),
    );
  }
}
