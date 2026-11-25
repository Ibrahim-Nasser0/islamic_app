import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/dialogs.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import 'tasbeeh_telemetry_strip.dart';

/// Control dock with target presets [33, 99, 100, ∞], Undo (-1), Reset, and telemetry.
class TasbeehControlsBar extends StatelessWidget {
  final int activeTarget;
  final int sessionTotal;
  final int lifetimeTotal;
  final int currentCount;
  final ValueChanged<int> onTargetChanged;
  final VoidCallback onDecrement;
  final VoidCallback onReset;

  static const List<int> _targets = [33, 99, 100, 0];

  const TasbeehControlsBar({
    super.key,
    required this.activeTarget,
    required this.sessionTotal,
    required this.lifetimeTotal,
    required this.currentCount,
    required this.onTargetChanged,
    required this.onDecrement,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: _targets.map((t) {
                return _TargetChip(
                  label: t > 0 ? '$t' : '∞',
                  selected: t == activeTarget,
                  appColors: appColors,
                  theme: theme,
                  onTap: () => onTargetChanged(t),
                );
              }).toList(),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DockActionPill(
                  icon: Icons.undo_rounded,
                  label: '-1',
                  enabled: currentCount > 0,
                  accentColor: appColors.accentGold,
                  appColors: appColors,
                  onTap: onDecrement,
                ),
                Gap(6.w),
                _DockActionPill(
                  icon: Icons.refresh_rounded,
                  label: 'reset_counter'.tr(),
                  enabled: currentCount > 0,
                  accentColor: theme.colorScheme.error,
                  appColors: appColors,
                  onTap: () async {
                    AppHaptics.heavy();
                    final confirmed = await AppDialogs.confirm(
                      context,
                      title: 'reset_confirm_title'.tr(),
                      message: 'reset_confirm_message'.tr(),
                      icon: Icons.refresh_rounded,
                      iconColor: theme.colorScheme.error,
                      confirmButtonColor: theme.colorScheme.error,
                      confirmText: 'reset_counter',
                      cancelText: 'cancel',
                    );
                    if (confirmed == true) onReset();
                  },
                ),
              ],
            ),
          ],
        ),
        Gap(12.h),
        TasbeehTelemetryStrip(
          sessionTotal: sessionTotal,
          lifetimeTotal: lifetimeTotal,
        ),
      ],
    );
  }
}

class _TargetChip extends StatelessWidget {
  final String label;
  final bool selected;
  final AppThemeColors appColors;
  final ThemeData theme;
  final VoidCallback onTap;

  const _TargetChip({
    required this.label,
    required this.selected,
    required this.appColors,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: selected ? appColors.accentGold : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected ? appColors.accentGold : appColors.cardBorder,
            width: 0.9,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            fontFeatures: const [FontFeature.tabularFigures()],
            color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _DockActionPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final Color accentColor;
  final AppThemeColors appColors;
  final VoidCallback onTap;

  const _DockActionPill({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.accentColor,
    required this.appColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = enabled ? accentColor : appColors.textMuted;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: appColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: appColors.cardBorder, width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15.sp, color: fg),
            Gap(4.w),
            Text(label, style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.bold, color: fg)),
          ],
        ),
      ),
    );
  }
}
