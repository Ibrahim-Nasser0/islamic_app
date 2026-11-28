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
import '../presentation/cubit/hadith_cubit.dart';
import '../presentation/cubit/hadith_state.dart';
import 'widgets/hadith_card_item.dart';
import 'widgets/hadith_filter_bar.dart';

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
      child: _HadithListView(bookId: bookId, bookTitle: bookTitle),
    );
  }
}

class _HadithListView extends StatefulWidget {
  final String bookId;
  final String bookTitle;

  const _HadithListView({required this.bookId, required this.bookTitle});

  @override
  State<_HadithListView> createState() => _HadithListViewState();
}

class _HadithListViewState extends State<_HadithListView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 320) {
      context.read<HadithCubit>().loadMoreHadiths();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final showGradeFilter =
        widget.bookId == 'riyad' ||
        widget.bookId == 'riyad_assalihin' ||
        widget.bookId == 'nawawi' ||
        widget.bookId == 'nawawi_forty';

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
          final cubit = context.read<HadithCubit>();
          return Column(
            children: [
              HadithFilterBar(
                controller: _searchController,
                selectedGrade: state.gradeFilter,
                totalCount: state.totalCount,
                showGradeFilter: showGradeFilter,
                onSearchChanged: cubit.searchHadiths,
                onGradeSelected: cubit.setGradeFilter,
              ),
              Expanded(
                child: state.isLoading
                    ? _buildLoadingSkeleton()
                    : state.hadiths.isEmpty
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
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
                        itemCount:
                            state.hadiths.length +
                            (state.isLoadingMore ? 1 : 0),
                        separatorBuilder: (_, _) => Gap(12.h),
                        itemBuilder: (context, index) {
                          if (index >= state.hadiths.length) {
                            return CustomSkeleton(
                              height: 84.h,
                              borderRadius: 16.r,
                            );
                          }
                          final hadith = state.hadiths[index];
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
        separatorBuilder: (_, _) => Gap(12.h),
        itemBuilder: (_, _) => CustomSkeleton(height: 110.h, borderRadius: 16.r),
      ),
    );
  }
}
