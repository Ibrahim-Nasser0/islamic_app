import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:material_ui/material_ui.dart';


import '../../models/page_view_item_model.dart';
import 'islamic_mihrab_frame.dart';

class OnboardingHeroStage extends StatelessWidget {
  final PageViewItemModel model;

  const OnboardingHeroStage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Column(
      children: [
        IslamicMihrabFrame(
          size: 200,
          child: Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  appColors.accentGold.withValues(alpha: 0.25),
                  theme.colorScheme.primary.withValues(alpha: 0.12),
                  theme.colorScheme.surface,
                ],
              ),
              border: Border.all(
                color: appColors.accentGold.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: appColors.accentGold.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              model.icon,
              size: 56.sp,
              color: appColors.accentGold,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: 0, end: -6, duration: 2200.ms, curve: Curves.easeInOutSine),
        ),
        Gap(18.h),
        // Floating feature pill badges
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.w,
          runSpacing: 6.h,
          children: model.featureTags.map((tag) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: appColors.badgeBackground,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: appColors.accentGold.withValues(alpha: 0.25),
                  width: 0.8,
                ),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: appColors.accentGold,
                ),
              ),
            );
          }).toList(),
        )
            .animate()
            .fade(duration: 400.ms, delay: 200.ms)
            .slideY(begin: 0.15, curve: Curves.easeOutQuart),
      ],
    );
  }
}
