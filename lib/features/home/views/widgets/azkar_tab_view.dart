import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/responsive/responsive_card_grid.dart';
import '../../../../core/responsive/responsive_content_frame.dart';
import '../../../../core/responsive/window_size_class.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../azkar/data/datasources/azkar_local_data_source.dart';
import '../../../azkar/presentation/cubit/timed_azkar_cubit.dart';
import 'azkar_tab_category_tile.dart';
import 'home_timed_azkar_card.dart';

/// Tab 2: Current Time-Slot Azkar Hero Card + Azkar & Tasbeeh Chapters.
class AzkarTabView extends StatelessWidget {
  const AzkarTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      AzkarTabCategoryItem('morning', 'azkar_morning'.tr(), '8', Icons.wb_sunny_rounded),
      AzkarTabCategoryItem('evening', 'azkar_evening'.tr(), '7', FlutterIslamicIcons.solidCrescentMoon),
      AzkarTabCategoryItem('after_prayer', 'azkar_after_prayer'.tr(), '5', FlutterIslamicIcons.solidPrayer),
      AzkarTabCategoryItem('sleep', 'azkar_sleep'.tr(), '4', FlutterIslamicIcons.crescentMoon),
      AzkarTabCategoryItem('quranic_duas', 'azkar_quranic_duas'.tr(), '4', FlutterIslamicIcons.quran2),
      AzkarTabCategoryItem('tasbeeh', 'smart_tasbeeh'.tr(), null, FlutterIslamicIcons.solidTasbih),
    ];

    final content = SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(top: 16.h, bottom: context.bottomNavClearance()),
      child: ResponsiveContentFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HomeTimedAzkarCard(),
            Gap(22.h),
            SanctuarySectionHeader(title: 'azkar_sections_title'.tr()),
            Gap(14.h),
            Builder(
              builder: (ctx) {
                final recId = ctx.select<TimedAzkarCubit, String>(
                  (c) => c.state.recommendedPeriod.categoryId,
                );
                return ResponsiveCardGrid(
                  children: categories
                      .map(
                        (cat) => AzkarTabCategoryTile(
                          item: cat,
                          isRecommendedNow: cat.id == recId,
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );

    if (sl.isRegistered<TimedAzkarCubit>()) {
      return BlocProvider.value(
        value: sl<TimedAzkarCubit>()..ensureLoaded(),
        child: content,
      );
    }

    return BlocProvider(
      create: (_) => TimedAzkarCubit(AzkarLocalDataSourceImpl())..loadForCurrentTime(),
      child: content,
    );
  }
}
