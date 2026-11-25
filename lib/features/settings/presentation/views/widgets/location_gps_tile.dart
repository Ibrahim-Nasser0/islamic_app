import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/theme/colors.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:material_ui/material_ui.dart';



class LocationGpsTile extends StatelessWidget {
  final bool isManual;
  final bool isLoading;
  final VoidCallback onTap;

  const LocationGpsTile({
    super.key,
    required this.isManual,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: !isManual
                ? appColors.accentGold.withValues(alpha: 0.12)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: !isManual ? appColors.accentGold : appColors.cardBorder,
              width: 0.8,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: appColors.badgeBackground,
                  shape: BoxShape.circle,
                ),
                child: isLoading
                    ? Padding(
                        padding: EdgeInsets.all(10.r),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: appColors.accentGold,
                        ),
                      )
                    : Icon(
                        Icons.my_location_rounded,
                        size: 18.sp,
                        color: appColors.accentGold,
                      ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'gps_auto_location'.tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      'gps_auto_desc'.tr(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: appColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isManual)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: appColors.accentGold,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'gps_active'.tr(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.quranPage,
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
