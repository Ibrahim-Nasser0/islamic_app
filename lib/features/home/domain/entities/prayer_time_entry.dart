import 'package:equatable/equatable.dart';
import 'package:material_ui/material_ui.dart';

enum PrayerType { fajr, sunrise, dhuhr, asr, maghrib, isha }

enum PrayerEntryStatus { past, next, upcoming }

/// Represents an individual prayer entry for the day
class PrayerTimeEntry extends Equatable {
  final PrayerType type;
  final String nameAr;
  final String nameEn;
  final DateTime time;
  final IconData icon;
  final PrayerEntryStatus status;
  final String remainingTime;

  const PrayerTimeEntry({
    required this.type,
    required this.nameAr,
    required this.nameEn,
    required this.time,
    required this.icon,
    this.status = PrayerEntryStatus.upcoming,
    this.remainingTime = '',
  });

  bool get isNext => status == PrayerEntryStatus.next;
  bool get isPast => status == PrayerEntryStatus.past;
  bool get isUpcoming => status == PrayerEntryStatus.upcoming;

  PrayerTimeEntry copyWith({
    PrayerType? type,
    String? nameAr,
    String? nameEn,
    DateTime? time,
    IconData? icon,
    PrayerEntryStatus? status,
    String? remainingTime,
  }) {
    return PrayerTimeEntry(
      type: type ?? this.type,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      time: time ?? this.time,
      icon: icon ?? this.icon,
      status: status ?? this.status,
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }

  @override
  List<Object?> get props => [type, nameAr, nameEn, time, status, remainingTime];
}
