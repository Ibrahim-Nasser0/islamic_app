import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/services/location_preference_service.dart';
import '../../../../core/utils/haptics.dart';
import '../../domain/entities/mosque.dart';
import '../../domain/repositories/mosques_repository.dart';
import 'mosques_state.dart';

class MosquesCubit extends Cubit<MosquesState> {
  final MosquesRepository repository;

  MosquesCubit({required this.repository}) : super(const MosquesState());

  void _safeEmit(MosquesState newState) {
    if (!isClosed) {
      emit(newState);
    }
  }

  Future<void> loadNearbyMosques({double? radius}) async {
    final activeRadius = radius ?? state.radiusInMeters;
    _safeEmit(state.copyWith(
      status: MosquesStatus.loading,
      radiusInMeters: activeRadius,
      errorMessage: () => null,
    ));

    try {
      final loc = await LocationPreferenceService.getActiveLocation();
      final result = await repository.getNearbyMosques(
        latitude: loc.latitude,
        longitude: loc.longitude,
        radiusInMeters: activeRadius,
      );

      result.fold(
        (failure) {
          _safeEmit(state.copyWith(
            status: MosquesStatus.error,
            userLatitude: loc.latitude,
            userLongitude: loc.longitude,
            errorMessage: () => failure.message,
          ));
        },
        (mosques) {
          _safeEmit(state.copyWith(
            status: MosquesStatus.loaded,
            mosques: mosques,
            selectedMosque: () => mosques.isNotEmpty ? mosques.first : null,
            userLatitude: loc.latitude,
            userLongitude: loc.longitude,
          ));
        },
      );
    } catch (e) {
      _safeEmit(state.copyWith(
        status: MosquesStatus.error,
        errorMessage: () => e.toString(),
      ));
    }
  }

  void selectMosque(Mosque mosque) {
    AppHaptics.selection();
    _safeEmit(state.copyWith(selectedMosque: () => mosque));
  }

  void changeRadius(double radiusInMeters) {
    AppHaptics.selection();
    loadNearbyMosques(radius: radiusInMeters);
  }

  void toggleViewMode() {
    AppHaptics.selection();
    _safeEmit(state.copyWith(isMapView: !state.isMapView));
  }

  Future<bool> launchDirections(Mosque mosque) async {
    AppHaptics.medium();
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${mosque.latitude},${mosque.longitude}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
