import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/database/daos/quran_dao.dart';
import '../../../../core/database/daos/tasbeeh_dao.dart';
import '../../../../core/utils/constants.dart';
import 'settings_location_store.dart';

abstract class SettingsLocalDataSource {
  bool getPrayerNotification();
  Future<void> setPrayerNotification(bool value);
  bool getPrePrayerNotification();
  Future<void> setPrePrayerNotification(bool value);
  bool getAzkarNotification();
  Future<void> setAzkarNotification(bool value);
  bool getAthanSound();
  Future<void> setAthanSound(bool value);
  bool getAdhanLockscreen();
  Future<void> setAdhanLockscreen(bool value);
  String getMuadhinVoice();
  Future<void> setMuadhinVoice(String value);
  String getLanguageCode();
  Future<void> setLanguageCode(String value);
  bool hasCompletedOnboarding();
  Future<void> setOnboardingCompleted();
  int getDailyWirdCount();
  Future<void> setDailyWirdCount(int count);
  int getDailyWirdCursor();
  Future<void> setDailyWirdCursor(int globalAyah);
  String? getDailyWirdCompletedDate();
  Future<void> setDailyWirdCompletedDate(String? dateKey);
  bool isDailyWirdCursorCompleted();
  Future<void> setDailyWirdCursorCompleted(bool value);
  int getDailyWirdLastBatchEnd();
  Future<void> setDailyWirdLastBatchEnd(int globalAyah);
  bool isManualLocation();
  ({double lat, double lng, String nameAr, String nameEn, bool isManual})
      getLocation();
  Future<void> setManualLocation({
    required double lat,
    required double lng,
    required String nameAr,
    required String nameEn,
  });
  Future<void> resetToGps();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences _prefs;
  final QuranDao? _quranDao;
  final TasbeehDao? _tasbeehDao;

  SettingsLocalDataSourceImpl(
    this._prefs, {
    QuranDao? quranDao,
    TasbeehDao? tasbeehDao,
  })  : _quranDao = quranDao,
        _tasbeehDao = tasbeehDao;

  @override
  bool getPrayerNotification() =>
      _prefs.getBool(AppConstants.prayerNotificationKey) ?? true;
  @override
  Future<void> setPrayerNotification(bool value) =>
      _prefs.setBool(AppConstants.prayerNotificationKey, value);

  @override
  bool getPrePrayerNotification() =>
      _prefs.getBool(AppConstants.prePrayerNotificationKey) ?? true;
  @override
  Future<void> setPrePrayerNotification(bool value) =>
      _prefs.setBool(AppConstants.prePrayerNotificationKey, value);

  @override
  bool getAzkarNotification() =>
      _prefs.getBool(AppConstants.azkarNotificationKey) ?? true;
  @override
  Future<void> setAzkarNotification(bool value) =>
      _prefs.setBool(AppConstants.azkarNotificationKey, value);

  @override
  bool getAthanSound() =>
      _prefs.getBool(AppConstants.athanSoundKey) ?? true;
  @override
  Future<void> setAthanSound(bool value) =>
      _prefs.setBool(AppConstants.athanSoundKey, value);

  @override
  bool getAdhanLockscreen() =>
      _prefs.getBool(AppConstants.adhanLockscreenKey) ?? true;
  @override
  Future<void> setAdhanLockscreen(bool value) =>
      _prefs.setBool(AppConstants.adhanLockscreenKey, value);

  @override
  String getMuadhinVoice() =>
      _prefs.getString(AppConstants.muadhinVoiceKey) ?? 'makkah';
  @override
  Future<void> setMuadhinVoice(String value) =>
      _prefs.setString(AppConstants.muadhinVoiceKey, value);

  @override
  String getLanguageCode() =>
      _prefs.getString(AppConstants.languageKey) ?? 'ar';
  @override
  Future<void> setLanguageCode(String value) =>
      _prefs.setString(AppConstants.languageKey, value);

  @override
  bool hasCompletedOnboarding() =>
      _prefs.getBool(AppConstants.onboardingKey) ?? false;
  @override
  Future<void> setOnboardingCompleted() =>
      _prefs.setBool(AppConstants.onboardingKey, true);

  @override
  int getDailyWirdCount() =>
      (_prefs.getInt(AppConstants.dailyWirdCountKey) ?? 5).clamp(1, 50);
  @override
  Future<void> setDailyWirdCount(int count) async {
    final c = count.clamp(1, 50);
    await _prefs.setInt(AppConstants.dailyWirdCountKey, c);
    await _quranDao?.updateWirdState(dailyCount: c);
  }

  @override
  int getDailyWirdCursor() =>
      (_prefs.getInt(AppConstants.dailyWirdCursorKey) ?? 1).clamp(1, 6236);
  @override
  Future<void> setDailyWirdCursor(int globalAyah) async {
    final c = globalAyah.clamp(1, 6236);
    await _prefs.setInt(AppConstants.dailyWirdCursorKey, c);
    await _quranDao?.updateWirdState(cursorAyah: c);
  }

  @override
  String? getDailyWirdCompletedDate() =>
      _prefs.getString(AppConstants.dailyWirdCompletedDateKey);
  @override
  Future<void> setDailyWirdCompletedDate(String? dateKey) async {
    final prev = getDailyWirdCompletedDate();
    if (dateKey == null) {
      await _prefs.remove(AppConstants.dailyWirdCompletedDateKey);
      await _quranDao?.updateWirdState(clearCompletedDate: true);
      return;
    }
    await _prefs.setString(AppConstants.dailyWirdCompletedDateKey, dateKey);
    await _quranDao?.updateWirdState(completedDate: dateKey);
    if (prev != dateKey) {
      await _tasbeehDao?.recordDailyLog(
        dateKey: dateKey,
        quranAyahsDelta: getDailyWirdCount(),
      );
    }
  }

  @override
  bool isDailyWirdCursorCompleted() =>
      _prefs.getBool(AppConstants.dailyWirdCursorCompletedKey) ?? false;
  @override
  Future<void> setDailyWirdCursorCompleted(bool value) async {
    await _prefs.setBool(AppConstants.dailyWirdCursorCompletedKey, value);
    await _quranDao?.updateWirdState(cursorCompleted: value);
  }

  @override
  int getDailyWirdLastBatchEnd() =>
      (_prefs.getInt(AppConstants.dailyWirdLastBatchEndKey) ?? 0).clamp(0, 6236);
  @override
  Future<void> setDailyWirdLastBatchEnd(int globalAyah) async {
    final v = globalAyah.clamp(0, 6236);
    await _prefs.setInt(AppConstants.dailyWirdLastBatchEndKey, v);
    await _quranDao?.updateWirdState(lastBatchEnd: v);
  }

  @override
  bool isManualLocation() => SettingsLocationStore.isManualLocation(_prefs);

  @override
  ({double lat, double lng, String nameAr, String nameEn, bool isManual})
      getLocation() => SettingsLocationStore.getLocation(_prefs);

  @override
  Future<void> setManualLocation({
    required double lat,
    required double lng,
    required String nameAr,
    required String nameEn,
  }) =>
      SettingsLocationStore.setManualLocation(
        _prefs,
        lat: lat,
        lng: lng,
        nameAr: nameAr,
        nameEn: nameEn,
      );

  @override
  Future<void> resetToGps() => SettingsLocationStore.resetToGps(_prefs);
}
