class MuadhinOption {
  final String id;
  final String nameKey;
  final String location;
  final String regularAudioPath;
  final String fajrAudioPath;

  const MuadhinOption({
    required this.id,
    required this.nameKey,
    required this.location,
    required this.regularAudioPath,
    required this.fajrAudioPath,
  });

  static const List<MuadhinOption> defaultList = [
    MuadhinOption(
      id: 'abdulbaset',
      nameKey: 'abdulbaset_adhan',
      location: 'مصر',
      regularAudioPath: 'audio/abdulbasit/abd-elbaset-regular.mp3',
      fajrAudioPath: 'audio/abdulbasit/abd-elbaset-fajr.mp3',
    ),
    MuadhinOption(
      id: 'makkah',
      nameKey: 'makkah_adhan',
      location: 'مكة المكرمة',
      regularAudioPath: 'audio/harram/al-harram-regular.mp3',
      fajrAudioPath: 'audio/harram/al-harram-fajr.mp3',
    ),
    MuadhinOption(
      id: 'alafasy',
      nameKey: 'afasy_adhan',
      location: 'الكويت',
      regularAudioPath: 'audio/alafasy/alafasy-regular.mp3',
      fajrAudioPath: 'audio/alafasy/alafasy-fajr.mp3',
    ),
  ];
}
