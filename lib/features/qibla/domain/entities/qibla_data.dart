import 'package:equatable/equatable.dart';

/// Immutable domain model representing Qibla direction, device heading and alignment
class QiblaData extends Equatable {
  final double qiblaDirection;
  final double deviceHeading;
  final double distanceKm;
  final String locationName;
  final bool hasCompass;

  const QiblaData({
    required this.qiblaDirection,
    required this.deviceHeading,
    required this.distanceKm,
    required this.locationName,
    this.hasCompass = true,
  });

  /// Offset in degrees between device top and the Kaaba direction.
  /// 0 means the device is pointing directly towards the Kaaba.
  double get offset {
    double diff = (qiblaDirection - deviceHeading) % 360;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return diff;
  }

  /// Whether the device is accurately aligned within +/- 3 degrees
  bool get isAligned => offset.abs() <= 3.0;

  @override
  List<Object?> get props => [
        qiblaDirection,
        deviceHeading,
        distanceKm,
        locationName,
        hasCompass,
      ];
}
