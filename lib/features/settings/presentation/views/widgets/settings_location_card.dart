import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/core/widgets/custom_bottom_sheet.dart';
import 'package:material_ui/material_ui.dart';

import 'location_selector_sheet.dart';
import 'settings_icon_badge.dart';

class SettingsLocationCard extends StatelessWidget {
  final String currentLocationName;
  final bool isManual;
  final void Function(
    String nameAr,
    String nameEn,
    bool isManual,
    double lat,
    double lng,
  ) onLocationChanged;

  const SettingsLocationCard({
    super.key,
    required this.currentLocationName,
    required this.isManual,
    required this.onLocationChanged,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            AppHaptics.light();
            showCustomBottomSheet(
              context: context,
              child: LocationSelectorSheet(
                currentLocationName: currentLocationName,
                isManual: isManual,
                onLocationSelected: onLocationChanged,
              ),
            );
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                const SettingsIconBadge(icon: Icons.location_on_rounded),
                Gap(14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'location_settings'.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Gap(3.h),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              currentLocationName,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: appColors.accentGold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Gap(6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: isManual
                                  ? appColors.textMuted.withValues(alpha: 0.15)
                                  : appColors.accentGold
                                      .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              isManual
                                  ? 'manual_location'.tr()
                                  : 'gps_active'.tr(),
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: isManual
                                    ? appColors.textMuted
                                    : appColors.accentGold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: appColors.accentGold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: appColors.accentGold.withValues(alpha: 0.3),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'change_location'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: appColors.accentGold,
                        ),
                      ),
                      Gap(4.w),
                      Icon(
                        Icons.edit_location_alt_rounded,
                        size: 14.sp,
                        color: appColors.accentGold,
                      ),
                    ],
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
