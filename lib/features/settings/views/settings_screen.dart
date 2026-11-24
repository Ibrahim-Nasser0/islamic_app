import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/typography.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../presentation/models/muadhin_option.dart';
import '../presentation/views/widgets/settings_about_card.dart';
import '../presentation/views/widgets/settings_hero_header.dart';
import '../presentation/views/widgets/settings_language_card.dart';
import '../presentation/views/widgets/settings_notification_card.dart';
import '../presentation/views/widgets/settings_share_card.dart';
import '../presentation/views/widgets/settings_theme_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _prayerNotification = true;
  bool _azkarNotification = true;
  bool _athanSound = true;
  MuadhinOption _selectedMuadhin = MuadhinOption.defaultList.first;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _prayerNotification = prefs.getBool('prayer_notifications') ?? true;
      _azkarNotification = prefs.getBool('azkar_notifications') ?? true;
      _athanSound = prefs.getBool('athan_sound') ?? true;
      final savedMuadhinId = prefs.getString('muadhin_voice') ?? 'makkah';
      _selectedMuadhin = MuadhinOption.defaultList.firstWhere(
        (m) => m.id == savedMuadhinId,
        orElse: () => MuadhinOption.defaultList.first,
      );
    });
  }

  Future<void> _updatePref(String key, dynamic val) async {
    final prefs = await SharedPreferences.getInstance();
    if (val is bool) {
      await prefs.setBool(key, val);
    } else if (val is String) {
      await prefs.setString(key, val);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'settings'.tr(),
        showBackButton: true,
        showSettingsButton: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Hero Sanctuary Header
            SettingsHeroHeader(athanEnabled: _athanSound),
            Gap(20.h),

            // Section 1: Worship & Adhan
            _buildSectionTitle('worship_and_alerts'.tr(), appColors),
            Gap(10.h),
            SettingsNotificationCard(
              prayerNotification: _prayerNotification,
              azkarNotification: _azkarNotification,
              athanSound: _athanSound,
              selectedMuadhin: _selectedMuadhin,
              onPrayerChanged: (val) {
                setState(() => _prayerNotification = val);
                _updatePref('prayer_notifications', val);
              },
              onAzkarChanged: (val) {
                setState(() => _azkarNotification = val);
                _updatePref('azkar_notifications', val);
              },
              onAthanChanged: (val) {
                setState(() => _athanSound = val);
                _updatePref('athan_sound', val);
              },
              onMuadhinChanged: (muadhin) {
                setState(() => _selectedMuadhin = muadhin);
                _updatePref('muadhin_voice', muadhin.id);
              },
            ),
            Gap(20.h),

            // Section 2: Atmosphere & Language
            _buildSectionTitle('atmosphere_and_language'.tr(), appColors),
            Gap(10.h),
            const SettingsThemeCard(),
            Gap(10.h),
            const SettingsLanguageCard(),
            Gap(20.h),

            // Section 3: Ongoing Charity & Blessings
            _buildSectionTitle('good_deeds_and_sharing'.tr(), appColors),
            Gap(10.h),
            const SettingsShareCard(),
            Gap(10.h),
            const SettingsAboutCard(),
            Gap(24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, dynamic appColors) {
    return Row(
      children: [
        Container(
          width: 3.5.w,
          height: 14.h,
          decoration: BoxDecoration(
            color: appColors.accentGold,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        Gap(8.w),
        Text(
          title,
          style: AppTypography.h4.copyWith(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
