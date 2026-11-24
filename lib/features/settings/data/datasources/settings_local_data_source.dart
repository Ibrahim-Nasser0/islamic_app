import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/constants.dart';
import '../../../home/data/datasources/location_service.dart';

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

  SettingsLocalDataSourceImpl(this._prefs);

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
  Future<void> setDailyWirdCount(int count) =>
      _prefs.setInt(AppConstants.dailyWirdCountKey, count.clamp(1, 50));

  @override
  int getDailyWirdCursor() =>
      (_prefs.getInt(AppConstants.dailyWirdCursorKey) ?? 1).clamp(1, 6236);
  @override
  Future<void> setDailyWirdCursor(int globalAyah) =>
      _prefs.setInt(AppConstants.dailyWirdCursorKey, globalAyah.clamp(1, 6236));

  @override
  String? getDailyWirdCompletedDate() =>
      _prefs.getString(AppConstants.dailyWirdCompletedDateKey);
  @override
  Future<void> setDailyWirdCompletedDate(String? dateKey) => dateKey == null
      ? _prefs.remove(AppConstants.dailyWirdCompletedDateKey)
      : _prefs.setString(AppConstants.dailyWirdCompletedDateKey, dateKey);

  @override
  bool isDailyWirdCursorCompleted() =>
      _prefs.getBool(AppConstants.dailyWirdCursorCompletedKey) ?? false;
  @override
  Future<void> setDailyWirdCursorCompleted(bool value) =>
      _prefs.setBool(AppConstants.dailyWirdCursorCompletedKey, value);

  @override
  int getDailyWirdLastBatchEnd() =>
      (_prefs.getInt(AppConstants.dailyWirdLastBatchEndKey) ?? 0).clamp(0, 6236);
  @override
  Future<void> setDailyWirdLastBatchEnd(int globalAyah) => _prefs.setInt(
      AppConstants.dailyWirdLastBatchEndKey, globalAyah.clamp(0, 6236));

  @override
  bool isManualLocation() =>
      _prefs.getBool(AppConstants.isManualLocationKey) ?? false;

  @override
  ({double lat, double lng, String nameAr, String nameEn, bool isManual})
      getLocation() {
    return (
      lat: _prefs.getDouble(AppConstants.customLocationLatKey) ??
          LocationService.defaultCairoLat,
      lng: _prefs.getDouble(AppConstants.customLocationLngKey) ??
          LocationService.defaultCairoLng,
      nameAr: _prefs.getString(AppConstants.customLocationNameArKey) ??
          LocationService.defaultCairoAr,
      nameEn: _prefs.getString(AppConstants.customLocationNameEnKey) ??
          LocationService.defaultCairoEn,
      isManual: isManualLocation(),
    );
  }

  @override
  Future<void> setManualLocation({
    required double lat,
    required double lng,
    required String nameAr,
    required String nameEn,
  }) async {
    await _prefs.setBool(AppConstants.isManualLocationKey, true);
    await _prefs.setDouble(AppConstants.customLocationLatKey, lat);
    await _prefs.setDouble(AppConstants.customLocationLngKey, lng);
    await _prefs.setString(AppConstants.customLocationNameArKey, nameAr);
    await _prefs.setString(AppConstants.customLocationNameEnKey, nameEn);
  }

  @override
  Future<void> resetToGps() async {
    await _prefs.setBool(AppConstants.isManualLocationKey, false);
    await _prefs.remove(AppConstants.customLocationLatKey);
    await _prefs.remove(AppConstants.customLocationLngKey);
    await _prefs.remove(AppConstants.customLocationNameArKey);
    await _prefs.remove(AppConstants.customLocationNameEnKey);
  }
}
