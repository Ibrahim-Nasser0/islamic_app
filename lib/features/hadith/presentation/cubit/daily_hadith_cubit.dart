import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/daily_hadith_entry.dart';
import '../../domain/repositories/hadith_repository.dart';
import 'daily_hadith_state.dart';

/// Manages the daily random Prophetic Hadith across all 4 bundled books.
class DailyHadithCubit extends Cubit<DailyHadithState> {
  static const String _datePrefKey = 'daily_hadith_date';
  static const String _bookPrefKey = 'daily_hadith_book';
  static const String _numberPrefKey = 'daily_hadith_number';
  static const int _maxDailyHighlightLength = 420;

  final HadithRepository _repository;
  final SharedPreferences? _prefs;
  final Random _random;
  List<DailyHadithEntry>? _cachedPool;

  DailyHadithCubit({
    required HadithRepository repository,
    SharedPreferences? prefs,
    Random? random,
  })  : _repository = repository,
        _prefs = prefs,
        _random = random ?? Random(),
        super(const DailyHadithState());

  Future<void> loadDailyHadith({DateTime? now}) async {
    final todayKey = _formatDateKey(now ?? DateTime.now());
    if (state.entry != null && state.activeDateKey == todayKey && !state.isLoading) {
      return;
    }

    if (state.entry == null) {
      emit(state.copyWith(isLoading: true));
    }

    final pool = await _ensurePool();
    if (isClosed) return;
    if (pool.isEmpty) {
      emit(state.copyWith(isLoading: false, errorMessage: 'No hadiths available'));
      return;
    }

    final savedDate = _prefs?.getString(_datePrefKey);
    final savedBook = _prefs?.getString(_bookPrefKey);
    final savedNumber = _prefs?.getInt(_numberPrefKey);

    if (savedDate == todayKey && savedBook != null && savedNumber != null) {
      final restored = _findEntry(pool, savedBook, savedNumber);
      if (restored != null) {
        emit(state.copyWith(
          isLoading: false,
          entry: restored,
          activeDateKey: todayKey,
        ));
        return;
      }
    }

    final pick = _pickRandomEntry(
      pool,
      excludeBook: savedBook,
      excludeNumber: savedNumber,
    );
    await _persistPick(todayKey, pick);
    if (!isClosed) {
      emit(state.copyWith(
        isLoading: false,
        entry: pick,
        activeDateKey: todayKey,
      ));
    }
  }

  Future<void> shuffleHadith({DateTime? now}) async {
    final todayKey = _formatDateKey(now ?? DateTime.now());
    final pool = await _ensurePool();
    if (isClosed || pool.isEmpty) return;

    final current = state.entry;
    final pick = _pickRandomEntry(
      pool,
      excludeBook: current?.bookId,
      excludeNumber: current?.hadith.number,
    );
    await _persistPick(todayKey, pick);
    if (!isClosed) {
      emit(state.copyWith(
        isLoading: false,
        entry: pick,
        activeDateKey: todayKey,
      ));
    }
  }

  Future<List<DailyHadithEntry>> _ensurePool() async {
    if (_cachedPool != null && _cachedPool!.isNotEmpty) {
      return _cachedPool!;
    }
    final result = await _repository.getAllHadithsPool();
    return result.fold(
      (failure) {
        debugPrint('[DailyHadithCubit] Pool load failed: ${failure.message}');
        return const [];
      },
      (list) {
        _cachedPool = list;
        return list;
      },
    );
  }

  DailyHadithEntry _pickRandomEntry(
    List<DailyHadithEntry> pool, {
    String? excludeBook,
    int? excludeNumber,
  }) {
    final concise = pool
        .where((e) => e.hadith.arabicText.length <= _maxDailyHighlightLength)
        .toList();
    final basePool = concise.isNotEmpty ? concise : pool;
    final filtered = basePool.where((e) {
      if (excludeBook == null || excludeNumber == null) return true;
      return e.bookId != excludeBook || e.hadith.number != excludeNumber;
    }).toList();
    final candidates = filtered.isNotEmpty ? filtered : basePool;
    return candidates[_random.nextInt(candidates.length)];
  }

  DailyHadithEntry? _findEntry(
    List<DailyHadithEntry> pool,
    String bookId,
    int number,
  ) {
    for (final item in pool) {
      if (item.bookId == bookId && item.hadith.number == number) {
        return item;
      }
    }
    return null;
  }

  Future<void> _persistPick(String dateKey, DailyHadithEntry pick) async {
    final prefs = _prefs;
    if (prefs == null) return;
    try {
      await prefs.setString(_datePrefKey, dateKey);
      await prefs.setString(_bookPrefKey, pick.bookId);
      await prefs.setInt(_numberPrefKey, pick.hadith.number);
    } catch (e, stackTrace) {
      debugPrint('[DailyHadithCubit] Persist failed: $e\n$stackTrace');
    }
  }

  String _formatDateKey(DateTime dt) {
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '${dt.year}-$m-$d';
  }
}
