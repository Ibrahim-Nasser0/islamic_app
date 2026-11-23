import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../models/page_view_item_model.dart';
import 'onboarding_content_section.dart';
import 'onboarding_hero_stage.dart';

class PageViewItem extends StatelessWidget {
  final PageViewItemModel pageViewItemModel;

  const PageViewItem({
    super.key,
    required this.pageViewItemModel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Gap(20.h),
          OnboardingHeroStage(model: pageViewItemModel),
          Gap(24.h),
          OnboardingContentSection(model: pageViewItemModel),
          Gap(20.h),
        ],
      ),
    );
  }
}
