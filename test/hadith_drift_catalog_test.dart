import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/core/database/daos/hadith_search_helper.dart';
import 'package:islamic_app/core/database/hadith_catalog_database.dart';
import 'package:islamic_app/features/hadith/data/datasources/hadith_local_data_source.dart';
import 'package:islamic_app/features/hadith/data/repositories/hadith_repository_impl.dart';
import 'package:islamic_app/features/hadith/domain/entities/hadith_item.dart';
import 'package:islamic_app/features/hadith/presentation/cubit/hadith_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HadithCatalogDatabase & HadithDao (in-memory)', () {
    late HadithCatalogDatabase db;
    late HadithLocalDataSourceImpl dataSource;
    late HadithRepositoryImpl repository;

    setUp(() async {
      db = HadithCatalogDatabase.forTesting(NativeDatabase.memory());
      dataSource = HadithLocalDataSourceImpl(hadithDao: db.hadithDao);
      repository = HadithRepositoryImpl(localDataSource: dataSource);

      await db.hadithDao.insertWithFtsForTesting(
        HadithsCompanion.insert(
          bookId: 'bukhari',
          number: 1,
          chapterAr: 'بدء الوحي',
          titleAr: 'حديث النية',
          arabicText: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
          narrator: 'عمر بن الخطاب',
          reference: 'صحيح البخاري (حديث 1)',
          gradeTier: HadithItem.tierSahih,
          gradeLabelAr: 'صحيح ثابت',
          gradeLabelEn: 'Authentic (Sahih)',
          strengthScore: 4,
          textLength: 31,
        ),
        'انما الاعمال اعمال بالنيات النيات نيات بدء الوحي 1',
      );
      await db.hadithDao.insertWithFtsForTesting(
        HadithsCompanion.insert(
          bookId: 'riyad',
          number: 10,
          chapterAr: 'باب الإخلاص',
          titleAr: 'حديث حسن في الأخلاق',
          arabicText: 'اتَّقِ اللَّهَ حَيْثُمَا كُنْتَ',
          narrator: 'أبو ذر',
          reference: 'رياض الصالحين (حديث 10)',
          gradeTier: HadithItem.tierHasan,
          gradeLabelAr: 'حديث حسن',
          gradeLabelEn: 'Good (Hasan)',
          strengthScore: 3,
          textLength: 29,
        ),
        'اتق الله حيثما كنت الاخلاص 10',
      );
    });

    tearDown(() async => db.close());

    test('FTS5 search matches Arabic words without Tashkeel or Alef hamza', () async {
      final res = await db.hadithDao.searchHadithsFts('sahih_bukhari', 'أعمال النيات');
      expect(res, hasLength(1));
      expect(res.first.number, 1);
      expect(res.first.gradeTier, HadithItem.tierSahih);

      final prefixRes =
          await db.hadithDao.searchHadithsFts('sahih_bukhari', 'الأعمال بالنيات');
      expect(prefixRes, hasLength(1));
    });

    test('Daily Sahih pool strictly excludes non-sahih/hasan entries', () async {
      for (var i = 0; i < 6; i++) {
        final pick = await db.hadithDao.pickRandomDailySahihHadith(seedOffset: i);
        expect(pick, isNotNull);
        expect(
          pick!.gradeTier,
          anyOf(HadithItem.tierMuttafaq, HadithItem.tierSahih),
        );
        expect(pick.bookId, isNot('riyad'));
      }
    });

    test('HadithCubit handles filtering and FTS search on repository', () async {
      final cubit = HadithCubit(repository: repository);
      await cubit.loadHadiths('riyad_assalihin');
      expect(cubit.state.totalCount, 1);
      expect(cubit.state.hadiths.first.gradeTier, HadithItem.tierHasan);

      await cubit.setGradeFilter(HadithItem.tierMuttafaq);
      expect(cubit.state.totalCount, 0);
      expect(cubit.state.hadiths, isEmpty);

      await cubit.setGradeFilter(null);
      expect(cubit.state.totalCount, 1);
      await cubit.close();
    });
  });

  group('Real compressed asset catalog (hadith_catalog.db.gz)', () {
    test('Supports real pagination, grade filter, FTS search & Sahih daily pick', () async {
      final gzBytes = File('assets/hadith/hadith_catalog.db.gz').readAsBytesSync();
      final tempDir = await Directory.systemTemp.createTemp('hadith_real_');
      final dbFile = File('${tempDir.path}${Platform.pathSeparator}real_catalog.db');
      dbFile.writeAsBytesSync(gzip.decode(gzBytes), flush: true);

      final db = HadithCatalogDatabase.fromFile(dbFile);
      final repo = HadithRepositoryImpl(
        localDataSource: HadithLocalDataSourceImpl(hadithDao: db.hadithDao),
      );
      final cubit = HadithCubit(repository: repo);

      try {
        await cubit.loadHadiths('sahih_bukhari');
        expect(cubit.state.totalCount, 7277);
        expect(cubit.state.hadiths.length, HadithCubit.pageSize);
        expect(cubit.state.hasMore, isTrue);

        await cubit.loadMoreHadiths();
        expect(cubit.state.hadiths.length, HadithCubit.pageSize * 2);

        final ftsHits = await db.hadithDao.searchHadithsFts('sahih_bukhari', 'النيات');
        expect(ftsHits.any((h) => h.number == 1), isTrue);

        await cubit.loadHadiths('riyad_assalihin');
        expect(cubit.state.totalCount, 1896);
        await cubit.setGradeFilter(HadithItem.tierMuttafaq);
        expect(cubit.state.totalCount, greaterThan(500));
        expect(
          cubit.state.hadiths.every((h) => h.gradeTier == HadithItem.tierMuttafaq),
          isTrue,
        );

        final daily = await repo.pickDailySahihHadith(seedOffset: 7);
        expect(daily.isRight(), isTrue);
        daily.fold(
          (_) => fail('Expected valid daily Hadith'),
          (entry) {
            expect(
              entry.hadith.gradeTier,
              anyOf(HadithItem.tierMuttafaq, HadithItem.tierSahih),
            );
            expect(
              HadithSearchHelper.canonicalBookId(entry.bookId),
              isIn(['nawawi', 'bukhari', 'muslim', 'riyad']),
            );
          },
        );
      } finally {
        await cubit.close();
        await db.close();
        await tempDir.delete(recursive: true);
      }
    });
  });
}
