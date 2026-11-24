import 'package:equatable/equatable.dart';
import '../models/muadhin_option.dart';

class SettingsState extends Equatable {
  final bool prayerNotification;
  final bool prePrayerNotification;
  final bool azkarNotification;
  final bool athanSound;
  final MuadhinOption selectedMuadhin;
  final String locationNameAr;
  final String locationNameEn;
  final double latitude;
  final double longitude;
  final bool isManualLocation;
  final String languageCode;

  const SettingsState({
    required this.prayerNotification,
    required this.prePrayerNotification,
    required this.azkarNotification,
    required this.athanSound,
    required this.selectedMuadhin,
    required this.locationNameAr,
    required this.locationNameEn,
    required this.latitude,
    required this.longitude,
    required this.isManualLocation,
    required this.languageCode,
  });

  String getDisplayLocation(bool isArabic) =>
      isArabic ? locationNameAr : locationNameEn;

  SettingsState copyWith({
    bool? prayerNotification,
    bool? prePrayerNotification,
    bool? azkarNotification,
    bool? athanSound,
    MuadhinOption? selectedMuadhin,
    String? locationNameAr,
    String? locationNameEn,
    double? latitude,
    double? longitude,
    bool? isManualLocation,
    String? languageCode,
  }) {
    return SettingsState(
      prayerNotification: prayerNotification ?? this.prayerNotification,
      prePrayerNotification:
          prePrayerNotification ?? this.prePrayerNotification,
      azkarNotification: azkarNotification ?? this.azkarNotification,
      athanSound: athanSound ?? this.athanSound,
      selectedMuadhin: selectedMuadhin ?? this.selectedMuadhin,
      locationNameAr: locationNameAr ?? this.locationNameAr,
      locationNameEn: locationNameEn ?? this.locationNameEn,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isManualLocation: isManualLocation ?? this.isManualLocation,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [
        prayerNotification,
        prePrayerNotification,
        azkarNotification,
        athanSound,
        selectedMuadhin,
        locationNameAr,
        locationNameEn,
        latitude,
        longitude,
        isManualLocation,
        languageCode,
      ];
}
