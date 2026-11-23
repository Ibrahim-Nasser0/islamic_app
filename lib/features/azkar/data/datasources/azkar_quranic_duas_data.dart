import '../../domain/entities/dhikr_item.dart';

/// Authentic Quranic Supplications (أدعية من القرآن الكريم)
class AzkarQuranicDuasData {
  const AzkarQuranicDuasData._();

  static const List<DhikrItem> items = [
    DhikrItem(
      id: 'q_1',
      arabicText: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      targetCount: 3,
      remainingCount: 3,
      fadl: 'من أجمع وأكثر أدعية النبي ﷺ',
      reference: 'سورة البقرة: 201',
    ),
    DhikrItem(
      id: 'q_2',
      arabicText: 'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً إِنَّكَ أَنْتَ الْوَهَّابُ',
      targetCount: 3,
      remainingCount: 3,
      fadl: 'دعاء الثبات على الهداية والإيمان',
      reference: 'سورة آل عمران: 8',
    ),
    DhikrItem(
      id: 'q_3',
      arabicText: 'رَبِّ اشْرَحْ لِي صَدْرِي ۝ وَيَسِّرْ لِي أَمْرِي ۝ وَاحْلُلْ عُقْدَةً مِنْ لِسَانِي ۝ يَفْقَهُوا قَوْلِي',
      targetCount: 1,
      remainingCount: 1,
      fadl: 'دعاء موسى عليه السلام لتيسير الأمور وانشراح الصدر',
      reference: 'سورة طه: 25-28',
    ),
    DhikrItem(
      id: 'q_4',
      arabicText: 'رَبِّ إِنِّي لِمَا أَنْزَلْتَ إِلَيَّ مِنْ خَيْرٍ فَقِيرٌ',
      targetCount: 3,
      remainingCount: 3,
      fadl: 'دعاء استجلاب الرزق وتفريج الكرب',
      reference: 'سورة القصص: 24',
    ),
  ];
}
