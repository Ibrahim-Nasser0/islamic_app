/// Helper for converting Gregorian dates to Islamic Hijri dates
class HijriDateHelper {
  HijriDateHelper._();

  static const List<String> _hijriMonthsAr = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  static const List<String> _hijriMonthsEn = [
    'Muharram',
    'Safar',
    'Rabi\' al-Awwal',
    'Rabi\' al-Thani',
    'Jumada al-Ula',
    'Jumada al-Akhirah',
    'Rajab',
    'Sha\'ban',
    'Ramadan',
    'Shawwal',
    'Dhu al-Qi\'dah',
    'Dhu al-Hijjah',
  ];

  /// Calculates Hijri date approximation from Gregorian date
  static ({int day, int month, int year, String formattedAr, String formattedEn})
      getHijriDate(DateTime gregorian) {
    // Julian Day calculation
    int day = gregorian.day;
    int month = gregorian.month;
    int year = gregorian.year;

    int m = month;
    int y = year;
    if (m < 3) {
      y -= 1;
      m += 12;
    }

    int a = (y / 100).floor();
    int b = 2 - a + (a / 4).floor();
    int jd = (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        day +
        b -
        1524;

    // Convert JD to Hijri
    int l = jd - 1948440 + 10632;
    int n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;
    int j = ((10985 - l) / 5316).floor() * ((50 * l) / 17719).floor() +
        (l / 5670).floor() * ((43 * l) / 15238).floor();
    l = l -
        ((30 - j) / 15).floor() * ((17719 * j) / 50).floor() -
        (j / 16).floor() * ((15238 * j) / 43).floor() +
        29;
    int hMonth = ((24 * l) / 709).floor();
    int hDay = l - ((709 * hMonth) / 24).floor();
    int hYear = 30 * n + j - 30;

    int safeMonth = (hMonth - 1).clamp(0, 11);
    final monthNameAr = _hijriMonthsAr[safeMonth];
    final monthNameEn = _hijriMonthsEn[safeMonth];

    return (
      day: hDay,
      month: hMonth,
      year: hYear,
      formattedAr: '$hDay $monthNameAr $hYear هـ',
      formattedEn: '$hDay $monthNameEn $hYear AH',
    );
  }
}
