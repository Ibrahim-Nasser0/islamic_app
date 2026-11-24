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
  bool isManualLocation() =>
      _prefs.getBool(AppConstants.isManualLocationKey) ?? false;

  @override
  ({double lat, double lng, String nameAr, String nameEn, bool isManual})
      getLocation() {
    final isManual = isManualLocation();
    final lat = _prefs.getDouble(AppConstants.customLocationLatKey) ??
        LocationService.defaultCairoLat;
    final lng = _prefs.getDouble(AppConstants.customLocationLngKey) ??
        LocationService.defaultCairoLng;
    final nameAr =
        _prefs.getString(AppConstants.customLocationNameArKey) ??
            LocationService.defaultCairoAr;
    final nameEn =
        _prefs.getString(AppConstants.customLocationNameEnKey) ??
            LocationService.defaultCairoEn;

    return (
      lat: lat,
      lng: lng,
      nameAr: nameAr,
      nameEn: nameEn,
      isManual: isManual,
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
