import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../settings/data/datasources/settings_local_data_source.dart';
import '../../data/datasources/daily_wird_calculator.dart';
import 'daily_wird_state.dart';

/// Cubit managing sequential Mushaf daily reading progress and configurable ayah counts.
class DailyWirdCubit extends Cubit<DailyWirdState> {
  final SettingsLocalDataSource _settingsDs;
  final DailyWirdCalculator _calculator;

  DailyWirdCubit({
    required SettingsLocalDataSource settingsDs,
    DailyWirdCalculator calculator = const DailyWirdCalculator(),
  })  : _settingsDs = settingsDs,
        _calculator = calculator,
        super(const DailyWirdState());

  Future<void> loadWird({DateTime? now}) async {
    final todayKey = _formatDateKey(now ?? DateTime.now());
    int cursor = _settingsDs.getDailyWirdCursor();
    final count = _settingsDs.getDailyWirdCount();
    bool completed = _settingsDs.isDailyWirdCursorCompleted();
    final completedDate = _settingsDs.getDailyWirdCompletedDate();
    final lastEnd = _settingsDs.getDailyWirdLastBatchEnd();

    // Advance automatically when a new calendar day arrives after completing yesterday's Wird.
    if (completed && completedDate != null && completedDate != todayKey && lastEnd > 0) {
      final total = _calculator.totalQuranVerses;
      cursor = lastEnd >= total ? 1 : lastEnd + 1;
      completed = false;
      await _settingsDs.setDailyWirdCursor(cursor);
      await _settingsDs.setDailyWirdCursorCompleted(false);
    }

    final slice = _calculator.buildSlice(startGlobalAyah: cursor, count: count);
    if (isClosed) return;
    emit(state.copyWith(
      slice: slice,
      dailyCount: count,
      isCompletedForCurrentBatch: completed,
      isLoading: false,
    ));
  }

  Future<void> markCompleted({DateTime? now}) async {
    final currentSlice = state.slice;
    if (currentSlice == null) return;
    final todayKey = _formatDateKey(now ?? DateTime.now());
    await _settingsDs.setDailyWirdCursorCompleted(true);
    await _settingsDs.setDailyWirdCompletedDate(todayKey);
    await _settingsDs.setDailyWirdLastBatchEnd(currentSlice.endGlobalAyah);
    if (!isClosed) {
      emit(state.copyWith(isCompletedForCurrentBatch: true));
    }
  }

  Future<void> moveToNextBatch() async {
    final currentSlice = state.slice;
    if (currentSlice == null) return;
    final nextStart = currentSlice.nextGlobalAyah;
    final count = _settingsDs.getDailyWirdCount();

    await _settingsDs.setDailyWirdCursor(nextStart);
    await _settingsDs.setDailyWirdCursorCompleted(false);
    await _settingsDs.setDailyWirdLastBatchEnd(0);

    final nextSlice = _calculator.buildSlice(startGlobalAyah: nextStart, count: count);
    if (!isClosed) {
      emit(state.copyWith(
        slice: nextSlice,
        dailyCount: count,
        isCompletedForCurrentBatch: false,
      ));
    }
  }

  Future<void> setDailyCount(int newCount) async {
    final safe = newCount.clamp(1, 50);
    await _settingsDs.setDailyWirdCount(safe);
    final cursor = _settingsDs.getDailyWirdCursor();
    final wasCompleted = _settingsDs.isDailyWirdCursorCompleted();
    final updatedSlice = _calculator.buildSlice(startGlobalAyah: cursor, count: safe);
    final resetCompletion = wasCompleted && safe > state.dailyCount;
    if (resetCompletion) {
      await _settingsDs.setDailyWirdCursorCompleted(false);
    }
    if (!isClosed) {
      emit(state.copyWith(
        slice: updatedSlice,
        dailyCount: safe,
        isCompletedForCurrentBatch: resetCompletion ? false : wasCompleted,
      ));
    }
  }

  Future<void> resetToFatihah() async {
    await _settingsDs.setDailyWirdCursor(1);
    await _settingsDs.setDailyWirdCursorCompleted(false);
    await _settingsDs.setDailyWirdLastBatchEnd(0);
    await _settingsDs.setDailyWirdCompletedDate(null);
    final count = _settingsDs.getDailyWirdCount();
    final slice = _calculator.buildSlice(startGlobalAyah: 1, count: count);
    if (!isClosed) {
      emit(state.copyWith(
        slice: slice,
        dailyCount: count,
        isCompletedForCurrentBatch: false,
      ));
    }
  }

  static String _formatDateKey(DateTime dt) {
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '${dt.year}-$m-$d';
  }
}
