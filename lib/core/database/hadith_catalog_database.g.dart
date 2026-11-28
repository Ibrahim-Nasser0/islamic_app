// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_catalog_database.dart';

// ignore_for_file: type=lint
class $HadithBooksTable extends HadithBooks
    with TableInfo<$HadithBooksTable, HadithBookRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HadithBooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleArMeta = const VerificationMeta(
    'titleAr',
  );
  @override
  late final GeneratedColumn<String> titleAr = GeneratedColumn<String>(
    'title_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleEnMeta = const VerificationMeta(
    'titleEn',
  );
  @override
  late final GeneratedColumn<String> titleEn = GeneratedColumn<String>(
    'title_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCountMeta = const VerificationMeta(
    'totalCount',
  );
  @override
  late final GeneratedColumn<int> totalCount = GeneratedColumn<int>(
    'total_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultGradeArMeta = const VerificationMeta(
    'defaultGradeAr',
  );
  @override
  late final GeneratedColumn<String> defaultGradeAr = GeneratedColumn<String>(
    'default_grade_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    titleAr,
    titleEn,
    totalCount,
    defaultGradeAr,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hadith_books';
  @override
  VerificationContext validateIntegrity(
    Insertable<HadithBookRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title_ar')) {
      context.handle(
        _titleArMeta,
        titleAr.isAcceptableOrUnknown(data['title_ar']!, _titleArMeta),
      );
    } else if (isInserting) {
      context.missing(_titleArMeta);
    }
    if (data.containsKey('title_en')) {
      context.handle(
        _titleEnMeta,
        titleEn.isAcceptableOrUnknown(data['title_en']!, _titleEnMeta),
      );
    } else if (isInserting) {
      context.missing(_titleEnMeta);
    }
    if (data.containsKey('total_count')) {
      context.handle(
        _totalCountMeta,
        totalCount.isAcceptableOrUnknown(data['total_count']!, _totalCountMeta),
      );
    } else if (isInserting) {
      context.missing(_totalCountMeta);
    }
    if (data.containsKey('default_grade_ar')) {
      context.handle(
        _defaultGradeArMeta,
        defaultGradeAr.isAcceptableOrUnknown(
          data['default_grade_ar']!,
          _defaultGradeArMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultGradeArMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HadithBookRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HadithBookRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      titleAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_ar'],
      )!,
      titleEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_en'],
      )!,
      totalCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_count'],
      )!,
      defaultGradeAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_grade_ar'],
      )!,
    );
  }

  @override
  $HadithBooksTable createAlias(String alias) {
    return $HadithBooksTable(attachedDatabase, alias);
  }
}

class HadithBookRow extends DataClass implements Insertable<HadithBookRow> {
  final String id;
  final String titleAr;
  final String titleEn;
  final int totalCount;
  final String defaultGradeAr;
  const HadithBookRow({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.totalCount,
    required this.defaultGradeAr,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title_ar'] = Variable<String>(titleAr);
    map['title_en'] = Variable<String>(titleEn);
    map['total_count'] = Variable<int>(totalCount);
    map['default_grade_ar'] = Variable<String>(defaultGradeAr);
    return map;
  }

  HadithBooksCompanion toCompanion(bool nullToAbsent) {
    return HadithBooksCompanion(
      id: Value(id),
      titleAr: Value(titleAr),
      titleEn: Value(titleEn),
      totalCount: Value(totalCount),
      defaultGradeAr: Value(defaultGradeAr),
    );
  }

  factory HadithBookRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HadithBookRow(
      id: serializer.fromJson<String>(json['id']),
      titleAr: serializer.fromJson<String>(json['titleAr']),
      titleEn: serializer.fromJson<String>(json['titleEn']),
      totalCount: serializer.fromJson<int>(json['totalCount']),
      defaultGradeAr: serializer.fromJson<String>(json['defaultGradeAr']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'titleAr': serializer.toJson<String>(titleAr),
      'titleEn': serializer.toJson<String>(titleEn),
      'totalCount': serializer.toJson<int>(totalCount),
      'defaultGradeAr': serializer.toJson<String>(defaultGradeAr),
    };
  }

  HadithBookRow copyWith({
    String? id,
    String? titleAr,
    String? titleEn,
    int? totalCount,
    String? defaultGradeAr,
  }) => HadithBookRow(
    id: id ?? this.id,
    titleAr: titleAr ?? this.titleAr,
    titleEn: titleEn ?? this.titleEn,
    totalCount: totalCount ?? this.totalCount,
    defaultGradeAr: defaultGradeAr ?? this.defaultGradeAr,
  );
  HadithBookRow copyWithCompanion(HadithBooksCompanion data) {
    return HadithBookRow(
      id: data.id.present ? data.id.value : this.id,
      titleAr: data.titleAr.present ? data.titleAr.value : this.titleAr,
      titleEn: data.titleEn.present ? data.titleEn.value : this.titleEn,
      totalCount: data.totalCount.present
          ? data.totalCount.value
          : this.totalCount,
      defaultGradeAr: data.defaultGradeAr.present
          ? data.defaultGradeAr.value
          : this.defaultGradeAr,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HadithBookRow(')
          ..write('id: $id, ')
          ..write('titleAr: $titleAr, ')
          ..write('titleEn: $titleEn, ')
          ..write('totalCount: $totalCount, ')
          ..write('defaultGradeAr: $defaultGradeAr')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, titleAr, titleEn, totalCount, defaultGradeAr);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HadithBookRow &&
          other.id == this.id &&
          other.titleAr == this.titleAr &&
          other.titleEn == this.titleEn &&
          other.totalCount == this.totalCount &&
          other.defaultGradeAr == this.defaultGradeAr);
}

class HadithBooksCompanion extends UpdateCompanion<HadithBookRow> {
  final Value<String> id;
  final Value<String> titleAr;
  final Value<String> titleEn;
  final Value<int> totalCount;
  final Value<String> defaultGradeAr;
  final Value<int> rowid;
  const HadithBooksCompanion({
    this.id = const Value.absent(),
    this.titleAr = const Value.absent(),
    this.titleEn = const Value.absent(),
    this.totalCount = const Value.absent(),
    this.defaultGradeAr = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HadithBooksCompanion.insert({
    required String id,
    required String titleAr,
    required String titleEn,
    required int totalCount,
    required String defaultGradeAr,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       titleAr = Value(titleAr),
       titleEn = Value(titleEn),
       totalCount = Value(totalCount),
       defaultGradeAr = Value(defaultGradeAr);
  static Insertable<HadithBookRow> custom({
    Expression<String>? id,
    Expression<String>? titleAr,
    Expression<String>? titleEn,
    Expression<int>? totalCount,
    Expression<String>? defaultGradeAr,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titleAr != null) 'title_ar': titleAr,
      if (titleEn != null) 'title_en': titleEn,
      if (totalCount != null) 'total_count': totalCount,
      if (defaultGradeAr != null) 'default_grade_ar': defaultGradeAr,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HadithBooksCompanion copyWith({
    Value<String>? id,
    Value<String>? titleAr,
    Value<String>? titleEn,
    Value<int>? totalCount,
    Value<String>? defaultGradeAr,
    Value<int>? rowid,
  }) {
    return HadithBooksCompanion(
      id: id ?? this.id,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      totalCount: totalCount ?? this.totalCount,
      defaultGradeAr: defaultGradeAr ?? this.defaultGradeAr,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (titleAr.present) {
      map['title_ar'] = Variable<String>(titleAr.value);
    }
    if (titleEn.present) {
      map['title_en'] = Variable<String>(titleEn.value);
    }
    if (totalCount.present) {
      map['total_count'] = Variable<int>(totalCount.value);
    }
    if (defaultGradeAr.present) {
      map['default_grade_ar'] = Variable<String>(defaultGradeAr.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HadithBooksCompanion(')
          ..write('id: $id, ')
          ..write('titleAr: $titleAr, ')
          ..write('titleEn: $titleEn, ')
          ..write('totalCount: $totalCount, ')
          ..write('defaultGradeAr: $defaultGradeAr, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HadithsTable extends Hadiths
    with TableInfo<$HadithsTable, HadithCatalogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HadithsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterArMeta = const VerificationMeta(
    'chapterAr',
  );
  @override
  late final GeneratedColumn<String> chapterAr = GeneratedColumn<String>(
    'chapter_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleArMeta = const VerificationMeta(
    'titleAr',
  );
  @override
  late final GeneratedColumn<String> titleAr = GeneratedColumn<String>(
    'title_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arabicTextMeta = const VerificationMeta(
    'arabicText',
  );
  @override
  late final GeneratedColumn<String> arabicText = GeneratedColumn<String>(
    'arabic_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _narratorMeta = const VerificationMeta(
    'narrator',
  );
  @override
  late final GeneratedColumn<String> narrator = GeneratedColumn<String>(
    'narrator',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _benefitMeta = const VerificationMeta(
    'benefit',
  );
  @override
  late final GeneratedColumn<String> benefit = GeneratedColumn<String>(
    'benefit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gradeTierMeta = const VerificationMeta(
    'gradeTier',
  );
  @override
  late final GeneratedColumn<String> gradeTier = GeneratedColumn<String>(
    'grade_tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gradeLabelArMeta = const VerificationMeta(
    'gradeLabelAr',
  );
  @override
  late final GeneratedColumn<String> gradeLabelAr = GeneratedColumn<String>(
    'grade_label_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gradeLabelEnMeta = const VerificationMeta(
    'gradeLabelEn',
  );
  @override
  late final GeneratedColumn<String> gradeLabelEn = GeneratedColumn<String>(
    'grade_label_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _strengthScoreMeta = const VerificationMeta(
    'strengthScore',
  );
  @override
  late final GeneratedColumn<int> strengthScore = GeneratedColumn<int>(
    'strength_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textLengthMeta = const VerificationMeta(
    'textLength',
  );
  @override
  late final GeneratedColumn<int> textLength = GeneratedColumn<int>(
    'text_length',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    number,
    chapterAr,
    titleAr,
    arabicText,
    narrator,
    reference,
    benefit,
    gradeTier,
    gradeLabelAr,
    gradeLabelEn,
    strengthScore,
    textLength,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hadiths';
  @override
  VerificationContext validateIntegrity(
    Insertable<HadithCatalogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('chapter_ar')) {
      context.handle(
        _chapterArMeta,
        chapterAr.isAcceptableOrUnknown(data['chapter_ar']!, _chapterArMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterArMeta);
    }
    if (data.containsKey('title_ar')) {
      context.handle(
        _titleArMeta,
        titleAr.isAcceptableOrUnknown(data['title_ar']!, _titleArMeta),
      );
    } else if (isInserting) {
      context.missing(_titleArMeta);
    }
    if (data.containsKey('arabic_text')) {
      context.handle(
        _arabicTextMeta,
        arabicText.isAcceptableOrUnknown(data['arabic_text']!, _arabicTextMeta),
      );
    } else if (isInserting) {
      context.missing(_arabicTextMeta);
    }
    if (data.containsKey('narrator')) {
      context.handle(
        _narratorMeta,
        narrator.isAcceptableOrUnknown(data['narrator']!, _narratorMeta),
      );
    } else if (isInserting) {
      context.missing(_narratorMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('benefit')) {
      context.handle(
        _benefitMeta,
        benefit.isAcceptableOrUnknown(data['benefit']!, _benefitMeta),
      );
    }
    if (data.containsKey('grade_tier')) {
      context.handle(
        _gradeTierMeta,
        gradeTier.isAcceptableOrUnknown(data['grade_tier']!, _gradeTierMeta),
      );
    } else if (isInserting) {
      context.missing(_gradeTierMeta);
    }
    if (data.containsKey('grade_label_ar')) {
      context.handle(
        _gradeLabelArMeta,
        gradeLabelAr.isAcceptableOrUnknown(
          data['grade_label_ar']!,
          _gradeLabelArMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gradeLabelArMeta);
    }
    if (data.containsKey('grade_label_en')) {
      context.handle(
        _gradeLabelEnMeta,
        gradeLabelEn.isAcceptableOrUnknown(
          data['grade_label_en']!,
          _gradeLabelEnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gradeLabelEnMeta);
    }
    if (data.containsKey('strength_score')) {
      context.handle(
        _strengthScoreMeta,
        strengthScore.isAcceptableOrUnknown(
          data['strength_score']!,
          _strengthScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_strengthScoreMeta);
    }
    if (data.containsKey('text_length')) {
      context.handle(
        _textLengthMeta,
        textLength.isAcceptableOrUnknown(data['text_length']!, _textLengthMeta),
      );
    } else if (isInserting) {
      context.missing(_textLengthMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HadithCatalogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HadithCatalogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      chapterAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_ar'],
      )!,
      titleAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_ar'],
      )!,
      arabicText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabic_text'],
      )!,
      narrator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}narrator'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      )!,
      benefit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}benefit'],
      ),
      gradeTier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grade_tier'],
      )!,
      gradeLabelAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grade_label_ar'],
      )!,
      gradeLabelEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grade_label_en'],
      )!,
      strengthScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}strength_score'],
      )!,
      textLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}text_length'],
      )!,
    );
  }

  @override
  $HadithsTable createAlias(String alias) {
    return $HadithsTable(attachedDatabase, alias);
  }
}

class HadithCatalogRow extends DataClass
    implements Insertable<HadithCatalogRow> {
  final int id;
  final String bookId;
  final int number;
  final String chapterAr;
  final String titleAr;
  final String arabicText;
  final String narrator;
  final String reference;
  final String? benefit;
  final String gradeTier;
  final String gradeLabelAr;
  final String gradeLabelEn;
  final int strengthScore;
  final int textLength;
  const HadithCatalogRow({
    required this.id,
    required this.bookId,
    required this.number,
    required this.chapterAr,
    required this.titleAr,
    required this.arabicText,
    required this.narrator,
    required this.reference,
    this.benefit,
    required this.gradeTier,
    required this.gradeLabelAr,
    required this.gradeLabelEn,
    required this.strengthScore,
    required this.textLength,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_id'] = Variable<String>(bookId);
    map['number'] = Variable<int>(number);
    map['chapter_ar'] = Variable<String>(chapterAr);
    map['title_ar'] = Variable<String>(titleAr);
    map['arabic_text'] = Variable<String>(arabicText);
    map['narrator'] = Variable<String>(narrator);
    map['reference'] = Variable<String>(reference);
    if (!nullToAbsent || benefit != null) {
      map['benefit'] = Variable<String>(benefit);
    }
    map['grade_tier'] = Variable<String>(gradeTier);
    map['grade_label_ar'] = Variable<String>(gradeLabelAr);
    map['grade_label_en'] = Variable<String>(gradeLabelEn);
    map['strength_score'] = Variable<int>(strengthScore);
    map['text_length'] = Variable<int>(textLength);
    return map;
  }

  HadithsCompanion toCompanion(bool nullToAbsent) {
    return HadithsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      number: Value(number),
      chapterAr: Value(chapterAr),
      titleAr: Value(titleAr),
      arabicText: Value(arabicText),
      narrator: Value(narrator),
      reference: Value(reference),
      benefit: benefit == null && nullToAbsent
          ? const Value.absent()
          : Value(benefit),
      gradeTier: Value(gradeTier),
      gradeLabelAr: Value(gradeLabelAr),
      gradeLabelEn: Value(gradeLabelEn),
      strengthScore: Value(strengthScore),
      textLength: Value(textLength),
    );
  }

  factory HadithCatalogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HadithCatalogRow(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      number: serializer.fromJson<int>(json['number']),
      chapterAr: serializer.fromJson<String>(json['chapterAr']),
      titleAr: serializer.fromJson<String>(json['titleAr']),
      arabicText: serializer.fromJson<String>(json['arabicText']),
      narrator: serializer.fromJson<String>(json['narrator']),
      reference: serializer.fromJson<String>(json['reference']),
      benefit: serializer.fromJson<String?>(json['benefit']),
      gradeTier: serializer.fromJson<String>(json['gradeTier']),
      gradeLabelAr: serializer.fromJson<String>(json['gradeLabelAr']),
      gradeLabelEn: serializer.fromJson<String>(json['gradeLabelEn']),
      strengthScore: serializer.fromJson<int>(json['strengthScore']),
      textLength: serializer.fromJson<int>(json['textLength']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<String>(bookId),
      'number': serializer.toJson<int>(number),
      'chapterAr': serializer.toJson<String>(chapterAr),
      'titleAr': serializer.toJson<String>(titleAr),
      'arabicText': serializer.toJson<String>(arabicText),
      'narrator': serializer.toJson<String>(narrator),
      'reference': serializer.toJson<String>(reference),
      'benefit': serializer.toJson<String?>(benefit),
      'gradeTier': serializer.toJson<String>(gradeTier),
      'gradeLabelAr': serializer.toJson<String>(gradeLabelAr),
      'gradeLabelEn': serializer.toJson<String>(gradeLabelEn),
      'strengthScore': serializer.toJson<int>(strengthScore),
      'textLength': serializer.toJson<int>(textLength),
    };
  }

  HadithCatalogRow copyWith({
    int? id,
    String? bookId,
    int? number,
    String? chapterAr,
    String? titleAr,
    String? arabicText,
    String? narrator,
    String? reference,
    Value<String?> benefit = const Value.absent(),
    String? gradeTier,
    String? gradeLabelAr,
    String? gradeLabelEn,
    int? strengthScore,
    int? textLength,
  }) => HadithCatalogRow(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    number: number ?? this.number,
    chapterAr: chapterAr ?? this.chapterAr,
    titleAr: titleAr ?? this.titleAr,
    arabicText: arabicText ?? this.arabicText,
    narrator: narrator ?? this.narrator,
    reference: reference ?? this.reference,
    benefit: benefit.present ? benefit.value : this.benefit,
    gradeTier: gradeTier ?? this.gradeTier,
    gradeLabelAr: gradeLabelAr ?? this.gradeLabelAr,
    gradeLabelEn: gradeLabelEn ?? this.gradeLabelEn,
    strengthScore: strengthScore ?? this.strengthScore,
    textLength: textLength ?? this.textLength,
  );
  HadithCatalogRow copyWithCompanion(HadithsCompanion data) {
    return HadithCatalogRow(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      number: data.number.present ? data.number.value : this.number,
      chapterAr: data.chapterAr.present ? data.chapterAr.value : this.chapterAr,
      titleAr: data.titleAr.present ? data.titleAr.value : this.titleAr,
      arabicText: data.arabicText.present
          ? data.arabicText.value
          : this.arabicText,
      narrator: data.narrator.present ? data.narrator.value : this.narrator,
      reference: data.reference.present ? data.reference.value : this.reference,
      benefit: data.benefit.present ? data.benefit.value : this.benefit,
      gradeTier: data.gradeTier.present ? data.gradeTier.value : this.gradeTier,
      gradeLabelAr: data.gradeLabelAr.present
          ? data.gradeLabelAr.value
          : this.gradeLabelAr,
      gradeLabelEn: data.gradeLabelEn.present
          ? data.gradeLabelEn.value
          : this.gradeLabelEn,
      strengthScore: data.strengthScore.present
          ? data.strengthScore.value
          : this.strengthScore,
      textLength: data.textLength.present
          ? data.textLength.value
          : this.textLength,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HadithCatalogRow(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('number: $number, ')
          ..write('chapterAr: $chapterAr, ')
          ..write('titleAr: $titleAr, ')
          ..write('arabicText: $arabicText, ')
          ..write('narrator: $narrator, ')
          ..write('reference: $reference, ')
          ..write('benefit: $benefit, ')
          ..write('gradeTier: $gradeTier, ')
          ..write('gradeLabelAr: $gradeLabelAr, ')
          ..write('gradeLabelEn: $gradeLabelEn, ')
          ..write('strengthScore: $strengthScore, ')
          ..write('textLength: $textLength')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookId,
    number,
    chapterAr,
    titleAr,
    arabicText,
    narrator,
    reference,
    benefit,
    gradeTier,
    gradeLabelAr,
    gradeLabelEn,
    strengthScore,
    textLength,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HadithCatalogRow &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.number == this.number &&
          other.chapterAr == this.chapterAr &&
          other.titleAr == this.titleAr &&
          other.arabicText == this.arabicText &&
          other.narrator == this.narrator &&
          other.reference == this.reference &&
          other.benefit == this.benefit &&
          other.gradeTier == this.gradeTier &&
          other.gradeLabelAr == this.gradeLabelAr &&
          other.gradeLabelEn == this.gradeLabelEn &&
          other.strengthScore == this.strengthScore &&
          other.textLength == this.textLength);
}

class HadithsCompanion extends UpdateCompanion<HadithCatalogRow> {
  final Value<int> id;
  final Value<String> bookId;
  final Value<int> number;
  final Value<String> chapterAr;
  final Value<String> titleAr;
  final Value<String> arabicText;
  final Value<String> narrator;
  final Value<String> reference;
  final Value<String?> benefit;
  final Value<String> gradeTier;
  final Value<String> gradeLabelAr;
  final Value<String> gradeLabelEn;
  final Value<int> strengthScore;
  final Value<int> textLength;
  const HadithsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.number = const Value.absent(),
    this.chapterAr = const Value.absent(),
    this.titleAr = const Value.absent(),
    this.arabicText = const Value.absent(),
    this.narrator = const Value.absent(),
    this.reference = const Value.absent(),
    this.benefit = const Value.absent(),
    this.gradeTier = const Value.absent(),
    this.gradeLabelAr = const Value.absent(),
    this.gradeLabelEn = const Value.absent(),
    this.strengthScore = const Value.absent(),
    this.textLength = const Value.absent(),
  });
  HadithsCompanion.insert({
    this.id = const Value.absent(),
    required String bookId,
    required int number,
    required String chapterAr,
    required String titleAr,
    required String arabicText,
    required String narrator,
    required String reference,
    this.benefit = const Value.absent(),
    required String gradeTier,
    required String gradeLabelAr,
    required String gradeLabelEn,
    required int strengthScore,
    required int textLength,
  }) : bookId = Value(bookId),
       number = Value(number),
       chapterAr = Value(chapterAr),
       titleAr = Value(titleAr),
       arabicText = Value(arabicText),
       narrator = Value(narrator),
       reference = Value(reference),
       gradeTier = Value(gradeTier),
       gradeLabelAr = Value(gradeLabelAr),
       gradeLabelEn = Value(gradeLabelEn),
       strengthScore = Value(strengthScore),
       textLength = Value(textLength);
  static Insertable<HadithCatalogRow> custom({
    Expression<int>? id,
    Expression<String>? bookId,
    Expression<int>? number,
    Expression<String>? chapterAr,
    Expression<String>? titleAr,
    Expression<String>? arabicText,
    Expression<String>? narrator,
    Expression<String>? reference,
    Expression<String>? benefit,
    Expression<String>? gradeTier,
    Expression<String>? gradeLabelAr,
    Expression<String>? gradeLabelEn,
    Expression<int>? strengthScore,
    Expression<int>? textLength,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (number != null) 'number': number,
      if (chapterAr != null) 'chapter_ar': chapterAr,
      if (titleAr != null) 'title_ar': titleAr,
      if (arabicText != null) 'arabic_text': arabicText,
      if (narrator != null) 'narrator': narrator,
      if (reference != null) 'reference': reference,
      if (benefit != null) 'benefit': benefit,
      if (gradeTier != null) 'grade_tier': gradeTier,
      if (gradeLabelAr != null) 'grade_label_ar': gradeLabelAr,
      if (gradeLabelEn != null) 'grade_label_en': gradeLabelEn,
      if (strengthScore != null) 'strength_score': strengthScore,
      if (textLength != null) 'text_length': textLength,
    });
  }

  HadithsCompanion copyWith({
    Value<int>? id,
    Value<String>? bookId,
    Value<int>? number,
    Value<String>? chapterAr,
    Value<String>? titleAr,
    Value<String>? arabicText,
    Value<String>? narrator,
    Value<String>? reference,
    Value<String?>? benefit,
    Value<String>? gradeTier,
    Value<String>? gradeLabelAr,
    Value<String>? gradeLabelEn,
    Value<int>? strengthScore,
    Value<int>? textLength,
  }) {
    return HadithsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      number: number ?? this.number,
      chapterAr: chapterAr ?? this.chapterAr,
      titleAr: titleAr ?? this.titleAr,
      arabicText: arabicText ?? this.arabicText,
      narrator: narrator ?? this.narrator,
      reference: reference ?? this.reference,
      benefit: benefit ?? this.benefit,
      gradeTier: gradeTier ?? this.gradeTier,
      gradeLabelAr: gradeLabelAr ?? this.gradeLabelAr,
      gradeLabelEn: gradeLabelEn ?? this.gradeLabelEn,
      strengthScore: strengthScore ?? this.strengthScore,
      textLength: textLength ?? this.textLength,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (chapterAr.present) {
      map['chapter_ar'] = Variable<String>(chapterAr.value);
    }
    if (titleAr.present) {
      map['title_ar'] = Variable<String>(titleAr.value);
    }
    if (arabicText.present) {
      map['arabic_text'] = Variable<String>(arabicText.value);
    }
    if (narrator.present) {
      map['narrator'] = Variable<String>(narrator.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (benefit.present) {
      map['benefit'] = Variable<String>(benefit.value);
    }
    if (gradeTier.present) {
      map['grade_tier'] = Variable<String>(gradeTier.value);
    }
    if (gradeLabelAr.present) {
      map['grade_label_ar'] = Variable<String>(gradeLabelAr.value);
    }
    if (gradeLabelEn.present) {
      map['grade_label_en'] = Variable<String>(gradeLabelEn.value);
    }
    if (strengthScore.present) {
      map['strength_score'] = Variable<int>(strengthScore.value);
    }
    if (textLength.present) {
      map['text_length'] = Variable<int>(textLength.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HadithsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('number: $number, ')
          ..write('chapterAr: $chapterAr, ')
          ..write('titleAr: $titleAr, ')
          ..write('arabicText: $arabicText, ')
          ..write('narrator: $narrator, ')
          ..write('reference: $reference, ')
          ..write('benefit: $benefit, ')
          ..write('gradeTier: $gradeTier, ')
          ..write('gradeLabelAr: $gradeLabelAr, ')
          ..write('gradeLabelEn: $gradeLabelEn, ')
          ..write('strengthScore: $strengthScore, ')
          ..write('textLength: $textLength')
          ..write(')'))
        .toString();
  }
}

abstract class _$HadithCatalogDatabase extends GeneratedDatabase {
  _$HadithCatalogDatabase(QueryExecutor e) : super(e);
  $HadithCatalogDatabaseManager get managers =>
      $HadithCatalogDatabaseManager(this);
  late final $HadithBooksTable hadithBooks = $HadithBooksTable(this);
  late final $HadithsTable hadiths = $HadithsTable(this);
  late final Index idxHadithsBookNum = Index(
    'idx_hadiths_book_num',
    'CREATE UNIQUE INDEX idx_hadiths_book_num ON hadiths (book_id, number)',
  );
  late final Index idxHadithsGrade = Index(
    'idx_hadiths_grade',
    'CREATE INDEX idx_hadiths_grade ON hadiths (book_id, grade_tier)',
  );
  late final Index idxHadithsDailyPool = Index(
    'idx_hadiths_daily_pool',
    'CREATE INDEX idx_hadiths_daily_pool ON hadiths (grade_tier, text_length)',
  );
  late final HadithDao hadithDao = HadithDao(this as HadithCatalogDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    hadithBooks,
    hadiths,
    idxHadithsBookNum,
    idxHadithsGrade,
    idxHadithsDailyPool,
  ];
}

typedef $$HadithBooksTableCreateCompanionBuilder =
    HadithBooksCompanion Function({
      required String id,
      required String titleAr,
      required String titleEn,
      required int totalCount,
      required String defaultGradeAr,
      Value<int> rowid,
    });
typedef $$HadithBooksTableUpdateCompanionBuilder =
    HadithBooksCompanion Function({
      Value<String> id,
      Value<String> titleAr,
      Value<String> titleEn,
      Value<int> totalCount,
      Value<String> defaultGradeAr,
      Value<int> rowid,
    });

class $$HadithBooksTableFilterComposer
    extends Composer<_$HadithCatalogDatabase, $HadithBooksTable> {
  $$HadithBooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleAr => $composableBuilder(
    column: $table.titleAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCount => $composableBuilder(
    column: $table.totalCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultGradeAr => $composableBuilder(
    column: $table.defaultGradeAr,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HadithBooksTableOrderingComposer
    extends Composer<_$HadithCatalogDatabase, $HadithBooksTable> {
  $$HadithBooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleAr => $composableBuilder(
    column: $table.titleAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCount => $composableBuilder(
    column: $table.totalCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultGradeAr => $composableBuilder(
    column: $table.defaultGradeAr,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HadithBooksTableAnnotationComposer
    extends Composer<_$HadithCatalogDatabase, $HadithBooksTable> {
  $$HadithBooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titleAr =>
      $composableBuilder(column: $table.titleAr, builder: (column) => column);

  GeneratedColumn<String> get titleEn =>
      $composableBuilder(column: $table.titleEn, builder: (column) => column);

  GeneratedColumn<int> get totalCount => $composableBuilder(
    column: $table.totalCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultGradeAr => $composableBuilder(
    column: $table.defaultGradeAr,
    builder: (column) => column,
  );
}

class $$HadithBooksTableTableManager
    extends
        RootTableManager<
          _$HadithCatalogDatabase,
          $HadithBooksTable,
          HadithBookRow,
          $$HadithBooksTableFilterComposer,
          $$HadithBooksTableOrderingComposer,
          $$HadithBooksTableAnnotationComposer,
          $$HadithBooksTableCreateCompanionBuilder,
          $$HadithBooksTableUpdateCompanionBuilder,
          (
            HadithBookRow,
            BaseReferences<
              _$HadithCatalogDatabase,
              $HadithBooksTable,
              HadithBookRow
            >,
          ),
          HadithBookRow,
          PrefetchHooks Function()
        > {
  $$HadithBooksTableTableManager(
    _$HadithCatalogDatabase db,
    $HadithBooksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HadithBooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HadithBooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HadithBooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> titleAr = const Value.absent(),
                Value<String> titleEn = const Value.absent(),
                Value<int> totalCount = const Value.absent(),
                Value<String> defaultGradeAr = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HadithBooksCompanion(
                id: id,
                titleAr: titleAr,
                titleEn: titleEn,
                totalCount: totalCount,
                defaultGradeAr: defaultGradeAr,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String titleAr,
                required String titleEn,
                required int totalCount,
                required String defaultGradeAr,
                Value<int> rowid = const Value.absent(),
              }) => HadithBooksCompanion.insert(
                id: id,
                titleAr: titleAr,
                titleEn: titleEn,
                totalCount: totalCount,
                defaultGradeAr: defaultGradeAr,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HadithBooksTableProcessedTableManager =
    ProcessedTableManager<
      _$HadithCatalogDatabase,
      $HadithBooksTable,
      HadithBookRow,
      $$HadithBooksTableFilterComposer,
      $$HadithBooksTableOrderingComposer,
      $$HadithBooksTableAnnotationComposer,
      $$HadithBooksTableCreateCompanionBuilder,
      $$HadithBooksTableUpdateCompanionBuilder,
      (
        HadithBookRow,
        BaseReferences<
          _$HadithCatalogDatabase,
          $HadithBooksTable,
          HadithBookRow
        >,
      ),
      HadithBookRow,
      PrefetchHooks Function()
    >;
typedef $$HadithsTableCreateCompanionBuilder =
    HadithsCompanion Function({
      Value<int> id,
      required String bookId,
      required int number,
      required String chapterAr,
      required String titleAr,
      required String arabicText,
      required String narrator,
      required String reference,
      Value<String?> benefit,
      required String gradeTier,
      required String gradeLabelAr,
      required String gradeLabelEn,
      required int strengthScore,
      required int textLength,
    });
typedef $$HadithsTableUpdateCompanionBuilder =
    HadithsCompanion Function({
      Value<int> id,
      Value<String> bookId,
      Value<int> number,
      Value<String> chapterAr,
      Value<String> titleAr,
      Value<String> arabicText,
      Value<String> narrator,
      Value<String> reference,
      Value<String?> benefit,
      Value<String> gradeTier,
      Value<String> gradeLabelAr,
      Value<String> gradeLabelEn,
      Value<int> strengthScore,
      Value<int> textLength,
    });

class $$HadithsTableFilterComposer
    extends Composer<_$HadithCatalogDatabase, $HadithsTable> {
  $$HadithsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookId => $composableBuilder(
    column: $table.bookId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterAr => $composableBuilder(
    column: $table.chapterAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleAr => $composableBuilder(
    column: $table.titleAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get narrator => $composableBuilder(
    column: $table.narrator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get benefit => $composableBuilder(
    column: $table.benefit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gradeTier => $composableBuilder(
    column: $table.gradeTier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gradeLabelAr => $composableBuilder(
    column: $table.gradeLabelAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gradeLabelEn => $composableBuilder(
    column: $table.gradeLabelEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get strengthScore => $composableBuilder(
    column: $table.strengthScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get textLength => $composableBuilder(
    column: $table.textLength,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HadithsTableOrderingComposer
    extends Composer<_$HadithCatalogDatabase, $HadithsTable> {
  $$HadithsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookId => $composableBuilder(
    column: $table.bookId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterAr => $composableBuilder(
    column: $table.chapterAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleAr => $composableBuilder(
    column: $table.titleAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get narrator => $composableBuilder(
    column: $table.narrator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get benefit => $composableBuilder(
    column: $table.benefit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gradeTier => $composableBuilder(
    column: $table.gradeTier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gradeLabelAr => $composableBuilder(
    column: $table.gradeLabelAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gradeLabelEn => $composableBuilder(
    column: $table.gradeLabelEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get strengthScore => $composableBuilder(
    column: $table.strengthScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get textLength => $composableBuilder(
    column: $table.textLength,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HadithsTableAnnotationComposer
    extends Composer<_$HadithCatalogDatabase, $HadithsTable> {
  $$HadithsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get chapterAr =>
      $composableBuilder(column: $table.chapterAr, builder: (column) => column);

  GeneratedColumn<String> get titleAr =>
      $composableBuilder(column: $table.titleAr, builder: (column) => column);

  GeneratedColumn<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get narrator =>
      $composableBuilder(column: $table.narrator, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get benefit =>
      $composableBuilder(column: $table.benefit, builder: (column) => column);

  GeneratedColumn<String> get gradeTier =>
      $composableBuilder(column: $table.gradeTier, builder: (column) => column);

  GeneratedColumn<String> get gradeLabelAr => $composableBuilder(
    column: $table.gradeLabelAr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gradeLabelEn => $composableBuilder(
    column: $table.gradeLabelEn,
    builder: (column) => column,
  );

  GeneratedColumn<int> get strengthScore => $composableBuilder(
    column: $table.strengthScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get textLength => $composableBuilder(
    column: $table.textLength,
    builder: (column) => column,
  );
}

class $$HadithsTableTableManager
    extends
        RootTableManager<
          _$HadithCatalogDatabase,
          $HadithsTable,
          HadithCatalogRow,
          $$HadithsTableFilterComposer,
          $$HadithsTableOrderingComposer,
          $$HadithsTableAnnotationComposer,
          $$HadithsTableCreateCompanionBuilder,
          $$HadithsTableUpdateCompanionBuilder,
          (
            HadithCatalogRow,
            BaseReferences<
              _$HadithCatalogDatabase,
              $HadithsTable,
              HadithCatalogRow
            >,
          ),
          HadithCatalogRow,
          PrefetchHooks Function()
        > {
  $$HadithsTableTableManager(_$HadithCatalogDatabase db, $HadithsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HadithsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HadithsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HadithsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<String> chapterAr = const Value.absent(),
                Value<String> titleAr = const Value.absent(),
                Value<String> arabicText = const Value.absent(),
                Value<String> narrator = const Value.absent(),
                Value<String> reference = const Value.absent(),
                Value<String?> benefit = const Value.absent(),
                Value<String> gradeTier = const Value.absent(),
                Value<String> gradeLabelAr = const Value.absent(),
                Value<String> gradeLabelEn = const Value.absent(),
                Value<int> strengthScore = const Value.absent(),
                Value<int> textLength = const Value.absent(),
              }) => HadithsCompanion(
                id: id,
                bookId: bookId,
                number: number,
                chapterAr: chapterAr,
                titleAr: titleAr,
                arabicText: arabicText,
                narrator: narrator,
                reference: reference,
                benefit: benefit,
                gradeTier: gradeTier,
                gradeLabelAr: gradeLabelAr,
                gradeLabelEn: gradeLabelEn,
                strengthScore: strengthScore,
                textLength: textLength,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String bookId,
                required int number,
                required String chapterAr,
                required String titleAr,
                required String arabicText,
                required String narrator,
                required String reference,
                Value<String?> benefit = const Value.absent(),
                required String gradeTier,
                required String gradeLabelAr,
                required String gradeLabelEn,
                required int strengthScore,
                required int textLength,
              }) => HadithsCompanion.insert(
                id: id,
                bookId: bookId,
                number: number,
                chapterAr: chapterAr,
                titleAr: titleAr,
                arabicText: arabicText,
                narrator: narrator,
                reference: reference,
                benefit: benefit,
                gradeTier: gradeTier,
                gradeLabelAr: gradeLabelAr,
                gradeLabelEn: gradeLabelEn,
                strengthScore: strengthScore,
                textLength: textLength,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HadithsTableProcessedTableManager =
    ProcessedTableManager<
      _$HadithCatalogDatabase,
      $HadithsTable,
      HadithCatalogRow,
      $$HadithsTableFilterComposer,
      $$HadithsTableOrderingComposer,
      $$HadithsTableAnnotationComposer,
      $$HadithsTableCreateCompanionBuilder,
      $$HadithsTableUpdateCompanionBuilder,
      (
        HadithCatalogRow,
        BaseReferences<
          _$HadithCatalogDatabase,
          $HadithsTable,
          HadithCatalogRow
        >,
      ),
      HadithCatalogRow,
      PrefetchHooks Function()
    >;

class $HadithCatalogDatabaseManager {
  final _$HadithCatalogDatabase _db;
  $HadithCatalogDatabaseManager(this._db);
  $$HadithBooksTableTableManager get hadithBooks =>
      $$HadithBooksTableTableManager(_db, _db.hadithBooks);
  $$HadithsTableTableManager get hadiths =>
      $$HadithsTableTableManager(_db, _db.hadiths);
}
