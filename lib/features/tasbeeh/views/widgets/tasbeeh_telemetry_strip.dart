import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/extensions.dart';

/// Session & Lifetime Tasbeeh totals strip rendered at the bottom of controls dock.
class TasbeehTelemetryStrip extends StatelessWidget {
  final int sessionTotal;
  final int lifetimeTotal;

  const TasbeehTelemetryStrip({
    super.key,
    required this.sessionTotal,
    required this.lifetimeTotal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: appColors.cardBorder, width: 0.8),
        boxShadow: appColors.cardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: _MetricCell(
              label: 'tasbeeh_session_label'.tr(),
              value: '$sessionTotal',
              valueColor: appColors.accentGold,
              mutedColor: appColors.textMuted,
            ),
          ),
          Container(width: 1, height: 22.h, color: appColors.cardBorder),
          Expanded(
            child: _MetricCell(
              label: 'tasbeeh_lifetime_label'.tr(),
              value: '$lifetimeTotal',
              valueColor: theme.colorScheme.onSurface,
              mutedColor: appColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final Color mutedColor;

  const _MetricCell({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10.5.sp, color: mutedColor),
        ),
        Gap(2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            fontFeatures: const [FontFeature.tabularFigures()],
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
