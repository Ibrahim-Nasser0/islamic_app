import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/core/widgets/custom_switcher_tile.dart';
import 'package:material_ui/material_ui.dart';

class SettingsLockscreenCard extends StatelessWidget {
  final bool adhanLockscreen;
  final bool isReliabilityOptimal;
  final ValueChanged<bool> onLockscreenChanged;
  final VoidCallback onPreviewAdhan;
  final VoidCallback onPreviewAzkar;
  final VoidCallback onFixPermissions;

  const SettingsLockscreenCard({
    super.key,
    required this.adhanLockscreen,
    required this.isReliabilityOptimal,
    required this.onLockscreenChanged,
    required this.onPreviewAdhan,
    required this.onPreviewAzkar,
    required this.onFixPermissions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: appColors.cardBorder, width: 0.8),
        boxShadow: appColors.cardShadow,
      ),
      child: Column(
        children: [
          CustomSwitcherTile(
            title: 'adhan_lockscreen_title'.tr(),
            subtitle: 'adhan_lockscreen_desc'.tr(),
            icon: Icons.screen_lock_portrait_rounded,
            iconColor: appColors.accentGold,
            value: adhanLockscreen,
            activeSwitchIcon: Icons.visibility_rounded,
            inactiveSwitchIcon: Icons.visibility_off_rounded,
            onChanged: onLockscreenChanged,
          ),
          Divider(color: appColors.cardBorder, height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: _PreviewActionPill(
                    icon: Icons.mosque_rounded,
                    label: 'preview_native_adhan'.tr(),
                    onTap: onPreviewAdhan,
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: _PreviewActionPill(
                    icon: Icons.auto_awesome_rounded,
                    label: 'preview_native_azkar'.tr(),
                    onTap: onPreviewAzkar,
                  ),
                ),
              ],
            ),
          ),
          if (!isReliabilityOptimal) ...[
            Divider(color: appColors.cardBorder, height: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 20.sp,
                    color: theme.colorScheme.error,
                  ),
                  Gap(10.w),
                  Expanded(
                    child: Text(
                      'alarm_reliability_banner'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: theme.colorScheme.onSurface,
                        height: 1.4,
                      ),
                    ),
                  ),
                  Gap(8.w),
                  TextButton(
                    onPressed: () {
                      AppHaptics.light();
                      onFixPermissions();
                    },
                    child: Text(
                      'fix_permissions'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: appColors.accentGold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PreviewActionPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PreviewActionPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Material(
      color: theme.colorScheme.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: () {
          AppHaptics.light();
          onTap();
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          constraints: BoxConstraints(minHeight: 48.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: appColors.accentGold.withValues(alpha: 0.35),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17.sp, color: appColors.accentGold),
              Gap(6.w),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
