import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/native/native_alarm_bridge_service.dart';
import '../../../../core/services/notification/azkar_alarm_scheduler.dart';
import '../../../../core/services/notification/prayer_alarm_scheduler.dart';
import '../../data/datasources/settings_local_data_source.dart';
import '../models/muadhin_option.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsLocalDataSource _localDataSource;
  final PrayerAlarmScheduler? _alarmScheduler;
  final AzkarAlarmScheduler? _azkarScheduler;
  final NativeAlarmBridgeService? _nativeBridge;

  SettingsCubit(
    this._localDataSource, {
    PrayerAlarmScheduler? alarmScheduler,
    AzkarAlarmScheduler? azkarScheduler,
    NativeAlarmBridgeService? nativeBridge,
  })  : _alarmScheduler = alarmScheduler,
        _azkarScheduler = azkarScheduler,
        _nativeBridge = nativeBridge,
        super(_createInitialState(_localDataSource));

  static SettingsState _createInitialState(SettingsLocalDataSource dataSource) {
    final loc = dataSource.getLocation();
    final savedMuadhinId = dataSource.getMuadhinVoice();
    final selectedMuadhin = MuadhinOption.defaultList.firstWhere(
      (m) => m.id == savedMuadhinId,
      orElse: () => MuadhinOption.defaultList.first,
    );

    return SettingsState(
      prayerNotification: dataSource.getPrayerNotification(),
      prePrayerNotification: dataSource.getPrePrayerNotification(),
      azkarNotification: dataSource.getAzkarNotification(),
      athanSound: dataSource.getAthanSound(),
      adhanLockscreen: dataSource.getAdhanLockscreen(),
      selectedMuadhin: selectedMuadhin,
      locationNameAr: loc.nameAr,
      locationNameEn: loc.nameEn,
      latitude: loc.lat,
      longitude: loc.lng,
      isManualLocation: loc.isManual,
      languageCode: dataSource.getLanguageCode(),
    );
  }

  Future<void> refreshReliability() async {
    final map = await _nativeBridge?.checkReliability();
    if (map != null && !isClosed) emit(state.copyWith(reliability: map));
  }

  Future<void> fixMissingPermissions() async {
    final rel = state.reliability;
    if (rel['exactAlarms'] == false) {
      await _nativeBridge?.openExactAlarmSettings();
    } else if (rel['fullScreenIntent'] == false) {
      await _nativeBridge?.openFullScreenIntentSettings();
    } else {
      await _nativeBridge?.openBatterySettings();
    }
    await refreshReliability();
  }

  Future<void> previewNativeAdhan() => _alarmScheduler?.triggerPreviewAdhan(
        muadhin: state.selectedMuadhin,
        languageCode: state.languageCode,
      ) ??
      Future.value();

  Future<void> previewNativeAzkar() => _azkarScheduler?.triggerPreviewAzkar(
        categoryId: 'morning',
        languageCode: state.languageCode,
      ) ??
      Future.value();

  Future<void> setPrayerNotification(bool value) async {
    emit(state.copyWith(prayerNotification: value));
    await _localDataSource.setPrayerNotification(value);
    _rescheduleAlarms();
  }

  Future<void> setPrePrayerNotification(bool value) async {
    emit(state.copyWith(prePrayerNotification: value));
    await _localDataSource.setPrePrayerNotification(value);
    _rescheduleAlarms();
  }

  Future<void> setAzkarNotification(bool value) async {
    emit(state.copyWith(azkarNotification: value));
    await _localDataSource.setAzkarNotification(value);
    _azkarScheduler?.scheduleDailyAzkar(enabled: value, languageCode: state.languageCode);
  }

  Future<void> setAthanSound(bool value) async {
    emit(state.copyWith(athanSound: value));
    await _localDataSource.setAthanSound(value);
    _rescheduleAlarms();
  }

  Future<void> setAdhanLockscreen(bool value) async {
    emit(state.copyWith(adhanLockscreen: value));
    await _localDataSource.setAdhanLockscreen(value);
    _rescheduleAlarms();
  }

  Future<void> setMuadhinVoice(MuadhinOption muadhin) async {
    emit(state.copyWith(selectedMuadhin: muadhin));
    await _localDataSource.setMuadhinVoice(muadhin.id);
    _rescheduleAlarms();
  }

  Future<void> setLanguageCode(String code) async {
    emit(state.copyWith(languageCode: code));
    await _localDataSource.setLanguageCode(code);
    _rescheduleAlarms();
    _azkarScheduler?.scheduleDailyAzkar(enabled: state.azkarNotification, languageCode: code);
  }

  Future<void> setManualLocation({
    required double lat,
    required double lng,
    required String nameAr,
    required String nameEn,
  }) async {
    emit(state.copyWith(
      latitude: lat, longitude: lng, locationNameAr: nameAr, locationNameEn: nameEn, isManualLocation: true,
    ));
    await _localDataSource.setManualLocation(lat: lat, lng: lng, nameAr: nameAr, nameEn: nameEn);
    _rescheduleAlarms();
  }

  Future<void> resetToGps({
    required double lat,
    required double lng,
    required String nameAr,
    required String nameEn,
  }) async {
    emit(state.copyWith(
      latitude: lat, longitude: lng, locationNameAr: nameAr, locationNameEn: nameEn, isManualLocation: false,
    ));
    await _localDataSource.resetToGps();
    _rescheduleAlarms();
  }

  void _rescheduleAlarms() {
    _alarmScheduler?.schedulePrayerAlarms(
      latitude: state.latitude,
      longitude: state.longitude,
      adhanEnabled: state.prayerNotification && state.athanSound,
      preAlertEnabled: state.prayerNotification && state.prePrayerNotification,
      lockscreenEnabled: state.adhanLockscreen,
      languageCode: state.languageCode,
      muadhin: state.selectedMuadhin,
    );
  }
}
