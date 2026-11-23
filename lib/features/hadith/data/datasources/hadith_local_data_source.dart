import '../../domain/entities/hadith_item.dart';
import 'bukhari_hadiths_data.dart';
import 'muslim_hadiths_data.dart';
import 'nawawi_hadiths_data_part1.dart';
import 'nawawi_hadiths_data_part2.dart';
import 'nawawi_hadiths_data_part3.dart';
import 'riyad_hadiths_data.dart';

abstract class HadithLocalDataSource {
  List<HadithItem> getHadithsByBook(String bookId);
  HadithItem? getHadithByNumber(String bookId, int number);
}

class HadithLocalDataSourceImpl implements HadithLocalDataSource {
  @override
  List<HadithItem> getHadithsByBook(String bookId) {
    switch (bookId.toLowerCase()) {
      case 'bukhari':
      case 'sahih_bukhari':
        return BukhariHadithsData.items;
      case 'muslim':
      case 'sahih_muslim':
        return MuslimHadithsData.items;
      case 'riyad':
      case 'riyad_assalihin':
        return RiyadHadithsData.items;
      case 'nawawi':
      case 'nawawi_forty':
      default:
        return [
          ...NawawiHadithsDataPart1.items,
          ...NawawiHadithsDataPart2.items,
          ...NawawiHadithsDataPart3.items,
        ];
    }
  }

  @override
  HadithItem? getHadithByNumber(String bookId, int number) {
    final list = getHadithsByBook(bookId);
    try {
      return list.firstWhere((h) => h.number == number);
    } catch (_) {
      return null;
    }
  }
}
