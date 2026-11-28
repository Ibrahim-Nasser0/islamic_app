import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/config/app_config.dart';
import 'package:islamic_app/core/routes/routes.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/features/settings/presentation/views/widgets/settings_icon_badge.dart';
import 'package:material_ui/material_ui.dart';



class SettingsAboutCard extends StatelessWidget {
  const SettingsAboutCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: appColors.cardBorder, width: 0.8),
        boxShadow: appColors.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const SettingsIconBadge(icon: FlutterIslamicIcons.crescentMoon),
              Gap(14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'app_name'.tr(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      'app_version_label'.tr(
                        namedArgs: {'version': AppConfig.appVersion},
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: appColors.accentGold,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(12.h),
          Divider(color: appColors.cardBorder, height: 1),
          Gap(6.h),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                AppHaptics.light();
                Navigator.pushNamed(context, Routes.privacyPolicy);
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 2.w),
                child: Row(
                  children: [
                    const SettingsIconBadge(icon: Icons.privacy_tip_outlined),
                    Gap(12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'privacy_policy_title'.tr(),
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Gap(2.h),
                          Text(
                            'privacy_policy_subtitle'.tr(),
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              color: appColors.textMuted,
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
          Gap(6.h),
          Divider(color: appColors.cardBorder, height: 1),
          Gap(12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.graphic_eq_rounded,
                size: 13.sp,
                color: appColors.accentGold,
              ),
              Gap(6.w),
              Flexible(
                child: Text(
                  'audio_source_credit_label'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: appColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Gap(8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_rounded,
                size: 13.sp,
                color: appColors.accentGold,
              ),
              Gap(6.w),
              Flexible(
                child: Text(
                  'waqf_note'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: appColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
