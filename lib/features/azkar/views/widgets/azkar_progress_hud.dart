import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/dialogs.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/haptics.dart';
import '../../domain/entities/azkar_category.dart';

class AzkarProgressHud extends StatelessWidget {
  final AzkarCategory category;
  final VoidCallback onReset;

  const AzkarProgressHud({
    super.key,
    required this.category,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final progress = category.overallProgress;

    return Container(
      padding: EdgeInsets.all(16.r),
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
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: appColors.badgeBackground,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  category.icon,
                  color: appColors.accentGold,
                  size: 20.sp,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.titleKey.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      '${category.completedItems} / ${category.totalItems} مكتمل (${(progress * 100).toInt()}%)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: appColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.refresh_rounded,
                  color: appColors.textMuted,
                  size: 20.sp,
                ),
                tooltip: 'إعادة ضبط',
                onPressed: () async {
                  AppHaptics.heavy();
                  final confirmed = await AppDialogs.confirm(
                    context,
                    title: 'reset_counter'.tr(),
                    message: 'reset_azkar_confirm'.tr(),
                    confirmText: 'reset_counter'.tr(),
                    cancelText: 'cancel'.tr(),
                  );
                  if (confirmed == true) {
                    onReset();
                  }
                },
              ),
            ],
          ),
          Gap(12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6.h,
              backgroundColor: appColors.cardBorder,
              valueColor: AlwaysStoppedAnimation<Color>(
                category.isAllCompleted
                    ? appColors.accentGold
                    : theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
