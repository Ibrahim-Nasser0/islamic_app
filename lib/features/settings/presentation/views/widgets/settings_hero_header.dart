import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '/../../../../core/theme/theme_cubit.dart';
import '/../../../../core/theme/typography.dart';
import '/../../../../core/utils/extensions.dart';
import '/../../../../core/widgets/widgets.dart';
import 'settings_hero_painter.dart';
import 'settings_hero_status_bar.dart';

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
        return CustomPaint(
          painter: SettingsHeroPainter(goldColor: appColors.accentGold),
          child: Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  appColors.accentGold.withValues(alpha: 0.12),
                  theme.colorScheme.primary.withValues(alpha: 0.05),
                  theme.colorScheme.surface,
                ],
              ),
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: appColors.accentGold.withValues(alpha: 0.35),
                width: 1.0,
              ),
              boxShadow: appColors.cardShadow,
            ),
            child: Column(
              children: [
                // Identity Header
                Row(
                  children: [
                    OctagonalIconFrame(
                      size: 50,
                      active: true,
                      child: Icon(
                        FlutterIslamicIcons.crescentMoon,
                        color: appColors.accentGold,
                        size: 24.sp,
                      ),
                    ),
                    Gap(14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'app_name'.tr(),
                                style: AppTypography.quranAyah.copyWith(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                  height: 1.2,
                                ),
                              ),
                              Gap(8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: appColors.accentGold
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  'sanctuary_edition'.tr(),
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                    color: appColors.accentGold,
                                  ),
                                ),
                              ),
                            ],
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
                // Sacred Ayah Tablet (لوحة التزود)
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: appColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: appColors.accentGold.withValues(alpha: 0.22),
                      width: 0.8,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'verse_provision'.tr(),
                        textAlign: TextAlign.center,
                        style: AppTypography.quranAyah.copyWith(
                          fontSize: 15.sp,
                          color: appColors.accentGold,
                          fontWeight: FontWeight.w600,
                          height: 1.7,
                        ),
                      ),
                      Gap(4.h),
                      Text(
                        'verse_provision_surah'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          color: appColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(12.h),
                // Sleek Status Row
                SettingsHeroStatusBar(
                  locationName: locationName,
                  themeMode: themeMode,
                  athanEnabled: athanEnabled,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
