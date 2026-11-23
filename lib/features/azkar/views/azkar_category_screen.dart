import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/custom_skeleton.dart';
import '../presentation/cubit/azkar_cubit.dart';
import '../presentation/cubit/azkar_state.dart';
import 'widgets/azkar_completion_banner.dart';
import 'widgets/azkar_progress_hud.dart';
import 'widgets/dhikr_interactive_card.dart';

class AzkarCategoryScreen extends StatelessWidget {
  final String categoryId;

  const AzkarCategoryScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AzkarCubit>()..selectCategory(categoryId),
      child: const _AzkarCategoryView(),
    );
  }
}

class _AzkarCategoryView extends StatelessWidget {
  const _AzkarCategoryView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AzkarCubit, AzkarState>(
      builder: (context, state) {
        final category = state.activeCategory;
        final title = category != null ? category.titleKey.tr() : 'azkar'.tr();

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: theme.colorScheme.onSurface,
                size: 20.sp,
              ),
              onPressed: () {
                AppHaptics.light();
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            centerTitle: true,
          ),
          body: state.isLoading || category == null
              ? _buildLoadingSkeleton()
              : _buildContent(context, state),
        );
      },
    );
  }

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          CustomSkeleton(height: 80.h, borderRadius: 16.r),
          Gap(16.h),
          Expanded(
            child: ListView.separated(
              itemCount: 3,
              separatorBuilder: (_, index) => Gap(12.h),
              itemBuilder: (_, index) => CustomSkeleton(
                height: 140.h,
                borderRadius: 20.r,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AzkarState state) {
    final category = state.activeCategory!;
    final cubit = context.read<AzkarCubit>();

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 40.h),
      children: [
        AzkarProgressHud(
          category: category,
          onReset: () => cubit.resetActiveCategory(),
        ),
        if (category.isAllCompleted) ...[
          Gap(16.h),
          const AzkarCompletionBanner(),
        ],
        Gap(16.h),
        ...category.items.map((item) {
          return Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: DhikrInteractiveCard(
              item: item,
              onTap: () => cubit.decrementDhikr(item.id),
            ),
          );
        }),
      ],
    );
  }
}
