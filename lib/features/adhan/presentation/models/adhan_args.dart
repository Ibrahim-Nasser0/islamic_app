class AdhanArgs {
  final String prayerKey;
  final String prayerName;
  final DateTime prayerTime;
  final int? notificationId;

  const AdhanArgs({
    required this.prayerKey,
    required this.prayerName,
    required this.prayerTime,
    this.notificationId,
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
      notificationId: map['notificationId'] as int?,
    );
  }

  factory AdhanArgs.fromPayload(String payload) {
    // Format: 'adhan:$prayerKey:$prayerName:$id:${prayerTime.toIso8601String()}'
    final parts = payload.split(':');
    final key = parts.length > 1 ? parts[1] : 'fajr';
    final name = parts.length > 2 ? parts[2] : 'الفجر';
    int? notifId;
    String timeStr = '';
    if (parts.length > 4 && int.tryParse(parts[3]) != null) {
      notifId = int.parse(parts[3]);
      timeStr = parts.sublist(4).join(':');
    } else if (parts.length > 3) {
      timeStr = parts.sublist(3).join(':');
    }
    final time = DateTime.tryParse(timeStr) ?? DateTime.now();

    return AdhanArgs(
      prayerKey: key,
      prayerName: name,
      prayerTime: time,
      notificationId: notifId,
    );
  }
}
