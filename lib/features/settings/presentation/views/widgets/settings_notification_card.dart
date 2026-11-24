import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/core/widgets/custom_bottom_sheet.dart';
import 'package:islamic_app/core/widgets/custom_switcher_tile.dart';
import 'package:material_ui/material_ui.dart';


import '../../models/muadhin_option.dart';
import 'muadhin_selector_sheet.dart';

class SettingsNotificationCard extends StatelessWidget {
  final bool prayerNotification;
  final bool azkarNotification;
  final bool athanSound;
  final MuadhinOption selectedMuadhin;
  final ValueChanged<bool> onPrayerChanged;
  final ValueChanged<bool> onAzkarChanged;
  final ValueChanged<bool> onAthanChanged;
  final ValueChanged<MuadhinOption> onMuadhinChanged;

  const SettingsNotificationCard({
    super.key,
    required this.prayerNotification,
    required this.azkarNotification,
    required this.athanSound,
    required this.selectedMuadhin,
    required this.onPrayerChanged,
    required this.onAzkarChanged,
    required this.onAthanChanged,
    required this.onMuadhinChanged,
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
            title: 'prayer_notifications'.tr(),
            subtitle: 'prayer_notifications_desc'.tr(),
            icon: prayerNotification
                ? Icons.notifications_active_rounded
                : Icons.notifications_off_rounded,
            iconColor: appColors.accentGold,
            value: prayerNotification,
            activeSwitchIcon: Icons.notifications_active_rounded,
            inactiveSwitchIcon: Icons.notifications_off_rounded,
            onChanged: onPrayerChanged,
          ),
          Divider(color: appColors.cardBorder, height: 1),
          CustomSwitcherTile(
            title: 'daily_azkar_notifications'.tr(),
            subtitle: 'daily_azkar_notifications_desc'.tr(),
            icon: azkarNotification
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            iconColor: appColors.accentGold,
            value: azkarNotification,
            activeSwitchIcon: Icons.favorite_rounded,
            inactiveSwitchIcon: Icons.favorite_border_rounded,
            onChanged: onAzkarChanged,
          ),
          Divider(color: appColors.cardBorder, height: 1),
          CustomSwitcherTile(
            title: 'athan_audio'.tr(),
            subtitle: 'athan_audio_desc'.tr(),
            icon: athanSound
                ? Icons.volume_up_rounded
                : Icons.volume_off_rounded,
            iconColor: appColors.accentGold,
            value: athanSound,
            activeSwitchIcon: Icons.volume_up_rounded,
            inactiveSwitchIcon: Icons.volume_off_rounded,
            onChanged: onAthanChanged,
          ),
          if (athanSound) ...[
            Divider(color: appColors.cardBorder, height: 1),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  AppHaptics.light();
                  showCustomBottomSheet(
                    context: context,
                    child: MuadhinSelectorSheet(
                      selectedId: selectedMuadhin.id,
                      onSelect: onMuadhinChanged,
                    ),
                  );
                },
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  child: Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: appColors.badgeBackground,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.record_voice_over_rounded,
                          size: 20.sp,
                          color: appColors.accentGold,
                        ),
                      ),
                      Gap(14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'muadhin_voice'.tr(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Gap(2.h),
                            Text(
                              '${selectedMuadhin.nameKey.tr()} (${selectedMuadhin.location})',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: appColors.accentGold,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14.sp,
                        color: appColors.textMuted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
