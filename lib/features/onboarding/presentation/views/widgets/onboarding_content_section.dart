import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/theme/typography.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:material_ui/material_ui.dart';



import '../../models/page_view_item_model.dart';

class OnboardingContentSection extends StatelessWidget {
  final PageViewItemModel model;

  const OnboardingContentSection({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          // Category Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.25),
                width: 0.8,
              ),
            ),
            child: Text(
              model.badgeText,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          )
              .animate()
              .fade(duration: 400.ms)
              .slideY(begin: 0.2, curve: Curves.easeOutQuart),
          Gap(14.h),
          // Headline
          Text(
            model.title,
            textAlign: TextAlign.center,
            style: AppTypography.h2.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
              height: 1.35,
            ),
          )
              .animate()
              .fade(duration: 450.ms, delay: 100.ms)
              .slideY(begin: 0.2, curve: Curves.easeOutQuart),
          Gap(12.h),
          // Subtitle / Description
          Text(
            model.subtitle,
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge.copyWith(
              height: 1.65,
              fontSize: 14.sp,
              color: appColors.textMuted,
            ),
          )
              .animate()
              .fade(duration: 500.ms, delay: 200.ms)
              .slideY(begin: 0.2, curve: Curves.easeOutQuart),
        ],
      ),
    );
  }
}
