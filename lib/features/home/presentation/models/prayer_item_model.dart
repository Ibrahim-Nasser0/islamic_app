import 'package:flutter/material.dart';

/// Enum representing the status of a prayer relative to the current time
enum PrayerStatus { past, current, next, upcoming }

/// Data model representing a single prayer time in the day
class PrayerItemModel {
  final String nameAr;
  final String nameEn;
  final String time;
  final IconData icon;
  final PrayerStatus status;
  final String remainingTime;
  final bool isNotificationEnabled;

  const PrayerItemModel({
    required this.nameAr,
    required this.nameEn,
    required this.time,
    required this.icon,
    required this.status,
    this.remainingTime = '',
    this.isNotificationEnabled = true,
  });

  bool get isNextOrCurrent =>
      status == PrayerStatus.next || status == PrayerStatus.current;
}
