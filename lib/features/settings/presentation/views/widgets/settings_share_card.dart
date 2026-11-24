import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/features/settings/presentation/views/widgets/settings_icon_badge.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../core/utils/extensions.dart';
import '../../../../../core/utils/haptics.dart';

class SettingsShareCard extends StatelessWidget {
  const SettingsShareCard({super.key});

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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            AppHaptics.medium();
            await Clipboard.setData(
              ClipboardData(text: 'share_message_content'.tr()),
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'share_copied_feedback'.tr(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: theme.colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                const SettingsIconBadge(icon: FlutterIslamicIcons.solidPrayer),
                Gap(14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'share_app_title'.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Gap(2.h),
                      Text(
                        'share_app_desc'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: appColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appColors.accentGold.withValues(alpha: 0.12),
                  ),
                  child: Icon(
                    Icons.share_rounded,
                    size: 18.sp,
                    color: appColors.accentGold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
