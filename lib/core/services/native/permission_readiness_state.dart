import 'package:equatable/equatable.dart';

class PermissionReadinessState extends Equatable {
  final bool notificationsGranted;
  final bool locationGranted;
  final bool exactAlarmsGranted;
  final bool fullScreenIntentGranted;
  final bool batteryUnrestricted;
  final bool isBusy;

  const PermissionReadinessState({
    this.notificationsGranted = false,
    this.locationGranted = false,
    this.exactAlarmsGranted = true,
    this.fullScreenIntentGranted = true,
    this.batteryUnrestricted = true,
    this.isBusy = false,
  });

  bool get isCoreReady => notificationsGranted && locationGranted;
  bool get isAdhanOptimal =>
      notificationsGranted && exactAlarmsGranted && batteryUnrestricted;

  PermissionReadinessState copyWith({
    bool? notificationsGranted,
    bool? locationGranted,
    bool? exactAlarmsGranted,
    bool? fullScreenIntentGranted,
    bool? batteryUnrestricted,
    bool? isBusy,
  }) {
    return PermissionReadinessState(
      notificationsGranted: notificationsGranted ?? this.notificationsGranted,
      locationGranted: locationGranted ?? this.locationGranted,
      exactAlarmsGranted: exactAlarmsGranted ?? this.exactAlarmsGranted,
      fullScreenIntentGranted:
          fullScreenIntentGranted ?? this.fullScreenIntentGranted,
      batteryUnrestricted: batteryUnrestricted ?? this.batteryUnrestricted,
      isBusy: isBusy ?? this.isBusy,
    );
  }

  @override
  List<Object?> get props => [
        notificationsGranted,
        locationGranted,
        exactAlarmsGranted,
        fullScreenIntentGranted,
        batteryUnrestricted,
        isBusy,
      ];
}
