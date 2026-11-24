import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/responsive/responsive_card_grid.dart';
import '../../../../core/responsive/responsive_content_frame.dart';
import '../../../../core/responsive/window_size_class.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_segmented_control.dart';
import '../../../quran/presentation/cubit/quran_cubit.dart';
import '../../../quran/presentation/cubit/quran_state.dart';
import '../../../quran/views/widgets/bookmark_card_item.dart';
import '../../../quran/views/widgets/juz_card_item.dart';
import '../../../quran/views/widgets/quran_last_read_card.dart';
import '../../../quran/views/widgets/quran_search_field.dart';
import '../../../quran/views/widgets/surah_card_item.dart';

/// Tab 1: Holy Quran Overview with full Surahs & Juz index
class QuranTabView extends StatelessWidget {
  const QuranTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuranCubit>(),
      child: const _QuranTabContent(),
    );
  }
}

class _QuranTabContent extends StatelessWidget {
  const _QuranTabContent();

  void _openReader(
    BuildContext context, {
    required int surahNumber,
    int? ayahNumber,
  }) {
    Navigator.pushNamed(
      context,
      Routes.quranReader,
      arguments: {
        'surahNumber': surahNumber,
        'initialAyah': ayahNumber ?? 1,
      },
    ).then((_) {
      if (context.mounted) {
        context.read<QuranCubit>().loadQuranData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final bottomPad = context.bottomNavClearance();

    return BlocBuilder<QuranCubit, QuranState>(
      builder: (context, state) {
        final cubit = context.read<QuranCubit>();

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(top: 14.h, bottom: bottomPad),
          child: ResponsiveContentFrame(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                QuranLastReadCard(
                  lastRead: state.lastRead,
                  onResume: () {
                    final surah = state.lastRead?.surahNumber ?? 18;
                    final ayah = state.lastRead?.ayahNumber ?? 1;
                    _openReader(context, surahNumber: surah, ayahNumber: ayah);
                  },
                ),
                Gap(14.h),
                QuranSearchField(onChanged: cubit.search),
                Gap(12.h),
                CustomSegmentedControl(
                  options: [
                    '${"surahs".tr()} (114)',
                    '${"ajzaa".tr()} (30)',
                    '${"bookmarks".tr()} (${state.bookmarks.length})',
                  ],
                  selectedIndex: state.currentTab.index,
                  onValueChanged: (index) {
                    cubit.setTab(QuranTab.values[index]);
                  },
                ),
                Gap(12.h),
                _buildTabContent(context, state, appColors),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    QuranState state,
    AppThemeColors appColors,
  ) {
    if (state.currentTab == QuranTab.surahs) {
      if (state.filteredSurahs.isEmpty) {
        return _buildEmptyState('no_search_results'.tr(), appColors);
      }
      return ResponsiveCardGrid(
        children: state.filteredSurahs.map((surah) {
          return SurahCardItem(
            surah: surah,
            onTap: () => _openReader(context, surahNumber: surah.number),
          );
        }).toList(),
      );
    }
    if (state.currentTab == QuranTab.ajzaa) {
      return ResponsiveCardGrid(
        children: state.ajzaa.map((juz) {
          return JuzCardItem(
            juz: juz,
            onTap: () => _openReader(
              context,
              surahNumber: juz.startSurahNumber,
              ayahNumber: juz.startVerseNumber,
            ),
          );
        }).toList(),
      );
    }
    if (state.bookmarks.isEmpty) {
      return _buildEmptyState('no_bookmarks_yet'.tr(), appColors);
    }
    return ResponsiveCardGrid(
      children: state.bookmarks.map((bookmark) {
        return BookmarkCardItem(
          bookmark: bookmark,
          onTap: () => _openReader(
            context,
            surahNumber: bookmark.surahNumber,
            ayahNumber: bookmark.ayahNumber,
          ),
          onDelete: () => context.read<QuranCubit>().toggleBookmark(
                surahNumber: bookmark.surahNumber,
                ayahNumber: bookmark.ayahNumber,
              ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(String text, AppThemeColors appColors) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: Center(
        child: Text(text, style: TextStyle(color: appColors.textMuted)),
      ),
    );
  }
}
