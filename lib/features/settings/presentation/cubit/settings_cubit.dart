import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/notification/azkar_alarm_scheduler.dart';
import '../../../../core/services/notification/prayer_alarm_scheduler.dart';
import '../../data/datasources/settings_local_data_source.dart';
import '../models/muadhin_option.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsLocalDataSource _localDataSource;
  final PrayerAlarmScheduler? _alarmScheduler;
  final AzkarAlarmScheduler? _azkarScheduler;

  SettingsCubit(
    this._localDataSource, {
    PrayerAlarmScheduler? alarmScheduler,
    AzkarAlarmScheduler? azkarScheduler,
  })  : _alarmScheduler = alarmScheduler,
        _azkarScheduler = azkarScheduler,
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
      selectedMuadhin: selectedMuadhin,
      locationNameAr: loc.nameAr,
      locationNameEn: loc.nameEn,
      latitude: loc.lat,
      longitude: loc.lng,
      isManualLocation: loc.isManual,
      languageCode: dataSource.getLanguageCode(),
    );
  }

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
    _azkarScheduler?.scheduleDailyAzkar(enabled: value);
  }

  Future<void> setAthanSound(bool value) async {
    emit(state.copyWith(athanSound: value));
    await _localDataSource.setAthanSound(value);
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
  }

  Future<void> setManualLocation({
    required double lat,
    required double lng,
    required String nameAr,
    required String nameEn,
  }) async {
    emit(
      state.copyWith(
        latitude: lat,
        longitude: lng,
        locationNameAr: nameAr,
        locationNameEn: nameEn,
        isManualLocation: true,
      ),
    );
    await _localDataSource.setManualLocation(
      lat: lat,
      lng: lng,
      nameAr: nameAr,
      nameEn: nameEn,
    );
    _rescheduleAlarms();
  }

  Future<void> resetToGps({
    required double lat,
    required double lng,
    required String nameAr,
    required String nameEn,
  }) async {
    emit(
      state.copyWith(
        latitude: lat,
        longitude: lng,
        locationNameAr: nameAr,
        locationNameEn: nameEn,
        isManualLocation: false,
      ),
    );
    await _localDataSource.resetToGps();
    _rescheduleAlarms();
  }

  void _rescheduleAlarms() {
    _alarmScheduler?.schedulePrayerAlarms(
      latitude: state.latitude,
      longitude: state.longitude,
      adhanEnabled: state.prayerNotification && state.athanSound,
      preAlertEnabled: state.prayerNotification && state.prePrayerNotification,
      muadhin: state.selectedMuadhin,
    );
  }
}
