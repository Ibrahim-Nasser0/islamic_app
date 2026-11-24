import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '/../../../../core/utils/extensions.dart';

class SettingsHeroStatusBar extends StatelessWidget {
  final String locationName;
  final ThemeMode themeMode;
  final bool athanEnabled;

  const SettingsHeroStatusBar({
    super.key,
    required this.locationName,
    required this.themeMode,
    required this.athanEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: appColors.cardBorder,
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatusItem(
            icon: Icons.location_on_rounded,
            label: locationName,
            appColors: appColors,
          ),
          Container(
            width: 1,
            height: 14.h,
            color: appColors.cardBorder,
          ),
          _buildStatusItem(
            icon: _getModeIcon(themeMode),
            label: _getModeLabel(themeMode),
            appColors: appColors,
          ),
          Container(
            width: 1,
            height: 14.h,
            color: appColors.cardBorder,
          ),
          _buildStatusItem(
            icon: athanEnabled
                ? Icons.volume_up_rounded
                : Icons.volume_off_rounded,
            label: athanEnabled
                ? 'athan_active_label'.tr()
                : 'athan_silent_label'.tr(),
            appColors: appColors,
          ),
        ],
      ),
    );
  }

  IconData _getModeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return Icons.nightlight_round;
      case ThemeMode.light:
        return Icons.wb_sunny_rounded;
      case ThemeMode.system:
        return Icons.brightness_auto_rounded;
    }
  }

  String _getModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark_mode'.tr();
      case ThemeMode.light:
        return 'light_mode'.tr();
      case ThemeMode.system:
        return 'system_mode'.tr();
    }
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required dynamic appColors,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13.sp, color: appColors.accentGold),
        Gap(5.w),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 82.w),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: appColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
