import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/responsive/responsive_card_grid.dart';
import '../../../../core/responsive/responsive_content_frame.dart';
import '../../../../core/responsive/window_size_class.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/widgets.dart';
import 'ahadith_tab_cards.dart';

/// Tab 3: Prophetic Ahadith Collection
class AhadithTabView extends StatelessWidget {
  const AhadithTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final bottomPad = context.bottomNavClearance();

    final books = [
      ('nawawi_forty', 'nawawi_forty'.tr(), 'nawawi_forty_subtitle'.tr(), '42'),
      ('sahih_bukhari', 'sahih_bukhari'.tr(), 'sahih_bukhari_subtitle'.tr(), '100'),
      ('sahih_muslim', 'sahih_muslim'.tr(), 'sahih_muslim_subtitle'.tr(), '100'),
      ('riyad_assalihin', 'riyad_assalihin'.tr(), 'riyad_assalihin_subtitle'.tr(), '100'),
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(top: 16.h, bottom: bottomPad),
      child: ResponsiveContentFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DailyHadithHighlightCard(theme: theme, appColors: appColors),
            Gap(20.h),
            SanctuarySectionHeader(title: 'hadith_books_title'.tr()),
            Gap(12.h),
            ResponsiveCardGrid(
              children: books.map((book) {
                return HadithBookTile(
                  id: book.$1,
                  title: book.$2,
                  subtitle: book.$3,
                  countLabel: 'hadiths_count'.tr(namedArgs: {'count': book.$4}),
                  theme: theme,
                  appColors: appColors,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
