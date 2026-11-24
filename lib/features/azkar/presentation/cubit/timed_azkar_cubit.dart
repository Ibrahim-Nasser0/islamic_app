import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/domain/entities/daily_prayer_schedule.dart';
import '../../../home/domain/entities/prayer_time_entry.dart';
import '../../data/datasources/azkar_local_data_source.dart';
import 'timed_azkar_state.dart';

/// Cubit serving time-appropriate Azkar directly inside HomePrayerView.
class TimedAzkarCubit extends Cubit<TimedAzkarState> {
  final AzkarLocalDataSource _dataSource;

  TimedAzkarCubit(this._dataSource) : super(const TimedAzkarState());

  static AzkarTimePeriod resolveRecommendedPeriod({
    DateTime? now,
    DailyPrayerSchedule? schedule,
  }) {
    final current = now ?? DateTime.now();
    DateTime morningStart = DateTime(current.year, current.month, current.day, 3, 30);
    DateTime eveningStart = DateTime(current.year, current.month, current.day, 15, 0);
    final sleepStart = DateTime(current.year, current.month, current.day, 21, 30);

    if (schedule != null) {
      for (final p in schedule.prayers) {
        if (p.type == PrayerType.fajr) morningStart = p.time;
        if (p.type == PrayerType.asr) eveningStart = p.time;
      }
    }

    if (!current.isBefore(sleepStart) || current.isBefore(morningStart)) {
      return AzkarTimePeriod.sleep;
    }
    if (current.isBefore(eveningStart)) {
      return AzkarTimePeriod.morning;
    }
    return AzkarTimePeriod.evening;
  }

  Future<void> loadForCurrentTime({
    DailyPrayerSchedule? schedule,
    DateTime? now,
  }) async {
    final recommended = resolveRecommendedPeriod(now: now, schedule: schedule);
    await _loadPeriod(recommended: recommended, selected: recommended);
  }

  Future<void> selectPeriod(AzkarTimePeriod period) async {
    await _loadPeriod(recommended: state.recommendedPeriod, selected: period);
  }

  Future<void> reloadCurrent() async {
    await _loadPeriod(
      recommended: state.recommendedPeriod,
      selected: state.selectedPeriod,
    );
  }

  Future<void> _loadPeriod({
    required AzkarTimePeriod recommended,
    required AzkarTimePeriod selected,
  }) async {
    final category = await _dataSource.getCategoryById(selected.categoryId);
    if (isClosed) return;
    emit(state.copyWith(
      recommendedPeriod: recommended,
      selectedPeriod: selected,
      category: category,
      isLoading: false,
    ));
  }

  Future<void> decrementActiveDhikr() async {
    final category = state.category;
    final active = state.activeDhikr;
    if (category == null || active == null || active.isCompleted) return;

    final nextRemaining = (active.remainingCount - 1).clamp(0, active.targetCount);
    final updatedItems = category.items
        .map((i) => i.id == active.id ? i.copyWith(remainingCount: nextRemaining) : i)
        .toList();

    emit(state.copyWith(category: category.copyWith(items: updatedItems)));
    await _dataSource.updateDhikrCount(category.id, active.id, nextRemaining);
  }

  Future<void> resetCurrentPeriod() async {
    final selected = state.selectedPeriod;
    await _dataSource.resetCategory(selected.categoryId);
    await reloadCurrent();
  }
}
