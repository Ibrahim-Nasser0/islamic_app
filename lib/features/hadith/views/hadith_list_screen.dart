import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/routes/routes.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/custom_skeleton.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../presentation/cubit/hadith_cubit.dart';
import '../presentation/cubit/hadith_state.dart';
import 'widgets/hadith_card_item.dart';

class HadithListScreen extends StatelessWidget {
  final String bookId;
  final String bookTitle;

  const HadithListScreen({
    super.key,
    this.bookId = 'nawawi',
    this.bookTitle = 'الأربعون النووية',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HadithCubit>()..loadHadiths(bookId),
      child: _HadithListView(bookTitle: bookTitle),
    );
  }
}

class _HadithListView extends StatefulWidget {
  final String bookTitle;

  const _HadithListView({required this.bookTitle});

  @override
  State<_HadithListView> createState() => _HadithListViewState();
}

class _HadithListViewState extends State<_HadithListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

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
          widget.bookTitle,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<HadithCubit, HadithState>(
        builder: (context, state) {
          if (state.isLoading) {
            return _buildLoadingSkeleton();
          }

          final hadiths = state.filteredHadiths;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
                child: CustomTextField(
                  controller: _searchController,
                  hint: 'ابحث برقم الحديث أو الكلمة...',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: appColors.textMuted,
                    size: 20.sp,
                  ),
                  onChanged: (val) {
                    context.read<HadithCubit>().searchHadiths(val);
                  },
                ),
              ),
              Expanded(
                child: hadiths.isEmpty
                    ? Center(
                        child: Text(
                          'no_search_results'.tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: appColors.textMuted,
                          ),
                        ),
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
                        itemCount: hadiths.length,
                        separatorBuilder: (_, index) => Gap(12.h),
                        itemBuilder: (context, index) {
                          final hadith = hadiths[index];
                          return HadithCardItem(
                            hadith: hadith,
                            onTap: () {
                              AppRouter.navigateTo(
                                context,
                                Routes.hadithDetail,
                                arguments: {'hadith': hadith},
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: ListView.separated(
        itemCount: 5,
        separatorBuilder: (_, index) => Gap(12.h),
        itemBuilder: (_, index) => CustomSkeleton(
          height: 110.h,
          borderRadius: 16.r,
        ),
      ),
    );
  }
}
