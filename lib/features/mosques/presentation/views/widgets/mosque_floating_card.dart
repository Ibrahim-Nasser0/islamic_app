import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/features/mosques/domain/entities/mosque.dart' show Mosque;
import 'package:material_ui/material_ui.dart';
import '/../../../core/utils/extensions.dart';
import '/../../../core/utils/haptics.dart';
import '/../../../core/widgets/animations/button_animation.dart';
import '/../../../core/widgets/custom_button.dart';


class MosqueFloatingCard extends StatelessWidget {
  final Mosque mosque;
  final VoidCallback onDirectionsPressed;
  final VoidCallback? onClose;

  const MosqueFloatingCard({
    super.key,
    required this.mosque,
    required this.onDirectionsPressed,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: appColors.cardBorder, width: 0.8),
        boxShadow: appColors.cardShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: appColors.badgeBackground,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: appColors.accentGold.withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Icon(
                  FlutterIslamicIcons.locationMosque,
                  size: 22.sp,
                  color: theme.colorScheme.primary,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mosque.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    if (mosque.street != null && mosque.street!.isNotEmpty) ...[
                      Gap(2.h),
                      Text(
                        mosque.street!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: appColors.textMuted,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onClose != null)
                IconButton(
                  onPressed: () {
                    AppHaptics.light();
                    onClose!();
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    size: 20.sp,
                    color: appColors.textMuted,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          Gap(12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            children: [
              _buildBadge(
                context,
                icon: Icons.place_outlined,
                label: mosque.formattedDistance,
                color: theme.colorScheme.primary,
              ),
              _buildBadge(
                context,
                icon: Icons.directions_walk_rounded,
                label: 'walking_approx'
                    .tr(namedArgs: {'time': mosque.walkingMinutes.toString()}),
                color: appColors.accentGold,
              ),
              _buildBadge(
                context,
                icon: Icons.directions_car_rounded,
                label: 'driving_approx'
                    .tr(namedArgs: {'time': mosque.drivingMinutes.toString()}),
                color: appColors.statusInfo,
              ),
            ],
          ),
          Gap(14.h),
          CustomButton(
            text: 'get_directions'.tr(),
            icon: Icons.navigation_rounded,
            height: 48.h,
            borderRadius: 14,
            fontSize: 14.sp,
            onPressed: onDirectionsPressed,
          ).buttonAnimation(),
        ],
      ),
    );
  }

  Widget _buildBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: appColors.cardBorder, width: 0.6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: color),
          Gap(5.w),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
