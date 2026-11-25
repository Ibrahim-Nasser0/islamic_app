import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/di/injection_container.dart' as di;
import 'package:islamic_app/core/routes/app_router.dart';
import 'package:islamic_app/core/routes/routes.dart';
import 'package:islamic_app/core/services/native/permission_readiness_cubit.dart';
import 'package:islamic_app/core/utils/constants.dart';
import 'package:islamic_app/core/utils/extensions.dart';
import 'package:islamic_app/core/utils/haptics.dart';
import 'package:islamic_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:material_ui/material_ui.dart';

import '../../models/page_view_item_model.dart';
import 'onboarding_nav_bar.dart';
import 'page_view_item.dart';

class OnBoardingPageView extends StatefulWidget {
  const OnBoardingPageView({super.key});

  @override
  State<OnBoardingPageView> createState() => _OnBoardingPageViewState();
}

class _OnBoardingPageViewState extends State<OnBoardingPageView> {
  late final PageController _pageController;
  late final PermissionReadinessCubit _permCubit;
  late final AppLifecycleListener _lifecycle;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _permCubit = di.sl<PermissionReadinessCubit>()..refresh();
    _lifecycle = AppLifecycleListener(onResume: () => _permCubit.refresh());
    _pageController = PageController();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) setState(() => _currentPage = page);
    });
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _permCubit.close();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<PageViewItemModel> pages = AppConstants.onBoardingPages(context);
    final appColors = context.appColors;
    final isLastPage = _currentPage == pages.length - 1;

    return BlocProvider.value(
      value: _permCubit,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: SizedBox(
                height: 38.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedOpacity(
                      opacity: isLastPage ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      child: IgnorePointer(
                        ignoring: isLastPage,
                        child: TextButton(
                          onPressed: () async {
                            AppHaptics.light();
                            await di.sl<SettingsLocalDataSource>().setOnboardingCompleted();
                            if (!context.mounted) return;
                            AppRouter.navigateAndReplace(context, Routes.home);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                            backgroundColor: appColors.badgeBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              side: BorderSide(
                                color: appColors.accentGold.withValues(alpha: 0.35),
                                width: 0.8,
                              ),
                            ),
                          ),
                          child: Text(
                            'skip'.tr(),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: appColors.accentGold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => PageViewItem(pageViewItemModel: pages[index]),
              ),
            ),
            Gap(12.h),
            OnboardingNavBar(
              pageController: _pageController,
              totalPages: pages.length,
              currentPage: _currentPage,
            ),
            Gap(24.h),
          ],
        ),
      ),
    );
  }
}
