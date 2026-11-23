import 'package:adhan/adhan.dart' as adhan;
import 'package:material_ui/material_ui.dart';

import '../../domain/entities/daily_prayer_schedule.dart';
import '../../domain/entities/prayer_time_entry.dart';
import 'hijri_date_helper.dart';

/// Pure calculation engine for prayer times based on astronomical coordinates
class PrayerCalculationService {
  DailyPrayerSchedule calculateSchedule({
    required double latitude,
    required double longitude,
    required String locationNameAr,
    required String locationNameEn,
    DateTime? targetDate,
  }) {
    final now = DateTime.now();
    final date = targetDate ?? now;
    final coordinates = adhan.Coordinates(latitude, longitude);

    final params = adhan.CalculationMethod.egyptian.getParameters();
    params.madhab = adhan.Madhab.shafi;

    final dateComponents = adhan.DateComponents.from(date);
    final pt = adhan.PrayerTimes(coordinates, dateComponents, params);

    final List<(PrayerType, String, String, DateTime, IconData)> rawPrayers = [
      (PrayerType.fajr, 'الفجر', 'Fajr', pt.fajr, Icons.wb_twilight_rounded),
      (PrayerType.sunrise, 'الشروق', 'Sunrise', pt.sunrise, Icons.wb_sunny_outlined),
      (PrayerType.dhuhr, 'الظهر', 'Dhuhr', pt.dhuhr, Icons.wb_sunny_rounded),
      (PrayerType.asr, 'العصر', 'Asr', pt.asr, Icons.filter_drama_rounded),
      (PrayerType.maghrib, 'المغرب', 'Maghrib', pt.maghrib, Icons.nights_stay_outlined),
      (PrayerType.isha, 'العشاء', 'Isha', pt.isha, Icons.bedtime_rounded),
    ];

    // Identify next prayer
    int nextIndex = -1;
    for (int i = 0; i < rawPrayers.length; i++) {
      if (now.isBefore(rawPrayers[i].$4)) {
        nextIndex = i;
        break;
      }
    }

    PrayerTimeEntry nextPrayerEntry;
    Duration timeToNextPrayer;

    if (nextIndex == -1) {
      // All prayers for today have passed. Next prayer is tomorrow's Fajr
      final tomorrow = date.add(const Duration(days: 1));
      final tomorrowComponents = adhan.DateComponents.from(tomorrow);
      final tomorrowPt = adhan.PrayerTimes(coordinates, tomorrowComponents, params);
      final tomorrowFajr = tomorrowPt.fajr;

      timeToNextPrayer = tomorrowFajr.difference(now);
      nextPrayerEntry = PrayerTimeEntry(
        type: PrayerType.fajr,
        nameAr: 'الفجر',
        nameEn: 'Fajr',
        time: tomorrowFajr,
        icon: Icons.wb_twilight_rounded,
        status: PrayerEntryStatus.next,
        remainingTime: _formatDuration(timeToNextPrayer),
      );
    } else {
      final p = rawPrayers[nextIndex];
      timeToNextPrayer = p.$4.difference(now);
      nextPrayerEntry = PrayerTimeEntry(
        type: p.$1,
        nameAr: p.$2,
        nameEn: p.$3,
        time: p.$4,
        icon: p.$5,
        status: PrayerEntryStatus.next,
        remainingTime: _formatDuration(timeToNextPrayer),
      );
    }

    // Build the 6 daily entries with past/next/upcoming status
    final List<PrayerTimeEntry> entries = [];
    for (int i = 0; i < rawPrayers.length; i++) {
      final p = rawPrayers[i];
      final isNext = (i == nextIndex);
      final isPast = (nextIndex != -1 && i < nextIndex) || (nextIndex == -1);
      final status = isNext
          ? PrayerEntryStatus.next
          : (isPast ? PrayerEntryStatus.past : PrayerEntryStatus.upcoming);

      final diff = p.$4.difference(now);
      final remText = isNext
          ? 'باقي ${_formatDuration(diff)}'
          : (isPast ? 'أُقيمت' : 'قادمة');

      entries.add(PrayerTimeEntry(
        type: p.$1,
        nameAr: p.$2,
        nameEn: p.$3,
        time: p.$4,
        icon: p.$5,
        status: status,
        remainingTime: remText,
      ));
    }

    final hijri = HijriDateHelper.getHijriDate(date);

    return DailyPrayerSchedule(
      prayers: entries,
      currentPrayer: nextIndex > 0 ? entries[nextIndex - 1] : null,
      nextPrayer: nextPrayerEntry,
      timeToNextPrayer:
          timeToNextPrayer.isNegative ? Duration.zero : timeToNextPrayer,
      locationNameAr: locationNameAr,
      locationNameEn: locationNameEn,
      hijriDateAr: hijri.formattedAr,
      hijriDateEn: hijri.formattedEn,
      date: date,
      latitude: latitude,
      longitude: longitude,
    );
  }

  static String _formatDuration(Duration d) {
    if (d.isNegative) return '00:00:00';
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
