import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/routes/app_router.dart';
import 'package:islamic_app/core/routes/routes.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/features/onboarding/presentation/models/page_view_item_model.dart';
import 'package:material_ui/material_ui.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    required this.pageViewItemModel,
    required this.pageController,
  });

  final PageViewItemModel pageViewItemModel;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isLastPage = pageController.hasClients &&
        (pageController.page?.round() ?? 0) == 3;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48),
                  if (!isLastPage)
                    TextButton(
                      onPressed: () => AppRouter.navigateAndReplace(
                        context,
                        Routes.home,
                      ),
                      child: Text(
                        'تخطي',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: appColors.accentGold,
                        ),
                      ),
                    ).animate().fade(duration: 300.ms)
                  else
                    const SizedBox(width: 48),
                ],
              ),
            ),
          ),
          Gap(24.h),
          _buildHeroEmblem(theme, appColors),
          Gap(36.h),
          _buildContent(theme, appColors),
        ],
      ),
    );
  }

  Widget _buildHeroEmblem(ThemeData theme, dynamic appColors) {
    return Container(
      width: 220.w,
      height: 220.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.15),
            appColors.accentGold.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(
          color: appColors.accentGold.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 150.w,
          height: 150.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primaryContainer,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            pageViewItemModel.icon,
            size: 64.sp,
            color: Colors.white,
          ),
        ),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 500.ms,
          curve: Curves.easeOutBack,
        )
        .fadeIn(duration: 400.ms);
  }

  Widget _buildContent(ThemeData theme, dynamic appColors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: appColors.badgeBackground,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: appColors.accentGold.withValues(alpha: 0.3),
                width: 1.0,
              ),
            ),
            child: Text(
              pageViewItemModel.badgeText,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: appColors.accentGold,
              ),
            ),
          )
              .animate()
              .fade(duration: 400.ms)
              .slideY(begin: 0.2, curve: Curves.easeOutQuart),
          Gap(16.h),
          Text(
            pageViewItemModel.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          )
              .animate()
              .fade(duration: 400.ms, delay: 100.ms)
              .slideY(begin: 0.2, curve: Curves.easeOutQuart),
          Gap(12.h),
          Text(
            pageViewItemModel.subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: appColors.textSecondary,
            ),
          )
              .animate()
              .fade(duration: 400.ms, delay: 200.ms)
              .slideY(begin: 0.2, curve: Curves.easeOutQuart),
        ],
      ),
    );
  }
}
