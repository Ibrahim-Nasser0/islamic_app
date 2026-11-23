import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/typography.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_switcher_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _prayerNotification = true;
  bool _azkarNotification = true;
  bool _athanSound = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'settings'.tr(),
        showBackButton: true,
        showSettingsButton: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Notifications Group
            _buildSectionHeader('notifications_and_alerts'.tr()),
            Gap(10.h),
            Container(
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
                    icon: Icons.notifications_active_rounded,
                    value: _prayerNotification,
                    onChanged: (val) => setState(() => _prayerNotification = val),
                  ),
                  Divider(color: appColors.cardBorder, height: 1),
                  CustomSwitcherTile(
                    title: 'daily_azkar_notifications'.tr(),
                    subtitle: 'daily_azkar_notifications_desc'.tr(),
                    icon: Icons.favorite_rounded,
                    value: _azkarNotification,
                    onChanged: (val) => setState(() => _azkarNotification = val),
                  ),
                  Divider(color: appColors.cardBorder, height: 1),
                  CustomSwitcherTile(
                    title: 'athan_audio'.tr(),
                    subtitle: 'athan_audio_desc'.tr(),
                    icon: Icons.volume_up_rounded,
                    value: _athanSound,
                    onChanged: (val) => setState(() => _athanSound = val),
                  ),
                ],
              ),
            ),

            Gap(24.h),

            // General Group (Language)
            _buildSectionHeader('app_language'.tr()),
            Gap(10.h),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: appColors.cardBorder, width: 0.8),
                boxShadow: appColors.cardShadow,
              ),
              child: ListTile(
                leading: Icon(Icons.language_rounded, color: theme.colorScheme.primary),
                title: Text(
                  'app_language'.tr(),
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                ),
                trailing: Text(
                  context.locale.languageCode == 'ar' ? 'العربية' : 'English',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: appColors.accentGold,
                  ),
                ),
                onTap: () {
                  AppHaptics.selection();
                  final newLocale = context.locale.languageCode == 'ar'
                      ? const Locale('en')
                      : const Locale('ar');
                  context.setLocale(newLocale);
                },
              ),
            ),

            Gap(24.h),

            // App Info Section
            _buildSectionHeader('about_app'.tr()),
            Gap(10.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: appColors.cardBorder, width: 0.8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.info_outline_rounded, color: theme.colorScheme.primary),
                  ),
                  Gap(14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'app_name'.tr(),
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                        ),
                        Gap(2.h),
                        Text(
                          'app_version'.tr(),
                          style: TextStyle(fontSize: 12.sp, color: appColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.h4.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
