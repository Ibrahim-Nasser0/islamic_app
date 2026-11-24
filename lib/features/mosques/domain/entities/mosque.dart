import 'package:equatable/equatable.dart';

/// Mosque Domain Entity
class Mosque extends Equatable {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double distanceInMeters;
  final String? street;

  const Mosque({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distanceInMeters,
    this.street,
  });

  /// Formatted distance string (e.g. "350 م" or "1.4 كم")
  String get formattedDistance {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} م';
    }
    final km = (distanceInMeters / 1000).toStringAsFixed(1);
    return '$km كم';
  }

  /// Approximate walking minutes (average 80 meters per minute)
  int get walkingMinutes {
    final mins = (distanceInMeters / 80).round();
    return mins < 1 ? 1 : mins;
  }

  /// Approximate driving minutes (average 350 meters per minute in city)
  int get drivingMinutes {
    final mins = (distanceInMeters / 350).round();
    return mins < 1 ? 1 : mins;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        latitude,
        longitude,
        distanceInMeters,
        street,
      ];
}
