import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/utils/dialogs.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/utils/haptics.dart';
import '../../../../../core/widgets/animations/button_animation.dart';
import '../../../../../core/widgets/custom_button.dart';
import 'settings_icon_badge.dart';

/// Interactive actions on the Privacy Policy screen: permissions review & email contact.
class PrivacyActionsCard extends StatelessWidget {
  final VoidCallback? onReviewPermissions;

  const PrivacyActionsCard({
    super.key,
    this.onReviewPermissions,
  });

  Future<void> _contactSupport(BuildContext context) async {
    AppHaptics.medium();
    const email = AppConfig.developerEmail;
    final mailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: const {
        'subject': 'Zad Al-Muslim Privacy Inquiry',
      },
    );

    try {
      if (await canLaunchUrl(mailUri)) {
        final launched = await launchUrl(
          mailUri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return;
      }
    } catch (e, stackTrace) {
      debugPrint('[PrivacyActionsCard] Failed to launch mail client: $e\n$stackTrace');
    }

    try {
      await Clipboard.setData(const ClipboardData(text: email));
      if (!context.mounted) return;
      await AppDialogs.success(
        context,
        title: 'privacy_contact_btn'.tr(),
        message: 'privacy_email_copied'.tr(namedArgs: {'email': email}),
      );
    } catch (e, stackTrace) {
      debugPrint('[PrivacyActionsCard] Failed to copy support email: $e\n$stackTrace');
      if (!context.mounted) return;
      AppDialogs.error(
        context,
        title: 'privacy_contact_btn'.tr(),
        message: email,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: appColors.cardBorder, width: 0.8),
        boxShadow: appColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (onReviewPermissions != null) ...[
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  AppHaptics.light();
                  onReviewPermissions?.call();
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
                  child: Row(
                    children: [
                      const SettingsIconBadge(
                        icon: Icons.admin_panel_settings_outlined,
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'privacy_review_permissions'.tr(),
                              style: TextStyle(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Gap(2.h),
                            Text(
                              'privacy_review_permissions_desc'.tr(),
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
            Gap(12.h),
            Divider(color: appColors.cardBorder, height: 1),
            Gap(14.h),
          ],
          Row(
            children: [
              Icon(
                Icons.mail_outline_rounded,
                size: 16.sp,
                color: appColors.accentGold,
              ),
              Gap(8.w),
              Expanded(
                child: Text(
                  AppConfig.developerEmail,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    color: appColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          Gap(12.h),
          CustomButton(
            text: 'privacy_contact_btn'.tr(),
            icon: Icons.email_outlined,
            height: 48.h,
            borderRadius: 14,
            onPressed: () => _contactSupport(context),
          ).buttonAnimation(),
        ],
      ),
    );
  }
}
