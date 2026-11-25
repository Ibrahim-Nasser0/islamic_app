import 'tasbeeh_item.dart';
import 'wird_item.dart';

/// Pre-configured authentic prophetic azkar and default Daily Wird sequences
class TasbeehDefaults {
  const TasbeehDefaults._();

  static const List<TasbeehItem> defaultAzkar = [
    TasbeehItem(
      id: 'subhan_allah',
      arabicText: 'سُبْحَانَ اللَّهِ',
      virtueKey: 'tasbeeh_virtue_subhan_allah',
    ),
    TasbeehItem(
      id: 'alhamdulillah',
      arabicText: 'الْحَمْدُ لِلَّهِ',
      virtueKey: 'tasbeeh_virtue_alhamdulillah',
    ),
    TasbeehItem(
      id: 'la_ilaha_illallah',
      arabicText: 'لَا إِلَهَ إِلَّا اللَّهُ',
      virtueKey: 'tasbeeh_virtue_tahlil',
    ),
    TasbeehItem(
      id: 'allahu_akbar',
      arabicText: 'اللَّهُ أَكْبَرُ',
      virtueKey: 'tasbeeh_virtue_takbir',
    ),
    TasbeehItem(
      id: 'astaghfirullah',
      arabicText: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',
      virtueKey: 'tasbeeh_virtue_istighfar',
    ),
    TasbeehItem(
      id: 'hawqalah',
      arabicText: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      virtueKey: 'tasbeeh_virtue_hawqalah',
    ),
    TasbeehItem(
      id: 'salawat',
      arabicText: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ',
      virtueKey: 'tasbeeh_virtue_salawat',
    ),
    TasbeehItem(
      id: 'subhan_wa_bihamdihi',
      arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
      virtueKey: 'tasbeeh_virtue_baqiyat',
    ),
  ];

  static const List<WirdItem> defaultWird = [
    WirdItem(id: 'w_subhan_allah', arabicText: 'سُبْحَانَ اللَّهِ', targetCount: 100),
    WirdItem(id: 'w_alhamdulillah', arabicText: 'الْحَمْدُ لِلَّهِ', targetCount: 100),
    WirdItem(id: 'w_la_ilaha_illallah', arabicText: 'لَا إِلَهَ إِلَّا اللَّهُ', targetCount: 100),
    WirdItem(id: 'w_allahu_akbar', arabicText: 'اللَّهُ أَكْبَرُ', targetCount: 100),
    WirdItem(id: 'w_astaghfirullah', arabicText: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ', targetCount: 100),
    WirdItem(id: 'w_salawat', arabicText: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ', targetCount: 100),
    WirdItem(id: 'w_hawqalah', arabicText: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ', targetCount: 100),
  ];
}
