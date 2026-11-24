import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '/../../../core/theme/theme_cubit.dart';
import '/../../../core/theme/typography.dart';
import '/../../../core/utils/extensions.dart';

class SettingsHeroHeader extends StatelessWidget {
  final bool athanEnabled;
  final String locationName;

  const SettingsHeroHeader({
    super.key,
    required this.athanEnabled,
    required this.locationName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                appColors.accentGold.withValues(alpha: 0.14),
                theme.colorScheme.primary.withValues(alpha: 0.08),
                theme.colorScheme.surface,
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: appColors.accentGold.withValues(alpha: 0.35),
              width: 1.0,
            ),
            boxShadow: appColors.cardShadow,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appColors.badgeBackground,
                      border: Border.all(
                        color: appColors.accentGold.withValues(alpha: 0.4),
                        width: 1.2,
                      ),
                    ),
                    child: Icon(
                      FlutterIslamicIcons.crescentMoon,
                      color: appColors.accentGold,
                      size: 26.sp,
                    ),
                  ),
                  Gap(14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'app_name'.tr(),
                          style: AppTypography.h3.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Gap(2.h),
                        Text(
                          'sanctuary_motto'.tr(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: appColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(14.h),
              // Sacred Quranic Verse
              Text(
                'verse_provision'.tr(),
                textAlign: TextAlign.center,
                style: AppTypography.quranAyah.copyWith(
                  fontSize: 16.sp,
                  color: appColors.accentGold,
                  fontWeight: FontWeight.w600,
                  height: 1.8,
                ),
              ),
              Gap(14.h),
              // Status Summary Badges
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8.w,
                runSpacing: 6.h,
                children: [
                  _buildPill(
                    icon: _getModeIcon(themeMode),
                    label: _getModeLabel(themeMode),
                    appColors: appColors,
                  ),
                  _buildPill(
                    icon: athanEnabled
                        ? Icons.volume_up_rounded
                        : Icons.volume_off_rounded,
                    label: athanEnabled ? 'athan_audio'.tr() : 'صامت',
                    appColors: appColors,
                  ),
                  _buildPill(
                    icon: Icons.location_on_rounded,
                    label: locationName,
                    appColors: appColors,
                  ),
                ],
              ),
            ],
          ),
        );
      },
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

  Widget _buildPill({
    required IconData icon,
    required String label,
    required dynamic appColors,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: appColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: appColors.cardBorder,
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: appColors.accentGold),
          Gap(5.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: appColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
