import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/utils/constants.dart';
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
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<PageViewItemModel> pages = AppConstants.onBoardingPages(context);

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return PageViewItem(
                  pageViewItemModel: pages[index],
                );
              },
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
    );
  }
}
