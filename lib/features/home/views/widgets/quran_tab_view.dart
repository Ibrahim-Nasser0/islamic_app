import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/di/injection_container.dart';
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

  void _openReader(BuildContext context, {required int surahNumber, int? ayahNumber}) {
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

    return BlocBuilder<QuranCubit, QuranState>(
      builder: (context, state) {
        final cubit = context.read<QuranCubit>();

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Last Read Hero Card
              QuranLastReadCard(
                lastRead: state.lastRead,
                onResume: () {
                  final surah = state.lastRead?.surahNumber ?? 18;
                  final ayah = state.lastRead?.ayahNumber ?? 1;
                  _openReader(context, surahNumber: surah, ayahNumber: ayah);
                },
              ),
              Gap(14.h),

              // 2. Search Field
              QuranSearchField(
                onChanged: cubit.search,
              ),
              Gap(12.h),

              // 3. Tab Segmented Control
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

              // 4. Tab Content
              if (state.currentTab == QuranTab.surahs) ...[
                if (state.filteredSurahs.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    child: Center(
                      child: Text(
                        'no_search_results'.tr(),
                        style: TextStyle(color: appColors.textMuted),
                      ),
                    ),
                  )
                else
                  ...state.filteredSurahs.map((surah) {
                    return SurahCardItem(
                      surah: surah,
                      onTap: () => _openReader(context, surahNumber: surah.number),
                    );
                  }),
              ] else if (state.currentTab == QuranTab.ajzaa) ...[
                ...state.ajzaa.map((juz) {
                  return JuzCardItem(
                    juz: juz,
                    onTap: () => _openReader(
                      context,
                      surahNumber: juz.startSurahNumber,
                      ayahNumber: juz.startVerseNumber,
                    ),
                  );
                }),
              ] else ...[
                if (state.bookmarks.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    child: Center(
                      child: Text(
                        'no_bookmarks_yet'.tr(),
                        style: TextStyle(color: appColors.textMuted),
                      ),
                    ),
                  )
                else
                  ...state.bookmarks.map((bookmark) {
                    return BookmarkCardItem(
                      bookmark: bookmark,
                      onTap: () => _openReader(
                        context,
                        surahNumber: bookmark.surahNumber,
                        ayahNumber: bookmark.ayahNumber,
                      ),
                      onDelete: () => cubit.toggleBookmark(
                        surahNumber: bookmark.surahNumber,
                        ayahNumber: bookmark.ayahNumber,
                      ),
                    );
                  }),
              ],
            ],
          ),
        );
      },
    );
  }
}
