import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/di/injection_container.dart' as di;
import '../../../core/theme/typography.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../presentation/cubit/settings_cubit.dart';
import '../presentation/cubit/settings_state.dart';
import '../presentation/views/widgets/settings_about_card.dart';
import '../presentation/views/widgets/settings_hero_header.dart';
import '../presentation/views/widgets/settings_language_card.dart';
import '../presentation/views/widgets/settings_location_card.dart';
import '../presentation/views/widgets/settings_lockscreen_card.dart';
import '../presentation/views/widgets/settings_notification_card.dart';
import '../presentation/views/widgets/settings_share_card.dart';
import '../presentation/views/widgets/settings_theme_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<SettingsCubit>()..refreshReliability(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isAr = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'settings'.tr(),
        showBackButton: true,
        showSettingsButton: false,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Hero Sanctuary Header
                SettingsHeroHeader(
                  athanEnabled: state.athanSound,
                  locationName: state.getDisplayLocation(isAr),
                ),
                Gap(20.h),

                // Section 1: Worship & Adhan
                _buildSectionTitle('worship_and_alerts'.tr(), appColors),
                Gap(10.h),
                SettingsLocationCard(
                  currentLocationName: state.getDisplayLocation(isAr),
                  isManual: state.isManualLocation,
                  onLocationChanged: (nameAr, nameEn, isManual, lat, lng) {
                    if (isManual) {
                      cubit.setManualLocation(
                        lat: lat,
                        lng: lng,
                        nameAr: nameAr,
                        nameEn: nameEn,
                      );
                    } else {
                      cubit.resetToGps(
                        lat: lat,
                        lng: lng,
                        nameAr: nameAr,
                        nameEn: nameEn,
                      );
                    }
                  },
                ),
                Gap(10.h),
                SettingsNotificationCard(
                  prayerNotification: state.prayerNotification,
                  prePrayerNotification: state.prePrayerNotification,
                  azkarNotification: state.azkarNotification,
                  athanSound: state.athanSound,
                  selectedMuadhin: state.selectedMuadhin,
                  onPrayerChanged: cubit.setPrayerNotification,
                  onPrePrayerChanged: cubit.setPrePrayerNotification,
                  onAzkarChanged: cubit.setAzkarNotification,
                  onAthanChanged: cubit.setAthanSound,
                  onMuadhinChanged: cubit.setMuadhinVoice,
                ),
                Gap(10.h),
                SettingsLockscreenCard(
                  adhanLockscreen: state.adhanLockscreen,
                  isReliabilityOptimal: state.isReliabilityOptimal,
                  onLockscreenChanged: cubit.setAdhanLockscreen,
                  onPreviewAdhan: cubit.previewNativeAdhan,
                  onPreviewAzkar: cubit.previewNativeAzkar,
                  onFixPermissions: cubit.fixMissingPermissions,
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
          );
        },
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
