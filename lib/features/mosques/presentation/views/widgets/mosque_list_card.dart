import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/features/mosques/domain/entities/mosque.dart';
import 'package:material_ui/material_ui.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';


class MosqueListCard extends StatelessWidget {
  final Mosque mosque;
  final bool isNearest;
  final VoidCallback onTap;
  final VoidCallback onDirections;

  const MosqueListCard({
    super.key,
    required this.mosque,
    this.isNearest = false,
    required this.onTap,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isNearest
              ? appColors.accentGold.withValues(alpha: 0.6)
              : appColors.cardBorder,
          width: isNearest ? 1.2 : 0.8,
        ),
        boxShadow: appColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            AppHaptics.light();
            onTap();
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              mosque.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          if (isNearest)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: appColors.accentGold.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                'mosque_nearest'.tr(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: appColors.accentGold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Gap(4.h),
                      Text(
                        mosque.street ?? 'cairo_egypt'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: appColors.textMuted,
                          fontSize: 11.sp,
                        ),
                      ),
                      Gap(6.h),
                      Row(
                        children: [
                          _buildSubPill(
                            context,
                            icon: Icons.place_outlined,
                            text: mosque.formattedDistance,
                            color: theme.colorScheme.primary,
                          ),
                          Gap(8.w),
                          _buildSubPill(
                            context,
                            icon: Icons.directions_walk_rounded,
                            text: 'walking_approx'
                                .tr(namedArgs: {'time': mosque.walkingMinutes.toString()}),
                            color: appColors.accentGold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Gap(8.w),
                IconButton(
                  onPressed: () {
                    AppHaptics.medium();
                    onDirections();
                  },
                  icon: Icon(
                    Icons.navigation_rounded,
                    color: theme.colorScheme.primary,
                    size: 24.sp,
                  ),
                  tooltip: 'get_directions'.tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubPill(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12.sp, color: color),
        Gap(3.w),
        Text(
          text,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
