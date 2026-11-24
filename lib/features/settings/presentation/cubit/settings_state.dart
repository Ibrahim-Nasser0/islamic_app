import 'package:equatable/equatable.dart';
import '../models/muadhin_option.dart';

class SettingsState extends Equatable {
  final bool prayerNotification;
  final bool prePrayerNotification;
  final bool azkarNotification;
  final bool athanSound;
  final bool adhanLockscreen;
  final MuadhinOption selectedMuadhin;
  final String locationNameAr;
  final String locationNameEn;
  final double latitude;
  final double longitude;
  final bool isManualLocation;
  final String languageCode;
  final Map<String, bool> reliability;

  const SettingsState({
    required this.prayerNotification,
    required this.prePrayerNotification,
    required this.azkarNotification,
    required this.athanSound,
    required this.adhanLockscreen,
    required this.selectedMuadhin,
    required this.locationNameAr,
    required this.locationNameEn,
    required this.latitude,
    required this.longitude,
    required this.isManualLocation,
    required this.languageCode,
    this.reliability = const {
      'notifications': true,
      'exactAlarms': true,
      'batteryUnrestricted': true,
      'fullScreenIntent': true,
    },
  });

  bool get isReliabilityOptimal => reliability.values.every((v) => v);

  String getDisplayLocation(bool isArabic) =>
      isArabic ? locationNameAr : locationNameEn;

  SettingsState copyWith({
    bool? prayerNotification,
    bool? prePrayerNotification,
    bool? azkarNotification,
    bool? athanSound,
    bool? adhanLockscreen,
    MuadhinOption? selectedMuadhin,
    String? locationNameAr,
    String? locationNameEn,
    double? latitude,
    double? longitude,
    bool? isManualLocation,
    String? languageCode,
    Map<String, bool>? reliability,
  }) {
    return SettingsState(
      prayerNotification: prayerNotification ?? this.prayerNotification,
      prePrayerNotification:
          prePrayerNotification ?? this.prePrayerNotification,
      azkarNotification: azkarNotification ?? this.azkarNotification,
      athanSound: athanSound ?? this.athanSound,
      adhanLockscreen: adhanLockscreen ?? this.adhanLockscreen,
      selectedMuadhin: selectedMuadhin ?? this.selectedMuadhin,
      locationNameAr: locationNameAr ?? this.locationNameAr,
      locationNameEn: locationNameEn ?? this.locationNameEn,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isManualLocation: isManualLocation ?? this.isManualLocation,
      languageCode: languageCode ?? this.languageCode,
      reliability: reliability ?? this.reliability,
    );
  }

  @override
  List<Object?> get props => [
        prayerNotification,
        prePrayerNotification,
        azkarNotification,
        athanSound,
        adhanLockscreen,
        selectedMuadhin,
        locationNameAr,
        locationNameEn,
        latitude,
        longitude,
        isManualLocation,
        languageCode,
        reliability,
      ];
}
