import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/routes/app_router.dart';
import 'package:islamic_app/core/routes/routes.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/core/widgets/animations/button_animation.dart';
import 'package:material_ui/material_ui.dart';



class OnboardingNavBar extends StatelessWidget {
  final PageController pageController;
  final int totalPages;
  final int currentPage;

  const OnboardingNavBar({
    super.key,
    required this.pageController,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isLastPage = currentPage == totalPages - 1;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicator Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages, (index) {
              final isActive = index == currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: isActive ? 24.w : 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: isActive
                      ? appColors.accentGold
                      : theme.colorScheme.primary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              );
            }),
          ),
          Gap(24.h),
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Skip Button
              if (!isLastPage)
                TextButton(
                  onPressed: () {
                    AppHaptics.light();
                    AppRouter.navigateAndReplace(context, Routes.home);
                  },
                  child: Text(
                    'skip'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: appColors.textMuted,
                    ),
                  ),
                )
              else
                const SizedBox(width: 60),

              // Next / Get Started Button
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                height: 52.h,
                width: isLastPage ? 170.w : 60.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primaryContainer,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28.r),
                  border: Border.all(
                    color: appColors.accentGold.withValues(alpha: 0.4),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      AppHaptics.medium();
                      if (isLastPage) {
                        AppRouter.navigateAndReplace(context, Routes.home);
                      } else {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutCubic,
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(28.r),
                    child: Center(
                      child: isLastPage
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'get_started'.tr(),
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Gap(8.w),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: appColors.accentGold,
                                  size: 18.sp,
                                ),
                              ],
                            )
                          : Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                    ),
                  ),
                ),
              ).buttonAnimation(),
            ],
          ),
        ],
      ),
    );
  }
}
