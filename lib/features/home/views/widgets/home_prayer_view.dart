import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/responsive/responsive_content_frame.dart';
import '../../../../core/responsive/window_size_class.dart';
import '../../../../core/services/native/permission_readiness_cubit.dart';
import '../../../azkar/presentation/cubit/timed_azkar_cubit.dart';
import '../../../quran/presentation/cubit/daily_wird_cubit.dart';
import '../../presentation/cubit/prayer_times_cubit.dart';
import '../../presentation/cubit/prayer_times_state.dart';
import 'compact_pinned_hero_card.dart';
import 'home_location_handler.dart';
import 'home_prayer_slivers.dart';

/// Tab 0: Home & Prayer Times backed by [CustomScrollView] and pinned mini Hero HUD.
class HomePrayerView extends StatelessWidget {
  const HomePrayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<PrayerTimesCubit>()..loadPrayerTimes()),
        BlocProvider(create: (_) => sl<PermissionReadinessCubit>()..refresh()),
        BlocProvider(create: (_) => sl<TimedAzkarCubit>()..loadForCurrentTime()),
        BlocProvider.value(value: sl<DailyWirdCubit>()..loadWird()),
      ],
      child: const _HomePrayerContent(),
    );
  }
}

class _HomePrayerContent extends StatefulWidget {
  const _HomePrayerContent();

  @override
  State<_HomePrayerContent> createState() => _HomePrayerContentState();
}

class _HomePrayerContentState extends State<_HomePrayerContent> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _heroCardKey = GlobalKey();
  final GlobalKey _viewportKey = GlobalKey();
  bool _showPinnedHero = false;
  double? _heroHideOffset;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeroThreshold());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _measureHeroThreshold() {
    if (!mounted) return;
    final heroBox = _heroCardKey.currentContext?.findRenderObject();
    final viewBox = _viewportKey.currentContext?.findRenderObject();
    if (heroBox is RenderBox && heroBox.attached && viewBox != null && _scrollController.hasClients) {
      final bottomY = heroBox
          .localToGlobal(Offset(0, heroBox.size.height), ancestor: viewBox)
          .dy;
      _heroHideOffset = (_scrollController.offset + bottomY - 76.0).clamp(120.0, 900.0);
      _onScroll();
    }
  }

  void _onScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    if (_heroHideOffset == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeroThreshold());
    }
    final threshold = _heroHideOffset ?? 210.0;
    final shouldPin = _scrollController.offset >= threshold;
    if (shouldPin != _showPinnedHero) {
      setState(() => _showPinnedHero = shouldPin);
    }
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = context.bottomNavClearance();

    return BlocListener<PrayerTimesCubit, PrayerTimesState>(
      listenWhen: (prev, curr) =>
          curr is PrayerTimesLoaded &&
          (prev is! PrayerTimesLoaded || prev.schedule != curr.schedule),
      listener: (context, state) {
        if (state is PrayerTimesLoaded) {
          context
              .read<TimedAzkarCubit>()
              .loadForCurrentTime(schedule: state.schedule);
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _measureHeroThreshold());
        }
      },
      child: Stack(
        key: _viewportKey,
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: HomePrayerSlivers.build(
              context,
              heroKey: _heroCardKey,
              bottomClearance: bottomPad,
            ),
          ),
          Positioned(
            top: 8.h,
            left: 0,
            right: 0,
            child: ResponsiveContentFrame(
              child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
                builder: (context, state) {
                  if (state is! PrayerTimesLoaded) {
                    return const SizedBox.shrink();
                  }
                  final schedule = state.schedule;
                  final lang = context.locale.languageCode;
                  final isAr = lang == 'ar';
                  return CompactPinnedHeroCard(
                    visible: _showPinnedHero,
                    location: schedule.getLocalizedLocation(lang),
                    nextPrayerName:
                        isAr ? schedule.nextPrayer.nameAr : schedule.nextPrayer.nameEn,
                    nextPrayerTime:
                        DateFormat('hh:mm a', lang).format(schedule.nextPrayer.time),
                    remainingTime: state.formattedRemainingTime,
                    intervalProgress: state.intervalProgress,
                    isManualLocation: state.isManualLocation,
                    onLocationTap: () => handleHomeLocationTap(context),
                    onTapToTop: _scrollToTop,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
