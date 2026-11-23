import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/dhikr_item.dart';

class DhikrInteractiveCard extends StatelessWidget {
  final DhikrItem item;
  final VoidCallback onTap;

  const DhikrInteractiveCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDone = item.isCompleted;

    return Container(
      decoration: BoxDecoration(
        color: isDone
            ? theme.colorScheme.primary.withValues(alpha: 0.05)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDone
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : appColors.cardBorder,
          width: isDone ? 1.2 : 0.8,
        ),
        boxShadow: appColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDone ? null : onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.all(18.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, isDone),
                Gap(14.h),
                _buildArabicText(context),
                if (item.fadl != null) ...[
                  Gap(12.h),
                  _buildFadlSection(context),
                ],
                Gap(16.h),
                _buildActionFooter(context, isDone),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDone) {
    final appColors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (item.reference != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: appColors.badgeBackground,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              item.reference!,
              style: TextStyle(
                fontSize: 11.sp,
                color: appColors.accentGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        else
          const SizedBox.shrink(),
        IconButton(
          icon: Icon(
            Icons.copy_rounded,
            size: 18.sp,
            color: appColors.textMuted,
          ),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: item.arabicText));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم نسخ الذكر بنجاح'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          tooltip: 'نسخ',
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  Widget _buildArabicText(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      item.arabicText,
      textAlign: TextAlign.center,
      style: AppTypography.dhikrText.copyWith(
        fontSize: 19.sp,
        height: 2.1,
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildFadlSection(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: appColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: 15.sp,
            color: appColors.accentGold,
          ),
          Gap(8.w),
          Expanded(
            child: Text(
              item.fadl!,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.4,
                color: appColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFooter(BuildContext context, bool isDone) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isDone ? 'تم الإنجاز' : 'المس للشاشة للعد',
          style: TextStyle(
            fontSize: 12.sp,
            color: isDone ? theme.colorScheme.primary : appColors.textMuted,
            fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isDone
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isDone) ...[
                Icon(Icons.check_rounded, color: Colors.white, size: 16.sp),
                Gap(4.w),
              ],
              Text(
                isDone ? 'مكتمل' : '${item.remainingCount}',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: isDone ? Colors.white : theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
