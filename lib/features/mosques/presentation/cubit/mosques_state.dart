import 'package:equatable/equatable.dart';
import '../../domain/entities/mosque.dart';

enum MosquesStatus { initial, loading, loaded, error }

class MosquesState extends Equatable {
  final MosquesStatus status;
  final List<Mosque> mosques;
  final Mosque? selectedMosque;
  final double userLatitude;
  final double userLongitude;
  final double radiusInMeters;
  final bool isMapView;
  final String? errorMessage;

  const MosquesState({
    this.status = MosquesStatus.initial,
    this.mosques = const [],
    this.selectedMosque,
    this.userLatitude = 30.0444,
    this.userLongitude = 31.2357,
    this.radiusInMeters = 3000.0,
    this.isMapView = true,
    this.errorMessage,
  });

  MosquesState copyWith({
    MosquesStatus? status,
    List<Mosque>? mosques,
    Mosque? Function()? selectedMosque,
    double? userLatitude,
    double? userLongitude,
    double? radiusInMeters,
    bool? isMapView,
    String? Function()? errorMessage,
  }) {
    return MosquesState(
      status: status ?? this.status,
      mosques: mosques ?? this.mosques,
      selectedMosque:
          selectedMosque != null ? selectedMosque() : this.selectedMosque,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      radiusInMeters: radiusInMeters ?? this.radiusInMeters,
      isMapView: isMapView ?? this.isMapView,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        mosques,
        selectedMosque,
        userLatitude,
        userLongitude,
        radiusInMeters,
        isMapView,
        errorMessage,
      ];
}
