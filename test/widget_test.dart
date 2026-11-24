import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/features/home/data/datasources/prayer_calculation_service.dart';
import 'package:islamic_app/features/home/domain/entities/prayer_time_entry.dart';

void main() {
  group('PrayerCalculationService', () {
    final service = PrayerCalculationService();

    test('calculates ordered daily schedule with Hijri dates for Cairo', () {
      final schedule = service.calculateSchedule(
        latitude: 30.0444,
        longitude: 31.2357,
        locationNameAr: 'القاهرة',
        locationNameEn: 'Cairo',
        targetDate: DateTime(2026, 6, 15, 12, 0),
      );

      expect(schedule.prayers.length, 6);
      expect(schedule.prayers.map((p) => p.type).toList(), [
        PrayerType.fajr,
        PrayerType.sunrise,
        PrayerType.dhuhr,
        PrayerType.asr,
        PrayerType.maghrib,
        PrayerType.isha,
      ]);

      for (int i = 1; i < schedule.prayers.length; i++) {
        expect(
          schedule.prayers[i].time.isAfter(schedule.prayers[i - 1].time),
          isTrue,
        );
      }

      expect(schedule.locationNameAr, 'القاهرة');
      expect(schedule.locationNameEn, 'Cairo');
      expect(schedule.hijriDateAr.trim(), isNotEmpty);
      expect(schedule.hijriDateEn.trim(), isNotEmpty);
      expect(schedule.timeToNextPrayer.isNegative, isFalse);
    });

    test('computes Makkah schedule without errors', () {
      final schedule = service.calculateSchedule(
        latitude: 21.4225,
        longitude: 39.8262,
        locationNameAr: 'مكة المكرمة',
        locationNameEn: 'Makkah',
        targetDate: DateTime(2026, 3, 1, 5, 0),
      );

      expect(schedule.prayers.length, 6);
      expect(schedule.nextPrayer.nameEn, isNotEmpty);
    });
  });
}
