import '../../domain/entities/juz_info.dart';
import '../../domain/entities/quran_bookmark.dart';
import '../../domain/entities/surah_info.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_local_data_source.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranLocalDataSource localDataSource;

  QuranRepositoryImpl({required this.localDataSource});

  @override
  List<SurahInfo> getSurahs() => localDataSource.getSurahs();

  @override
  List<JuzInfo> getAjzaa() => localDataSource.getAjzaa();

  @override
  Future<QuranBookmark?> getLastRead() => localDataSource.getLastRead();

  @override
  Future<void> saveLastRead(QuranBookmark bookmark) =>
      localDataSource.saveLastRead(bookmark);

  @override
  Future<List<QuranBookmark>> getBookmarks() => localDataSource.getBookmarks();

  @override
  Future<void> toggleBookmark(QuranBookmark bookmark) =>
      localDataSource.toggleBookmark(bookmark);

  @override
  Future<double> getFontSize() => localDataSource.getFontSize();

  @override
  Future<void> saveFontSize(double size) => localDataSource.saveFontSize(size);
}
