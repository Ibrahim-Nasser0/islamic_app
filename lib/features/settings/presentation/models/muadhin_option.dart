class MuadhinOption {
  final String id;
  final String nameKey;
  final String nameAr;
  final String nameEn;
  final String location;
  final String regularAudioPath;
  final String fajrAudioPath;
  final String rawRegularSound;
  final String rawFajrSound;

  const MuadhinOption({
    required this.id,
    required this.nameKey,
    required this.nameAr,
    required this.nameEn,
    required this.location,
    required this.regularAudioPath,
    required this.fajrAudioPath,
    required this.rawRegularSound,
    required this.rawFajrSound,
  });

  String getRawSound({required bool isFajr}) =>
      isFajr ? rawFajrSound : rawRegularSound;

  String getIosCafSound({required bool isFajr}) =>
      '${getRawSound(isFajr: isFajr)}.caf';

  String getChannelId({required bool isFajr}) =>
      'adhan_${id}_${isFajr ? 'fajr' : 'reg'}';

  static const List<MuadhinOption> defaultList = [
    MuadhinOption(
      id: 'abdulbaset',
      nameKey: 'abdulbaset_adhan',
      nameAr: 'الشيخ عبد الباسط عبد الصمد',
      nameEn: 'Sheikh Abdulbasit Abdulsamad',
      location: 'مصر',
      regularAudioPath: 'audio/abdulbasit/abd-elbaset-regular.mp3',
      fajrAudioPath: 'audio/abdulbasit/abd-elbaset-fajr.mp3',
      rawRegularSound: 'abdulbasit_regular',
      rawFajrSound: 'abdulbasit_fajr',
    ),
    MuadhinOption(
      id: 'makkah',
      nameKey: 'makkah_adhan',
      nameAr: 'أذان الحرم المكي • الشيخ أحمد بن علي ملا',
      nameEn: 'Makkah Sanctuary • Sheikh Ahmed Mulla',
      location: 'مكة المكرمة',
      regularAudioPath: 'audio/harram/al-harram-regular.mp3',
      fajrAudioPath: 'audio/harram/al-harram-fajr.mp3',
      rawRegularSound: 'al_harram_regular',
      rawFajrSound: 'al_harram_fajr',
    ),
    MuadhinOption(
      id: 'alafasy',
      nameKey: 'afasy_adhan',
      nameAr: 'الشيخ مشاري راشد العفاسي',
      nameEn: 'Sheikh Mishary Al-Afasy',
      location: 'الكويت',
      regularAudioPath: 'audio/alafasy/alafasy-regular.mp3',
      fajrAudioPath: 'audio/alafasy/alafasy-fajr.mp3',
      rawRegularSound: 'alafasy_regular',
      rawFajrSound: 'alafasy_fajr',
    ),
  ];
}
