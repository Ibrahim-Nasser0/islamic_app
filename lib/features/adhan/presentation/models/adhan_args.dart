class AdhanArgs {
  final String prayerKey;
  final String prayerName;
  final DateTime prayerTime;

  const AdhanArgs({
    required this.prayerKey,
    required this.prayerName,
    required this.prayerTime,
  });

  factory AdhanArgs.fromMap(Map<String, dynamic> map) {
    DateTime time;
    final rawTime = map['prayerTime'];
    if (rawTime is DateTime) {
      time = rawTime;
    } else if (rawTime is String) {
      time = DateTime.tryParse(rawTime) ?? DateTime.now();
    } else {
      time = DateTime.now();
    }

    return AdhanArgs(
      prayerKey: map['prayerKey'] as String? ?? 'fajr',
      prayerName: map['prayerName'] as String? ?? 'الصلاة',
      prayerTime: time,
    );
  }

  factory AdhanArgs.fromPayload(String payload) {
    // Format: 'adhan:$prayerKey:$prayerName:${prayerTime.toIso8601String()}'
    final parts = payload.split(':');
    final key = parts.length > 1 ? parts[1] : 'fajr';
    final name = parts.length > 2 ? parts[2] : 'الفجر';
    final timeStr = parts.length > 3 ? parts.sublist(3).join(':') : '';
    final time = DateTime.tryParse(timeStr) ?? DateTime.now();

    return AdhanArgs(
      prayerKey: key,
      prayerName: name,
      prayerTime: time,
    );
  }
}
