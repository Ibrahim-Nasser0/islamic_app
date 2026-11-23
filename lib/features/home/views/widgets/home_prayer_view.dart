import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../presentation/models/prayer_item_model.dart';
import 'home_quick_actions_bar.dart';
import 'kaaba_atmospheric_hero_card.dart';
import 'today_prayers_horizontal_list.dart';

/// Tab 0: Home & Prayer Times with Atmospheric Hero Card & Horizontal Prayers Row
class HomePrayerView extends StatefulWidget {
  const HomePrayerView({super.key});

  @override
  State<HomePrayerView> createState() => _HomePrayerViewState();
}

class _HomePrayerViewState extends State<HomePrayerView> {
  final List<PrayerItemModel> _prayers = const [
    PrayerItemModel(
      nameAr: 'الفجر',
      nameEn: 'Fajr',
      time: '04:52 ص',
      icon: Icons.wb_twilight_rounded,
      status: PrayerStatus.past,
      remainingTime: 'أُقيمت',
    ),
    PrayerItemModel(
      nameAr: 'الشروق',
      nameEn: 'Sunrise',
      time: '06:21 ص',
      icon: Icons.wb_sunny_outlined,
      status: PrayerStatus.past,
      remainingTime: 'انتهى',
    ),
    PrayerItemModel(
      nameAr: 'الظهر',
      nameEn: 'Dhuhr',
      time: '11:45 ص',
      icon: Icons.wb_sunny_rounded,
      status: PrayerStatus.next,
      remainingTime: 'باقي 01:15 س',
    ),
    PrayerItemModel(
      nameAr: 'العصر',
      nameEn: 'Asr',
      time: '02:48 م',
      icon: Icons.filter_drama_rounded,
      status: PrayerStatus.upcoming,
      remainingTime: 'باقي 04:18 س',
    ),
    PrayerItemModel(
      nameAr: 'المغرب',
      nameEn: 'Maghrib',
      time: '05:08 م',
      icon: Icons.nights_stay_outlined,
      status: PrayerStatus.upcoming,
      remainingTime: 'باقي 06:38 س',
    ),
    PrayerItemModel(
      nameAr: 'العشاء',
      nameEn: 'Isha',
      time: '06:32 م',
      icon: Icons.bedtime_rounded,
      status: PrayerStatus.upcoming,
      remainingTime: 'باقي 08:02 س',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 110.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Dynamic Atmospheric Kaaba Hero Card
          const KaabaAtmosphericHeroCard(
            location: 'القاهرة، مصر',
            hijriDate: '15 شعبان 1448 هـ',
            gregorianDate: '23 نوفمبر',
            nextPrayerName: 'الظهر',
            nextPrayerTime: '11:45 ص',
            remainingTime: 'متبقي 01 س و 15 د',
          ),
          Gap(20.h),

          // 2. Horizontal Prayers List Row
          TodayPrayersHorizontalList(
            prayers: _prayers,
            onPrayerTap: (index) {
              // Tap feedback or details
            },
          ),
          Gap(24.h),

          // 3. Quick Action Cards
          const HomeQuickActionsBar(),
          Gap(20.h),

          // 4. Daily Ayah Card
          _buildDailyAyahCard(appColors),
        ],
      ),
    );
  }

  Widget _buildDailyAyahCard(dynamic appColors) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: appColors.quranPageBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: appColors.accentGold.withValues(alpha: 0.35),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.auto_stories_rounded, size: 18.sp, color: appColors.accentGold),
              SizedBox(width: 8.w),
              Text(
                'daily_ayah'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: appColors.accentGold,
                ),
              ),
            ],
          ),
          Gap(12.h),
          Text(
            '﴿ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ ﴾',
            textAlign: TextAlign.center,
            style: AppTypography.quranAyah.copyWith(
              fontSize: 20.sp,
              color: appColors.quranAyahText,
            ),
          ),
          Gap(6.h),
          Text(
            '[ الرعد: 28 ]',
            style: TextStyle(fontSize: 12.sp, color: appColors.textMuted),
          ),
        ],
      ),
    );
  }
}
