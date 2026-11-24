import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/services/native/permission_readiness_cubit.dart';
import '../../../../core/services/native/permission_readiness_state.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/widgets.dart';

/// Banner prompting the user when essential notification or location permissions are missing.
class HomePermissionBanner extends StatelessWidget {
  final VoidCallback? onPermissionsUpdated;
  const HomePermissionBanner({super.key, this.onPermissionsUpdated});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return BlocBuilder<PermissionReadinessCubit, PermissionReadinessState>(
      builder: (context, state) {
        if (state.isCoreReady) return const SizedBox.shrink();

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
          child: Row(
            children: [
              OctagonalIconFrame(
                size: 38,
                active: true,
                child: Icon(
                  Icons.notifications_active_rounded,
                  size: 18.sp,
                  color: appColors.accentGold,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Text(
                  'perm_home_banner_title'.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                    height: 1.4,
                  ),
                ),
              ),
              Gap(8.w),
              InkWell(
                onTap: state.isBusy
                    ? null
                    : () async {
                        AppHaptics.medium();
                        await context
                            .read<PermissionReadinessCubit>()
                            .requestEssentialBatch();
                        onPermissionsUpdated?.call();
                      },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        appColors.emeraldBevelTop,
                        appColors.emeraldBevelBottom,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: appColors.accentGold.withValues(alpha: 0.5),
                      width: 0.9,
                    ),
                  ),
                  child: Text(
                    'perm_home_banner_cta'.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: appColors.accentGold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
