import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';
import '../../domain/entities/qibla_data.dart';

/// Elevated HUD card providing live steering instructions and astronomical metrics
class QiblaInfoCard extends StatelessWidget {
  final QiblaData data;

  const QiblaInfoCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isAligned = data.isAligned;

    // Guidance text: Turn right, Turn left, or Facing Qibla
    final guidanceText = _resolveGuidanceText(data);
    final activeColor = isAligned ? appColors.statusSuccess : appColors.accentGold;

    return Column(
      children: [
        // 1. Steering Guidance HUD Banner
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isAligned
                ? appColors.statusSuccess.withValues(alpha: 0.12)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isAligned
                  ? appColors.statusSuccess
                  : appColors.accentGold.withValues(alpha: 0.35),
              width: 1.2,
            ),
            boxShadow: isAligned
                ? [
                    BoxShadow(
                      color: appColors.statusSuccess.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : appColors.cardShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedRotation(
                turns: isAligned ? 0 : (data.offset > 0 ? 0.05 : -0.05),
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  isAligned ? Icons.check_circle_rounded : Icons.explore_rounded,
                  size: 22.sp,
                  color: activeColor,
                ),
              ),
              Gap(10.w),
              Flexible(
                child: Text(
                  guidanceText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isAligned
                        ? appColors.statusSuccess
                        : theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Gap(14.h),

        // 2. Metrics Triad Row: Qibla Angle, Distance to Makkah, Device Heading
        Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                title: 'qibla_angle'.tr(),
                value: '${data.qiblaDirection.toStringAsFixed(1)}°',
                icon: Icons.near_me_rounded,
                theme: theme,
                appColors: appColors,
              ),
            ),
            Gap(10.w),
            Expanded(
              child: _buildMetricTile(
                title: 'distance_to_makkah'.tr(),
                value: 'km_unit'.tr(
                  namedArgs: {'count': data.distanceKm.toStringAsFixed(0)},
                ),
                icon: FlutterIslamicIcons.solidKaaba,
                theme: theme,
                appColors: appColors,
              ),
            ),
            Gap(10.w),
            Expanded(
              child: _buildMetricTile(
                title: 'compass_heading'.tr(),
                value: '${data.deviceHeading.toStringAsFixed(0)}°',
                icon: Icons.compass_calibration_rounded,
                theme: theme,
                appColors: appColors,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _resolveGuidanceText(QiblaData data) {
    if (data.isAligned) {
      return 'facing_qibla'.tr();
    }
    final degrees = data.offset.abs().toStringAsFixed(0);
    if (data.offset > 0) {
      return 'turn_right'.tr(namedArgs: {'deg': degrees});
    } else {
      return 'turn_left'.tr(namedArgs: {'deg': degrees});
    }
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required IconData icon,
    required ThemeData theme,
    required dynamic appColors,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: appColors.cardBorder, width: 0.8),
        boxShadow: appColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14.sp, color: appColors.accentGold),
              Gap(5.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 10.5.sp, color: appColors.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Gap(6.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
              letterSpacing: 0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
