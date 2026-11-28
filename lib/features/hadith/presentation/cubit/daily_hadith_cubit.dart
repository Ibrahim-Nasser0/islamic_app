import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/daily_hadith_entry.dart';
import '../../domain/entities/hadith_item.dart';
import '../../domain/repositories/hadith_repository.dart';
import 'daily_hadith_state.dart';

/// Persists one random authentic (`muttafaq`/`sahih`) Hadith per calendar day
/// directly via indexed SQLite queries, avoiding loading the full library into RAM.
class DailyHadithCubit extends Cubit<DailyHadithState> {
  static const String _dateKey = 'daily_hadith_date';
  static const String _bookKey = 'daily_hadith_book';
  static const String _numberKey = 'daily_hadith_number';
  static const Set<String> _dailyAllowedTiers = {
    HadithItem.tierMuttafaq,
    HadithItem.tierSahih,
  };

  final HadithRepository repository;
  SharedPreferences? prefs;
  final Random _random;

  DailyHadithCubit({
    required this.repository,
    this.prefs,
    Random? random,
  })  : _random = random ?? Random(),
        super(const DailyHadithState());

  Future<SharedPreferences?> _ensurePrefs() async {
    if (prefs != null) return prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e, stackTrace) {
      debugPrint('[DailyHadithCubit] SharedPreferences init failed: $e\n$stackTrace');
    }
    return prefs;
  }

  Future<void> loadDailyHadith({DateTime? now}) async {
    final todayKey = _formatDate(now ?? DateTime.now());
    final sp = await _ensurePrefs();
    final savedDate = sp?.getString(_dateKey);
    final savedBook = sp?.getString(_bookKey);
    final savedNumber = sp?.getInt(_numberKey);

    if (savedDate == todayKey && savedBook != null && savedNumber != null) {
      if (state.entry != null && state.activeDateKey == todayKey) return;
      final restored = await repository.getHadithByNumber(savedBook, savedNumber);
      final cached = restored.fold((_) => null, (item) {
        if (!_dailyAllowedTiers.contains(item.gradeTier)) return null;
        return DailyHadithEntry(bookId: savedBook, hadith: item);
      });
      if (cached != null) {
        emit(DailyHadithState(isLoading: false, entry: cached, activeDateKey: todayKey));
        return;
      }
    }

    await _pickAndPersist(
      dateKey: todayKey,
      excludeBook: savedBook,
      excludeNumber: savedNumber,
    );
  }

  Future<void> shuffleHadith({DateTime? now}) async {
    final todayKey = _formatDate(now ?? DateTime.now());
    final sp = await _ensurePrefs();
    await _pickAndPersist(
      dateKey: todayKey,
      excludeBook: state.entry?.bookId ?? sp?.getString(_bookKey),
      excludeNumber: state.entry?.hadith.number ?? sp?.getInt(_numberKey),
    );
  }

  Future<void> _pickAndPersist({
    required String dateKey,
    String? excludeBook,
    int? excludeNumber,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await repository.pickDailySahihHadith(
      seedOffset: _random.nextInt(1 << 20),
      excludeBook: excludeBook,
      excludeNumber: excludeNumber,
    );

    await result.fold(
      (failure) async {
        debugPrint('[DailyHadithCubit] Pick failed: ${failure.message}');
        emit(
          DailyHadithState(
            isLoading: false,
            entry: state.entry,
            activeDateKey: dateKey,
            errorMessage: failure.message,
          ),
        );
      },
      (picked) async {
        try {
          final sp = await _ensurePrefs();
          await sp?.setString(_dateKey, dateKey);
          await sp?.setString(_bookKey, picked.bookId);
          await sp?.setInt(_numberKey, picked.hadith.number);
        } catch (e, stackTrace) {
          debugPrint('[DailyHadithCubit] Persist failed: $e\n$stackTrace');
        }
        emit(
          DailyHadithState(
            isLoading: false,
            entry: picked,
            activeDateKey: dateKey,
          ),
        );
      },
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-'
      '${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')}';
}
