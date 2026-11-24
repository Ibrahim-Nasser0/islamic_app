import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/di/injection_container.dart' as di;
import 'package:islamic_app/core/routes/app_router.dart';
import 'package:islamic_app/core/routes/routes.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/core/widgets/animations/button_animation.dart';
import 'package:islamic_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:material_ui/material_ui.dart';

import 'segmented_circular_progress_painter.dart';

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

    // Icons.arrow_forward_rounded automatically mirrors in RTL via matchTextDirection.
    final IconData centerIcon =
        isLastPage ? Icons.check_rounded : Icons.arrow_forward_rounded;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Centered Next Button Surrounded by Page Progress Arcs
        GestureDetector(
          onTap: () async {
            AppHaptics.medium();
            if (!isLastPage) {
              pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
              );
            } else {
              await di.sl<SettingsLocalDataSource>().setOnboardingCompleted();
              if (!context.mounted) return;
              AppRouter.navigateAndReplace(context, Routes.home);
            }
          },
          child: SizedBox(
            width: 74.w,
            height: 74.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Surrounding Page Line Segments
                CustomPaint(
                  size: Size(74.w, 74.w),
                  painter: SegmentedCircularProgressPainter(
                    totalSegments: totalPages,
                    activeSegments: currentPage + 1,
                    activeColor: appColors.accentGold,
                    inactiveColor:
                        theme.colorScheme.primary.withValues(alpha: 0.18),
                    strokeWidth: 3.5.w,
                  ),
                ),
                // Center Action Button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primaryContainer,
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: appColors.accentGold.withValues(alpha: 0.45),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, anim) => ScaleTransition(
                      scale: anim,
                      child: child,
                    ),
                    child: Icon(
                      centerIcon,
                      key: ValueKey<IconData>(centerIcon),
                      color: isLastPage ? appColors.accentGold : Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ).buttonAnimation(),
              ],
            ),
          ),
        ),
        Gap(10.h),
        // Subtle Page Status Indicator
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            isLastPage ? 'get_started'.tr() : '${currentPage + 1} / $totalPages',
            key: ValueKey<bool>(isLastPage),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isLastPage ? FontWeight.bold : FontWeight.w600,
              color: isLastPage ? appColors.accentGold : appColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
