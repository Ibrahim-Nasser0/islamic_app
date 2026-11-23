import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:islamic_app/core/utils/constants.dart';
import 'package:islamic_app/features/onboarding/presentation/models/page_view_item_model.dart';
import 'package:islamic_app/features/onboarding/presentation/views/widgets/on_boarding_circular_next_button.dart';
import 'package:islamic_app/features/onboarding/presentation/views/widgets/page_view_item.dart';

class OnBoardingPageView extends StatefulWidget {
  const OnBoardingPageView({super.key});

  @override
  State<OnBoardingPageView> createState() => _OnBoardingPageViewState();
}

class _OnBoardingPageViewState extends State<OnBoardingPageView> {
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<PageViewItemModel> onBoardingPages =
        AppConstants.onBoardingPages(context);
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: onBoardingPages.length,
            itemBuilder: (context, index) {
              return PageViewItem(
                pageController: pageController,
                pageViewItemModel: onBoardingPages[index],
              );
            },
          ),
        ),
        Gap(16.h),
        AnimatedBuilder(
          animation: pageController,
          builder: (context, child) {
            return OnBoardingCircularNextButton(
              pageController: pageController,
              totalPages: onBoardingPages.length,
            );
          },
        ),
        Gap(48.h),
      ],
    );
  }
}
