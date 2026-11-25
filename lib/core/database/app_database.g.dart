// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TasbeehEntriesTable extends TasbeehEntries
    with TableInfo<$TasbeehEntriesTable, TasbeehEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasbeehEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _currentCountMeta = const VerificationMeta(
    'currentCount',
  );
  @override
  late final GeneratedColumn<int> currentCount = GeneratedColumn<int>(
    'current_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    arabicText,
    currentCount,
    totalCount,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasbeeh_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TasbeehEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('arabic_text')) {
      context.handle(
        _arabicTextMeta,
        arabicText.isAcceptableOrUnknown(data['arabic_text']!, _arabicTextMeta),
      );
    } else if (isInserting) {
      context.missing(_arabicTextMeta);
    }
    if (data.containsKey('current_count')) {
      context.handle(
        _currentCountMeta,
        currentCount.isAcceptableOrUnknown(
          data['current_count']!,
          _currentCountMeta,
        ),
      );
    }
    if (data.containsKey('total_count')) {
      context.handle(
        _totalCountMeta,
        totalCount.isAcceptableOrUnknown(data['total_count']!, _totalCountMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TasbeehEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TasbeehEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      arabicText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabic_text'],
      )!,
      currentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_count'],
      )!,
      totalCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_count'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $TasbeehEntriesTable createAlias(String alias) {
    return $TasbeehEntriesTable(attachedDatabase, alias);
  }
}

class TasbeehEntry extends DataClass implements Insertable<TasbeehEntry> {
  final String id;
  final String arabicText;
  final int currentCount;
  final int totalCount;
  final int sortOrder;
  const TasbeehEntry({
    required this.id,
    required this.arabicText,
    required this.currentCount,
    required this.totalCount,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['arabic_text'] = Variable<String>(arabicText);
    map['current_count'] = Variable<int>(currentCount);
    map['total_count'] = Variable<int>(totalCount);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  TasbeehEntriesCompanion toCompanion(bool nullToAbsent) {
    return TasbeehEntriesCompanion(
      id: Value(id),
      arabicText: Value(arabicText),
      currentCount: Value(currentCount),
      totalCount: Value(totalCount),
      sortOrder: Value(sortOrder),
    );
  }

  factory TasbeehEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TasbeehEntry(
      id: serializer.fromJson<String>(json['id']),
      arabicText: serializer.fromJson<String>(json['arabicText']),
      currentCount: serializer.fromJson<int>(json['currentCount']),
      totalCount: serializer.fromJson<int>(json['totalCount']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'arabicText': serializer.toJson<String>(arabicText),
      'currentCount': serializer.toJson<int>(currentCount),
      'totalCount': serializer.toJson<int>(totalCount),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  TasbeehEntry copyWith({
    String? id,
    String? arabicText,
    int? currentCount,
    int? totalCount,
    int? sortOrder,
  }) => TasbeehEntry(
    id: id ?? this.id,
    arabicText: arabicText ?? this.arabicText,
    currentCount: currentCount ?? this.currentCount,
    totalCount: totalCount ?? this.totalCount,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  TasbeehEntry copyWithCompanion(TasbeehEntriesCompanion data) {
    return TasbeehEntry(
      id: data.id.present ? data.id.value : this.id,
      arabicText: data.arabicText.present
          ? data.arabicText.value
          : this.arabicText,
      currentCount: data.currentCount.present
          ? data.currentCount.value
          : this.currentCount,
      totalCount: data.totalCount.present
          ? data.totalCount.value
          : this.totalCount,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TasbeehEntry(')
          ..write('id: $id, ')
          ..write('arabicText: $arabicText, ')
          ..write('currentCount: $currentCount, ')
          ..write('totalCount: $totalCount, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, arabicText, currentCount, totalCount, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TasbeehEntry &&
          other.id == this.id &&
          other.arabicText == this.arabicText &&
          other.currentCount == this.currentCount &&
          other.totalCount == this.totalCount &&
          other.sortOrder == this.sortOrder);
}

class TasbeehEntriesCompanion extends UpdateCompanion<TasbeehEntry> {
  final Value<String> id;
  final Value<String> arabicText;
  final Value<int> currentCount;
  final Value<int> totalCount;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const TasbeehEntriesCompanion({
    this.id = const Value.absent(),
    this.arabicText = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.totalCount = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasbeehEntriesCompanion.insert({
    required String id,
    required String arabicText,
    this.currentCount = const Value.absent(),
    this.totalCount = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       arabicText = Value(arabicText);
  static Insertable<TasbeehEntry> custom({
    Expression<String>? id,
    Expression<String>? arabicText,
    Expression<int>? currentCount,
    Expression<int>? totalCount,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (arabicText != null) 'arabic_text': arabicText,
      if (currentCount != null) 'current_count': currentCount,
      if (totalCount != null) 'total_count': totalCount,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasbeehEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? arabicText,
    Value<int>? currentCount,
    Value<int>? totalCount,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return TasbeehEntriesCompanion(
      id: id ?? this.id,
      arabicText: arabicText ?? this.arabicText,
      currentCount: currentCount ?? this.currentCount,
      totalCount: totalCount ?? this.totalCount,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (arabicText.present) {
      map['arabic_text'] = Variable<String>(arabicText.value);
    }
    if (currentCount.present) {
      map['current_count'] = Variable<int>(currentCount.value);
    }
    if (totalCount.present) {
      map['total_count'] = Variable<int>(totalCount.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasbeehEntriesCompanion(')
          ..write('id: $id, ')
          ..write('arabicText: $arabicText, ')
          ..write('currentCount: $currentCount, ')
          ..write('totalCount: $totalCount, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WirdEntriesTable extends WirdEntries
    with TableInfo<$WirdEntriesTable, WirdEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WirdEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _targetCountMeta = const VerificationMeta(
    'targetCount',
  );
  @override
  late final GeneratedColumn<int> targetCount = GeneratedColumn<int>(
    'target_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentCountMeta = const VerificationMeta(
    'currentCount',
  );
  @override
  late final GeneratedColumn<int> currentCount = GeneratedColumn<int>(
    'current_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    arabicText,
    targetCount,
    currentCount,
    isEnabled,
    isCustom,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wird_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WirdEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('arabic_text')) {
      context.handle(
        _arabicTextMeta,
        arabicText.isAcceptableOrUnknown(data['arabic_text']!, _arabicTextMeta),
      );
    } else if (isInserting) {
      context.missing(_arabicTextMeta);
    }
    if (data.containsKey('target_count')) {
      context.handle(
        _targetCountMeta,
        targetCount.isAcceptableOrUnknown(
          data['target_count']!,
          _targetCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetCountMeta);
    }
    if (data.containsKey('current_count')) {
      context.handle(
        _currentCountMeta,
        currentCount.isAcceptableOrUnknown(
          data['current_count']!,
          _currentCountMeta,
        ),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WirdEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WirdEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      arabicText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabic_text'],
      )!,
      targetCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_count'],
      )!,
      currentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_count'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $WirdEntriesTable createAlias(String alias) {
    return $WirdEntriesTable(attachedDatabase, alias);
  }
}

class WirdEntry extends DataClass implements Insertable<WirdEntry> {
  final String id;
  final String arabicText;
  final int targetCount;
  final int currentCount;
  final bool isEnabled;
  final bool isCustom;
  final int sortOrder;
  const WirdEntry({
    required this.id,
    required this.arabicText,
    required this.targetCount,
    required this.currentCount,
    required this.isEnabled,
    required this.isCustom,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['arabic_text'] = Variable<String>(arabicText);
    map['target_count'] = Variable<int>(targetCount);
    map['current_count'] = Variable<int>(currentCount);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['is_custom'] = Variable<bool>(isCustom);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  WirdEntriesCompanion toCompanion(bool nullToAbsent) {
    return WirdEntriesCompanion(
      id: Value(id),
      arabicText: Value(arabicText),
      targetCount: Value(targetCount),
      currentCount: Value(currentCount),
      isEnabled: Value(isEnabled),
      isCustom: Value(isCustom),
      sortOrder: Value(sortOrder),
    );
  }

  factory WirdEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WirdEntry(
      id: serializer.fromJson<String>(json['id']),
      arabicText: serializer.fromJson<String>(json['arabicText']),
      targetCount: serializer.fromJson<int>(json['targetCount']),
      currentCount: serializer.fromJson<int>(json['currentCount']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'arabicText': serializer.toJson<String>(arabicText),
      'targetCount': serializer.toJson<int>(targetCount),
      'currentCount': serializer.toJson<int>(currentCount),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'isCustom': serializer.toJson<bool>(isCustom),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  WirdEntry copyWith({
    String? id,
    String? arabicText,
    int? targetCount,
    int? currentCount,
    bool? isEnabled,
    bool? isCustom,
    int? sortOrder,
  }) => WirdEntry(
    id: id ?? this.id,
    arabicText: arabicText ?? this.arabicText,
    targetCount: targetCount ?? this.targetCount,
    currentCount: currentCount ?? this.currentCount,
    isEnabled: isEnabled ?? this.isEnabled,
    isCustom: isCustom ?? this.isCustom,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  WirdEntry copyWithCompanion(WirdEntriesCompanion data) {
    return WirdEntry(
      id: data.id.present ? data.id.value : this.id,
      arabicText: data.arabicText.present
          ? data.arabicText.value
          : this.arabicText,
      targetCount: data.targetCount.present
          ? data.targetCount.value
          : this.targetCount,
      currentCount: data.currentCount.present
          ? data.currentCount.value
          : this.currentCount,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WirdEntry(')
          ..write('id: $id, ')
          ..write('arabicText: $arabicText, ')
          ..write('targetCount: $targetCount, ')
          ..write('currentCount: $currentCount, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('isCustom: $isCustom, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    arabicText,
    targetCount,
    currentCount,
    isEnabled,
    isCustom,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WirdEntry &&
          other.id == this.id &&
          other.arabicText == this.arabicText &&
          other.targetCount == this.targetCount &&
          other.currentCount == this.currentCount &&
          other.isEnabled == this.isEnabled &&
          other.isCustom == this.isCustom &&
          other.sortOrder == this.sortOrder);
}

class WirdEntriesCompanion extends UpdateCompanion<WirdEntry> {
  final Value<String> id;
  final Value<String> arabicText;
  final Value<int> targetCount;
  final Value<int> currentCount;
  final Value<bool> isEnabled;
  final Value<bool> isCustom;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const WirdEntriesCompanion({
    this.id = const Value.absent(),
    this.arabicText = const Value.absent(),
    this.targetCount = const Value.absent(),
    this.currentCount = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WirdEntriesCompanion.insert({
    required String id,
    required String arabicText,
    required int targetCount,
    this.currentCount = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       arabicText = Value(arabicText),
       targetCount = Value(targetCount);
  static Insertable<WirdEntry> custom({
    Expression<String>? id,
    Expression<String>? arabicText,
    Expression<int>? targetCount,
    Expression<int>? currentCount,
    Expression<bool>? isEnabled,
    Expression<bool>? isCustom,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (arabicText != null) 'arabic_text': arabicText,
      if (targetCount != null) 'target_count': targetCount,
      if (currentCount != null) 'current_count': currentCount,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (isCustom != null) 'is_custom': isCustom,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WirdEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? arabicText,
    Value<int>? targetCount,
    Value<int>? currentCount,
    Value<bool>? isEnabled,
    Value<bool>? isCustom,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return WirdEntriesCompanion(
      id: id ?? this.id,
      arabicText: arabicText ?? this.arabicText,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      isEnabled: isEnabled ?? this.isEnabled,
      isCustom: isCustom ?? this.isCustom,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (arabicText.present) {
      map['arabic_text'] = Variable<String>(arabicText.value);
    }
    if (targetCount.present) {
      map['target_count'] = Variable<int>(targetCount.value);
    }
    if (currentCount.present) {
      map['current_count'] = Variable<int>(currentCount.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WirdEntriesCompanion(')
          ..write('id: $id, ')
          ..write('arabicText: $arabicText, ')
          ..write('targetCount: $targetCount, ')
          ..write('currentCount: $currentCount, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('isCustom: $isCustom, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasbeehDailyLogsTable extends TasbeehDailyLogs
    with TableInfo<$TasbeehDailyLogsTable, TasbeehDailyLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasbeehDailyLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateKeyMeta = const VerificationMeta(
    'dateKey',
  );
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
    'date_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tasbeehCountMeta = const VerificationMeta(
    'tasbeehCount',
  );
  @override
  late final GeneratedColumn<int> tasbeehCount = GeneratedColumn<int>(
    'tasbeeh_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _wirdCompletedCountMeta =
      const VerificationMeta('wirdCompletedCount');
  @override
  late final GeneratedColumn<int> wirdCompletedCount = GeneratedColumn<int>(
    'wird_completed_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _allWirdCompletedMeta = const VerificationMeta(
    'allWirdCompleted',
  );
  @override
  late final GeneratedColumn<bool> allWirdCompleted = GeneratedColumn<bool>(
    'all_wird_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("all_wird_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _quranAyahsReadMeta = const VerificationMeta(
    'quranAyahsRead',
  );
  @override
  late final GeneratedColumn<int> quranAyahsRead = GeneratedColumn<int>(
    'quran_ayahs_read',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    dateKey,
    tasbeehCount,
    wirdCompletedCount,
    allWirdCompleted,
    quranAyahsRead,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasbeeh_daily_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<TasbeehDailyLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('tasbeeh_count')) {
      context.handle(
        _tasbeehCountMeta,
        tasbeehCount.isAcceptableOrUnknown(
          data['tasbeeh_count']!,
          _tasbeehCountMeta,
        ),
      );
    }
    if (data.containsKey('wird_completed_count')) {
      context.handle(
        _wirdCompletedCountMeta,
        wirdCompletedCount.isAcceptableOrUnknown(
          data['wird_completed_count']!,
          _wirdCompletedCountMeta,
        ),
      );
    }
    if (data.containsKey('all_wird_completed')) {
      context.handle(
        _allWirdCompletedMeta,
        allWirdCompleted.isAcceptableOrUnknown(
          data['all_wird_completed']!,
          _allWirdCompletedMeta,
        ),
      );
    }
    if (data.containsKey('quran_ayahs_read')) {
      context.handle(
        _quranAyahsReadMeta,
        quranAyahsRead.isAcceptableOrUnknown(
          data['quran_ayahs_read']!,
          _quranAyahsReadMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dateKey};
  @override
  TasbeehDailyLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TasbeehDailyLog(
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_key'],
      )!,
      tasbeehCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tasbeeh_count'],
      )!,
      wirdCompletedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wird_completed_count'],
      )!,
      allWirdCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}all_wird_completed'],
      )!,
      quranAyahsRead: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quran_ayahs_read'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TasbeehDailyLogsTable createAlias(String alias) {
    return $TasbeehDailyLogsTable(attachedDatabase, alias);
  }
}

class TasbeehDailyLog extends DataClass implements Insertable<TasbeehDailyLog> {
  final String dateKey;
  final int tasbeehCount;
  final int wirdCompletedCount;
  final bool allWirdCompleted;
  final int quranAyahsRead;
  final DateTime updatedAt;
  const TasbeehDailyLog({
    required this.dateKey,
    required this.tasbeehCount,
    required this.wirdCompletedCount,
    required this.allWirdCompleted,
    required this.quranAyahsRead,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date_key'] = Variable<String>(dateKey);
    map['tasbeeh_count'] = Variable<int>(tasbeehCount);
    map['wird_completed_count'] = Variable<int>(wirdCompletedCount);
    map['all_wird_completed'] = Variable<bool>(allWirdCompleted);
    map['quran_ayahs_read'] = Variable<int>(quranAyahsRead);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TasbeehDailyLogsCompanion toCompanion(bool nullToAbsent) {
    return TasbeehDailyLogsCompanion(
      dateKey: Value(dateKey),
      tasbeehCount: Value(tasbeehCount),
      wirdCompletedCount: Value(wirdCompletedCount),
      allWirdCompleted: Value(allWirdCompleted),
      quranAyahsRead: Value(quranAyahsRead),
      updatedAt: Value(updatedAt),
    );
  }

  factory TasbeehDailyLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TasbeehDailyLog(
      dateKey: serializer.fromJson<String>(json['dateKey']),
      tasbeehCount: serializer.fromJson<int>(json['tasbeehCount']),
      wirdCompletedCount: serializer.fromJson<int>(json['wirdCompletedCount']),
      allWirdCompleted: serializer.fromJson<bool>(json['allWirdCompleted']),
      quranAyahsRead: serializer.fromJson<int>(json['quranAyahsRead']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dateKey': serializer.toJson<String>(dateKey),
      'tasbeehCount': serializer.toJson<int>(tasbeehCount),
      'wirdCompletedCount': serializer.toJson<int>(wirdCompletedCount),
      'allWirdCompleted': serializer.toJson<bool>(allWirdCompleted),
      'quranAyahsRead': serializer.toJson<int>(quranAyahsRead),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TasbeehDailyLog copyWith({
    String? dateKey,
    int? tasbeehCount,
    int? wirdCompletedCount,
    bool? allWirdCompleted,
    int? quranAyahsRead,
    DateTime? updatedAt,
  }) => TasbeehDailyLog(
    dateKey: dateKey ?? this.dateKey,
    tasbeehCount: tasbeehCount ?? this.tasbeehCount,
    wirdCompletedCount: wirdCompletedCount ?? this.wirdCompletedCount,
    allWirdCompleted: allWirdCompleted ?? this.allWirdCompleted,
    quranAyahsRead: quranAyahsRead ?? this.quranAyahsRead,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TasbeehDailyLog copyWithCompanion(TasbeehDailyLogsCompanion data) {
    return TasbeehDailyLog(
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      tasbeehCount: data.tasbeehCount.present
          ? data.tasbeehCount.value
          : this.tasbeehCount,
      wirdCompletedCount: data.wirdCompletedCount.present
          ? data.wirdCompletedCount.value
          : this.wirdCompletedCount,
      allWirdCompleted: data.allWirdCompleted.present
          ? data.allWirdCompleted.value
          : this.allWirdCompleted,
      quranAyahsRead: data.quranAyahsRead.present
          ? data.quranAyahsRead.value
          : this.quranAyahsRead,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TasbeehDailyLog(')
          ..write('dateKey: $dateKey, ')
          ..write('tasbeehCount: $tasbeehCount, ')
          ..write('wirdCompletedCount: $wirdCompletedCount, ')
          ..write('allWirdCompleted: $allWirdCompleted, ')
          ..write('quranAyahsRead: $quranAyahsRead, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    dateKey,
    tasbeehCount,
    wirdCompletedCount,
    allWirdCompleted,
    quranAyahsRead,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TasbeehDailyLog &&
          other.dateKey == this.dateKey &&
          other.tasbeehCount == this.tasbeehCount &&
          other.wirdCompletedCount == this.wirdCompletedCount &&
          other.allWirdCompleted == this.allWirdCompleted &&
          other.quranAyahsRead == this.quranAyahsRead &&
          other.updatedAt == this.updatedAt);
}

class TasbeehDailyLogsCompanion extends UpdateCompanion<TasbeehDailyLog> {
  final Value<String> dateKey;
  final Value<int> tasbeehCount;
  final Value<int> wirdCompletedCount;
  final Value<bool> allWirdCompleted;
  final Value<int> quranAyahsRead;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TasbeehDailyLogsCompanion({
    this.dateKey = const Value.absent(),
    this.tasbeehCount = const Value.absent(),
    this.wirdCompletedCount = const Value.absent(),
    this.allWirdCompleted = const Value.absent(),
    this.quranAyahsRead = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasbeehDailyLogsCompanion.insert({
    required String dateKey,
    this.tasbeehCount = const Value.absent(),
    this.wirdCompletedCount = const Value.absent(),
    this.allWirdCompleted = const Value.absent(),
    this.quranAyahsRead = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : dateKey = Value(dateKey);
  static Insertable<TasbeehDailyLog> custom({
    Expression<String>? dateKey,
    Expression<int>? tasbeehCount,
    Expression<int>? wirdCompletedCount,
    Expression<bool>? allWirdCompleted,
    Expression<int>? quranAyahsRead,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dateKey != null) 'date_key': dateKey,
      if (tasbeehCount != null) 'tasbeeh_count': tasbeehCount,
      if (wirdCompletedCount != null)
        'wird_completed_count': wirdCompletedCount,
      if (allWirdCompleted != null) 'all_wird_completed': allWirdCompleted,
      if (quranAyahsRead != null) 'quran_ayahs_read': quranAyahsRead,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasbeehDailyLogsCompanion copyWith({
    Value<String>? dateKey,
    Value<int>? tasbeehCount,
    Value<int>? wirdCompletedCount,
    Value<bool>? allWirdCompleted,
    Value<int>? quranAyahsRead,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TasbeehDailyLogsCompanion(
      dateKey: dateKey ?? this.dateKey,
      tasbeehCount: tasbeehCount ?? this.tasbeehCount,
      wirdCompletedCount: wirdCompletedCount ?? this.wirdCompletedCount,
      allWirdCompleted: allWirdCompleted ?? this.allWirdCompleted,
      quranAyahsRead: quranAyahsRead ?? this.quranAyahsRead,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (tasbeehCount.present) {
      map['tasbeeh_count'] = Variable<int>(tasbeehCount.value);
    }
    if (wirdCompletedCount.present) {
      map['wird_completed_count'] = Variable<int>(wirdCompletedCount.value);
    }
    if (allWirdCompleted.present) {
      map['all_wird_completed'] = Variable<bool>(allWirdCompleted.value);
    }
    if (quranAyahsRead.present) {
      map['quran_ayahs_read'] = Variable<int>(quranAyahsRead.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasbeehDailyLogsCompanion(')
          ..write('dateKey: $dateKey, ')
          ..write('tasbeehCount: $tasbeehCount, ')
          ..write('wirdCompletedCount: $wirdCompletedCount, ')
          ..write('allWirdCompleted: $allWirdCompleted, ')
          ..write('quranAyahsRead: $quranAyahsRead, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuranBookmarksTable extends QuranBookmarks
    with TableInfo<$QuranBookmarksTable, QuranBookmarkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuranBookmarksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _surahNameMeta = const VerificationMeta(
    'surahName',
  );
  @override
  late final GeneratedColumn<String> surahName = GeneratedColumn<String>(
    'surah_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahNumber,
    surahName,
    ayahNumber,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quran_bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuranBookmarkRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('surah_name')) {
      context.handle(
        _surahNameMeta,
        surahName.isAcceptableOrUnknown(data['surah_name']!, _surahNameMeta),
      );
    } else if (isInserting) {
      context.missing(_surahNameMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayah_number']!, _ayahNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {surahNumber, ayahNumber},
  ];
  @override
  QuranBookmarkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuranBookmarkRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      surahName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}surah_name'],
      )!,
      ayahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_number'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $QuranBookmarksTable createAlias(String alias) {
    return $QuranBookmarksTable(attachedDatabase, alias);
  }
}

class QuranBookmarkRow extends DataClass
    implements Insertable<QuranBookmarkRow> {
  final int id;
  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final String? note;
  final DateTime createdAt;
  const QuranBookmarkRow({
    required this.id,
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_number'] = Variable<int>(surahNumber);
    map['surah_name'] = Variable<String>(surahName);
    map['ayah_number'] = Variable<int>(ayahNumber);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  QuranBookmarksCompanion toCompanion(bool nullToAbsent) {
    return QuranBookmarksCompanion(
      id: Value(id),
      surahNumber: Value(surahNumber),
      surahName: Value(surahName),
      ayahNumber: Value(ayahNumber),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory QuranBookmarkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuranBookmarkRow(
      id: serializer.fromJson<int>(json['id']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      surahName: serializer.fromJson<String>(json['surahName']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'surahName': serializer.toJson<String>(surahName),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  QuranBookmarkRow copyWith({
    int? id,
    int? surahNumber,
    String? surahName,
    int? ayahNumber,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => QuranBookmarkRow(
    id: id ?? this.id,
    surahNumber: surahNumber ?? this.surahNumber,
    surahName: surahName ?? this.surahName,
    ayahNumber: ayahNumber ?? this.ayahNumber,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  QuranBookmarkRow copyWithCompanion(QuranBookmarksCompanion data) {
    return QuranBookmarkRow(
      id: data.id.present ? data.id.value : this.id,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      surahName: data.surahName.present ? data.surahName.value : this.surahName,
      ayahNumber: data.ayahNumber.present
          ? data.ayahNumber.value
          : this.ayahNumber,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuranBookmarkRow(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('surahName: $surahName, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, surahNumber, surahName, ayahNumber, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuranBookmarkRow &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.surahName == this.surahName &&
          other.ayahNumber == this.ayahNumber &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class QuranBookmarksCompanion extends UpdateCompanion<QuranBookmarkRow> {
  final Value<int> id;
  final Value<int> surahNumber;
  final Value<String> surahName;
  final Value<int> ayahNumber;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const QuranBookmarksCompanion({
    this.id = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.surahName = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  QuranBookmarksCompanion.insert({
    this.id = const Value.absent(),
    required int surahNumber,
    required String surahName,
    required int ayahNumber,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : surahNumber = Value(surahNumber),
       surahName = Value(surahName),
       ayahNumber = Value(ayahNumber);
  static Insertable<QuranBookmarkRow> custom({
    Expression<int>? id,
    Expression<int>? surahNumber,
    Expression<String>? surahName,
    Expression<int>? ayahNumber,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (surahName != null) 'surah_name': surahName,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  QuranBookmarksCompanion copyWith({
    Value<int>? id,
    Value<int>? surahNumber,
    Value<String>? surahName,
    Value<int>? ayahNumber,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return QuranBookmarksCompanion(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      surahName: surahName ?? this.surahName,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (surahName.present) {
      map['surah_name'] = Variable<String>(surahName.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuranBookmarksCompanion(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('surahName: $surahName, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $QuranReadingStatesTable extends QuranReadingStates
    with TableInfo<$QuranReadingStatesTable, QuranReadingState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuranReadingStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _lastSurahMeta = const VerificationMeta(
    'lastSurah',
  );
  @override
  late final GeneratedColumn<int> lastSurah = GeneratedColumn<int>(
    'last_surah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(18),
  );
  static const VerificationMeta _lastSurahNameMeta = const VerificationMeta(
    'lastSurahName',
  );
  @override
  late final GeneratedColumn<String> lastSurahName = GeneratedColumn<String>(
    'last_surah_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('الكهف'),
  );
  static const VerificationMeta _lastAyahMeta = const VerificationMeta(
    'lastAyah',
  );
  @override
  late final GeneratedColumn<int> lastAyah = GeneratedColumn<int>(
    'last_ayah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _lastReadAtMeta = const VerificationMeta(
    'lastReadAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReadAt = GeneratedColumn<DateTime>(
    'last_read_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _wirdDailyCountMeta = const VerificationMeta(
    'wirdDailyCount',
  );
  @override
  late final GeneratedColumn<int> wirdDailyCount = GeneratedColumn<int>(
    'wird_daily_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _wirdCursorAyahMeta = const VerificationMeta(
    'wirdCursorAyah',
  );
  @override
  late final GeneratedColumn<int> wirdCursorAyah = GeneratedColumn<int>(
    'wird_cursor_ayah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _wirdCompletedDateMeta = const VerificationMeta(
    'wirdCompletedDate',
  );
  @override
  late final GeneratedColumn<String> wirdCompletedDate =
      GeneratedColumn<String>(
        'wird_completed_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _wirdCursorCompletedMeta =
      const VerificationMeta('wirdCursorCompleted');
  @override
  late final GeneratedColumn<bool> wirdCursorCompleted = GeneratedColumn<bool>(
    'wird_cursor_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("wird_cursor_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _wirdLastBatchEndMeta = const VerificationMeta(
    'wirdLastBatchEnd',
  );
  @override
  late final GeneratedColumn<int> wirdLastBatchEnd = GeneratedColumn<int>(
    'wird_last_batch_end',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lastSurah,
    lastSurahName,
    lastAyah,
    lastReadAt,
    wirdDailyCount,
    wirdCursorAyah,
    wirdCompletedDate,
    wirdCursorCompleted,
    wirdLastBatchEnd,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quran_reading_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuranReadingState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_surah')) {
      context.handle(
        _lastSurahMeta,
        lastSurah.isAcceptableOrUnknown(data['last_surah']!, _lastSurahMeta),
      );
    }
    if (data.containsKey('last_surah_name')) {
      context.handle(
        _lastSurahNameMeta,
        lastSurahName.isAcceptableOrUnknown(
          data['last_surah_name']!,
          _lastSurahNameMeta,
        ),
      );
    }
    if (data.containsKey('last_ayah')) {
      context.handle(
        _lastAyahMeta,
        lastAyah.isAcceptableOrUnknown(data['last_ayah']!, _lastAyahMeta),
      );
    }
    if (data.containsKey('last_read_at')) {
      context.handle(
        _lastReadAtMeta,
        lastReadAt.isAcceptableOrUnknown(
          data['last_read_at']!,
          _lastReadAtMeta,
        ),
      );
    }
    if (data.containsKey('wird_daily_count')) {
      context.handle(
        _wirdDailyCountMeta,
        wirdDailyCount.isAcceptableOrUnknown(
          data['wird_daily_count']!,
          _wirdDailyCountMeta,
        ),
      );
    }
    if (data.containsKey('wird_cursor_ayah')) {
      context.handle(
        _wirdCursorAyahMeta,
        wirdCursorAyah.isAcceptableOrUnknown(
          data['wird_cursor_ayah']!,
          _wirdCursorAyahMeta,
        ),
      );
    }
    if (data.containsKey('wird_completed_date')) {
      context.handle(
        _wirdCompletedDateMeta,
        wirdCompletedDate.isAcceptableOrUnknown(
          data['wird_completed_date']!,
          _wirdCompletedDateMeta,
        ),
      );
    }
    if (data.containsKey('wird_cursor_completed')) {
      context.handle(
        _wirdCursorCompletedMeta,
        wirdCursorCompleted.isAcceptableOrUnknown(
          data['wird_cursor_completed']!,
          _wirdCursorCompletedMeta,
        ),
      );
    }
    if (data.containsKey('wird_last_batch_end')) {
      context.handle(
        _wirdLastBatchEndMeta,
        wirdLastBatchEnd.isAcceptableOrUnknown(
          data['wird_last_batch_end']!,
          _wirdLastBatchEndMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuranReadingState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuranReadingState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lastSurah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_surah'],
      )!,
      lastSurahName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_surah_name'],
      )!,
      lastAyah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_ayah'],
      )!,
      lastReadAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_read_at'],
      )!,
      wirdDailyCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wird_daily_count'],
      )!,
      wirdCursorAyah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wird_cursor_ayah'],
      )!,
      wirdCompletedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wird_completed_date'],
      ),
      wirdCursorCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}wird_cursor_completed'],
      )!,
      wirdLastBatchEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wird_last_batch_end'],
      )!,
    );
  }

  @override
  $QuranReadingStatesTable createAlias(String alias) {
    return $QuranReadingStatesTable(attachedDatabase, alias);
  }
}

class QuranReadingState extends DataClass
    implements Insertable<QuranReadingState> {
  final int id;
  final int lastSurah;
  final String lastSurahName;
  final int lastAyah;
  final DateTime lastReadAt;
  final int wirdDailyCount;
  final int wirdCursorAyah;
  final String? wirdCompletedDate;
  final bool wirdCursorCompleted;
  final int wirdLastBatchEnd;
  const QuranReadingState({
    required this.id,
    required this.lastSurah,
    required this.lastSurahName,
    required this.lastAyah,
    required this.lastReadAt,
    required this.wirdDailyCount,
    required this.wirdCursorAyah,
    this.wirdCompletedDate,
    required this.wirdCursorCompleted,
    required this.wirdLastBatchEnd,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['last_surah'] = Variable<int>(lastSurah);
    map['last_surah_name'] = Variable<String>(lastSurahName);
    map['last_ayah'] = Variable<int>(lastAyah);
    map['last_read_at'] = Variable<DateTime>(lastReadAt);
    map['wird_daily_count'] = Variable<int>(wirdDailyCount);
    map['wird_cursor_ayah'] = Variable<int>(wirdCursorAyah);
    if (!nullToAbsent || wirdCompletedDate != null) {
      map['wird_completed_date'] = Variable<String>(wirdCompletedDate);
    }
    map['wird_cursor_completed'] = Variable<bool>(wirdCursorCompleted);
    map['wird_last_batch_end'] = Variable<int>(wirdLastBatchEnd);
    return map;
  }

  QuranReadingStatesCompanion toCompanion(bool nullToAbsent) {
    return QuranReadingStatesCompanion(
      id: Value(id),
      lastSurah: Value(lastSurah),
      lastSurahName: Value(lastSurahName),
      lastAyah: Value(lastAyah),
      lastReadAt: Value(lastReadAt),
      wirdDailyCount: Value(wirdDailyCount),
      wirdCursorAyah: Value(wirdCursorAyah),
      wirdCompletedDate: wirdCompletedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(wirdCompletedDate),
      wirdCursorCompleted: Value(wirdCursorCompleted),
      wirdLastBatchEnd: Value(wirdLastBatchEnd),
    );
  }

  factory QuranReadingState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuranReadingState(
      id: serializer.fromJson<int>(json['id']),
      lastSurah: serializer.fromJson<int>(json['lastSurah']),
      lastSurahName: serializer.fromJson<String>(json['lastSurahName']),
      lastAyah: serializer.fromJson<int>(json['lastAyah']),
      lastReadAt: serializer.fromJson<DateTime>(json['lastReadAt']),
      wirdDailyCount: serializer.fromJson<int>(json['wirdDailyCount']),
      wirdCursorAyah: serializer.fromJson<int>(json['wirdCursorAyah']),
      wirdCompletedDate: serializer.fromJson<String?>(
        json['wirdCompletedDate'],
      ),
      wirdCursorCompleted: serializer.fromJson<bool>(
        json['wirdCursorCompleted'],
      ),
      wirdLastBatchEnd: serializer.fromJson<int>(json['wirdLastBatchEnd']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastSurah': serializer.toJson<int>(lastSurah),
      'lastSurahName': serializer.toJson<String>(lastSurahName),
      'lastAyah': serializer.toJson<int>(lastAyah),
      'lastReadAt': serializer.toJson<DateTime>(lastReadAt),
      'wirdDailyCount': serializer.toJson<int>(wirdDailyCount),
      'wirdCursorAyah': serializer.toJson<int>(wirdCursorAyah),
      'wirdCompletedDate': serializer.toJson<String?>(wirdCompletedDate),
      'wirdCursorCompleted': serializer.toJson<bool>(wirdCursorCompleted),
      'wirdLastBatchEnd': serializer.toJson<int>(wirdLastBatchEnd),
    };
  }

  QuranReadingState copyWith({
    int? id,
    int? lastSurah,
    String? lastSurahName,
    int? lastAyah,
    DateTime? lastReadAt,
    int? wirdDailyCount,
    int? wirdCursorAyah,
    Value<String?> wirdCompletedDate = const Value.absent(),
    bool? wirdCursorCompleted,
    int? wirdLastBatchEnd,
  }) => QuranReadingState(
    id: id ?? this.id,
    lastSurah: lastSurah ?? this.lastSurah,
    lastSurahName: lastSurahName ?? this.lastSurahName,
    lastAyah: lastAyah ?? this.lastAyah,
    lastReadAt: lastReadAt ?? this.lastReadAt,
    wirdDailyCount: wirdDailyCount ?? this.wirdDailyCount,
    wirdCursorAyah: wirdCursorAyah ?? this.wirdCursorAyah,
    wirdCompletedDate: wirdCompletedDate.present
        ? wirdCompletedDate.value
        : this.wirdCompletedDate,
    wirdCursorCompleted: wirdCursorCompleted ?? this.wirdCursorCompleted,
    wirdLastBatchEnd: wirdLastBatchEnd ?? this.wirdLastBatchEnd,
  );
  QuranReadingState copyWithCompanion(QuranReadingStatesCompanion data) {
    return QuranReadingState(
      id: data.id.present ? data.id.value : this.id,
      lastSurah: data.lastSurah.present ? data.lastSurah.value : this.lastSurah,
      lastSurahName: data.lastSurahName.present
          ? data.lastSurahName.value
          : this.lastSurahName,
      lastAyah: data.lastAyah.present ? data.lastAyah.value : this.lastAyah,
      lastReadAt: data.lastReadAt.present
          ? data.lastReadAt.value
          : this.lastReadAt,
      wirdDailyCount: data.wirdDailyCount.present
          ? data.wirdDailyCount.value
          : this.wirdDailyCount,
      wirdCursorAyah: data.wirdCursorAyah.present
          ? data.wirdCursorAyah.value
          : this.wirdCursorAyah,
      wirdCompletedDate: data.wirdCompletedDate.present
          ? data.wirdCompletedDate.value
          : this.wirdCompletedDate,
      wirdCursorCompleted: data.wirdCursorCompleted.present
          ? data.wirdCursorCompleted.value
          : this.wirdCursorCompleted,
      wirdLastBatchEnd: data.wirdLastBatchEnd.present
          ? data.wirdLastBatchEnd.value
          : this.wirdLastBatchEnd,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuranReadingState(')
          ..write('id: $id, ')
          ..write('lastSurah: $lastSurah, ')
          ..write('lastSurahName: $lastSurahName, ')
          ..write('lastAyah: $lastAyah, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('wirdDailyCount: $wirdDailyCount, ')
          ..write('wirdCursorAyah: $wirdCursorAyah, ')
          ..write('wirdCompletedDate: $wirdCompletedDate, ')
          ..write('wirdCursorCompleted: $wirdCursorCompleted, ')
          ..write('wirdLastBatchEnd: $wirdLastBatchEnd')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lastSurah,
    lastSurahName,
    lastAyah,
    lastReadAt,
    wirdDailyCount,
    wirdCursorAyah,
    wirdCompletedDate,
    wirdCursorCompleted,
    wirdLastBatchEnd,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuranReadingState &&
          other.id == this.id &&
          other.lastSurah == this.lastSurah &&
          other.lastSurahName == this.lastSurahName &&
          other.lastAyah == this.lastAyah &&
          other.lastReadAt == this.lastReadAt &&
          other.wirdDailyCount == this.wirdDailyCount &&
          other.wirdCursorAyah == this.wirdCursorAyah &&
          other.wirdCompletedDate == this.wirdCompletedDate &&
          other.wirdCursorCompleted == this.wirdCursorCompleted &&
          other.wirdLastBatchEnd == this.wirdLastBatchEnd);
}

class QuranReadingStatesCompanion extends UpdateCompanion<QuranReadingState> {
  final Value<int> id;
  final Value<int> lastSurah;
  final Value<String> lastSurahName;
  final Value<int> lastAyah;
  final Value<DateTime> lastReadAt;
  final Value<int> wirdDailyCount;
  final Value<int> wirdCursorAyah;
  final Value<String?> wirdCompletedDate;
  final Value<bool> wirdCursorCompleted;
  final Value<int> wirdLastBatchEnd;
  const QuranReadingStatesCompanion({
    this.id = const Value.absent(),
    this.lastSurah = const Value.absent(),
    this.lastSurahName = const Value.absent(),
    this.lastAyah = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.wirdDailyCount = const Value.absent(),
    this.wirdCursorAyah = const Value.absent(),
    this.wirdCompletedDate = const Value.absent(),
    this.wirdCursorCompleted = const Value.absent(),
    this.wirdLastBatchEnd = const Value.absent(),
  });
  QuranReadingStatesCompanion.insert({
    this.id = const Value.absent(),
    this.lastSurah = const Value.absent(),
    this.lastSurahName = const Value.absent(),
    this.lastAyah = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.wirdDailyCount = const Value.absent(),
    this.wirdCursorAyah = const Value.absent(),
    this.wirdCompletedDate = const Value.absent(),
    this.wirdCursorCompleted = const Value.absent(),
    this.wirdLastBatchEnd = const Value.absent(),
  });
  static Insertable<QuranReadingState> custom({
    Expression<int>? id,
    Expression<int>? lastSurah,
    Expression<String>? lastSurahName,
    Expression<int>? lastAyah,
    Expression<DateTime>? lastReadAt,
    Expression<int>? wirdDailyCount,
    Expression<int>? wirdCursorAyah,
    Expression<String>? wirdCompletedDate,
    Expression<bool>? wirdCursorCompleted,
    Expression<int>? wirdLastBatchEnd,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastSurah != null) 'last_surah': lastSurah,
      if (lastSurahName != null) 'last_surah_name': lastSurahName,
      if (lastAyah != null) 'last_ayah': lastAyah,
      if (lastReadAt != null) 'last_read_at': lastReadAt,
      if (wirdDailyCount != null) 'wird_daily_count': wirdDailyCount,
      if (wirdCursorAyah != null) 'wird_cursor_ayah': wirdCursorAyah,
      if (wirdCompletedDate != null) 'wird_completed_date': wirdCompletedDate,
      if (wirdCursorCompleted != null)
        'wird_cursor_completed': wirdCursorCompleted,
      if (wirdLastBatchEnd != null) 'wird_last_batch_end': wirdLastBatchEnd,
    });
  }

  QuranReadingStatesCompanion copyWith({
    Value<int>? id,
    Value<int>? lastSurah,
    Value<String>? lastSurahName,
    Value<int>? lastAyah,
    Value<DateTime>? lastReadAt,
    Value<int>? wirdDailyCount,
    Value<int>? wirdCursorAyah,
    Value<String?>? wirdCompletedDate,
    Value<bool>? wirdCursorCompleted,
    Value<int>? wirdLastBatchEnd,
  }) {
    return QuranReadingStatesCompanion(
      id: id ?? this.id,
      lastSurah: lastSurah ?? this.lastSurah,
      lastSurahName: lastSurahName ?? this.lastSurahName,
      lastAyah: lastAyah ?? this.lastAyah,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      wirdDailyCount: wirdDailyCount ?? this.wirdDailyCount,
      wirdCursorAyah: wirdCursorAyah ?? this.wirdCursorAyah,
      wirdCompletedDate: wirdCompletedDate ?? this.wirdCompletedDate,
      wirdCursorCompleted: wirdCursorCompleted ?? this.wirdCursorCompleted,
      wirdLastBatchEnd: wirdLastBatchEnd ?? this.wirdLastBatchEnd,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastSurah.present) {
      map['last_surah'] = Variable<int>(lastSurah.value);
    }
    if (lastSurahName.present) {
      map['last_surah_name'] = Variable<String>(lastSurahName.value);
    }
    if (lastAyah.present) {
      map['last_ayah'] = Variable<int>(lastAyah.value);
    }
    if (lastReadAt.present) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt.value);
    }
    if (wirdDailyCount.present) {
      map['wird_daily_count'] = Variable<int>(wirdDailyCount.value);
    }
    if (wirdCursorAyah.present) {
      map['wird_cursor_ayah'] = Variable<int>(wirdCursorAyah.value);
    }
    if (wirdCompletedDate.present) {
      map['wird_completed_date'] = Variable<String>(wirdCompletedDate.value);
    }
    if (wirdCursorCompleted.present) {
      map['wird_cursor_completed'] = Variable<bool>(wirdCursorCompleted.value);
    }
    if (wirdLastBatchEnd.present) {
      map['wird_last_batch_end'] = Variable<int>(wirdLastBatchEnd.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuranReadingStatesCompanion(')
          ..write('id: $id, ')
          ..write('lastSurah: $lastSurah, ')
          ..write('lastSurahName: $lastSurahName, ')
          ..write('lastAyah: $lastAyah, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('wirdDailyCount: $wirdDailyCount, ')
          ..write('wirdCursorAyah: $wirdCursorAyah, ')
          ..write('wirdCompletedDate: $wirdCompletedDate, ')
          ..write('wirdCursorCompleted: $wirdCursorCompleted, ')
          ..write('wirdLastBatchEnd: $wirdLastBatchEnd')
          ..write(')'))
        .toString();
  }
}

class $AzkarProgressEntriesTable extends AzkarProgressEntries
    with TableInfo<$AzkarProgressEntriesTable, AzkarProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AzkarProgressEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dhikrIdMeta = const VerificationMeta(
    'dhikrId',
  );
  @override
  late final GeneratedColumn<String> dhikrId = GeneratedColumn<String>(
    'dhikr_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remainingCountMeta = const VerificationMeta(
    'remainingCount',
  );
  @override
  late final GeneratedColumn<int> remainingCount = GeneratedColumn<int>(
    'remaining_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    categoryId,
    dhikrId,
    remainingCount,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'azkar_progress_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AzkarProgressEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('dhikr_id')) {
      context.handle(
        _dhikrIdMeta,
        dhikrId.isAcceptableOrUnknown(data['dhikr_id']!, _dhikrIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dhikrIdMeta);
    }
    if (data.containsKey('remaining_count')) {
      context.handle(
        _remainingCountMeta,
        remainingCount.isAcceptableOrUnknown(
          data['remaining_count']!,
          _remainingCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remainingCountMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {categoryId, dhikrId};
  @override
  AzkarProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AzkarProgressEntry(
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      dhikrId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dhikr_id'],
      )!,
      remainingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remaining_count'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AzkarProgressEntriesTable createAlias(String alias) {
    return $AzkarProgressEntriesTable(attachedDatabase, alias);
  }
}

class AzkarProgressEntry extends DataClass
    implements Insertable<AzkarProgressEntry> {
  final String categoryId;
  final String dhikrId;
  final int remainingCount;
  final DateTime updatedAt;
  const AzkarProgressEntry({
    required this.categoryId,
    required this.dhikrId,
    required this.remainingCount,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['category_id'] = Variable<String>(categoryId);
    map['dhikr_id'] = Variable<String>(dhikrId);
    map['remaining_count'] = Variable<int>(remainingCount);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AzkarProgressEntriesCompanion toCompanion(bool nullToAbsent) {
    return AzkarProgressEntriesCompanion(
      categoryId: Value(categoryId),
      dhikrId: Value(dhikrId),
      remainingCount: Value(remainingCount),
      updatedAt: Value(updatedAt),
    );
  }

  factory AzkarProgressEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AzkarProgressEntry(
      categoryId: serializer.fromJson<String>(json['categoryId']),
      dhikrId: serializer.fromJson<String>(json['dhikrId']),
      remainingCount: serializer.fromJson<int>(json['remainingCount']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'categoryId': serializer.toJson<String>(categoryId),
      'dhikrId': serializer.toJson<String>(dhikrId),
      'remainingCount': serializer.toJson<int>(remainingCount),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AzkarProgressEntry copyWith({
    String? categoryId,
    String? dhikrId,
    int? remainingCount,
    DateTime? updatedAt,
  }) => AzkarProgressEntry(
    categoryId: categoryId ?? this.categoryId,
    dhikrId: dhikrId ?? this.dhikrId,
    remainingCount: remainingCount ?? this.remainingCount,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AzkarProgressEntry copyWithCompanion(AzkarProgressEntriesCompanion data) {
    return AzkarProgressEntry(
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      dhikrId: data.dhikrId.present ? data.dhikrId.value : this.dhikrId,
      remainingCount: data.remainingCount.present
          ? data.remainingCount.value
          : this.remainingCount,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AzkarProgressEntry(')
          ..write('categoryId: $categoryId, ')
          ..write('dhikrId: $dhikrId, ')
          ..write('remainingCount: $remainingCount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(categoryId, dhikrId, remainingCount, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AzkarProgressEntry &&
          other.categoryId == this.categoryId &&
          other.dhikrId == this.dhikrId &&
          other.remainingCount == this.remainingCount &&
          other.updatedAt == this.updatedAt);
}

class AzkarProgressEntriesCompanion
    extends UpdateCompanion<AzkarProgressEntry> {
  final Value<String> categoryId;
  final Value<String> dhikrId;
  final Value<int> remainingCount;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AzkarProgressEntriesCompanion({
    this.categoryId = const Value.absent(),
    this.dhikrId = const Value.absent(),
    this.remainingCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AzkarProgressEntriesCompanion.insert({
    required String categoryId,
    required String dhikrId,
    required int remainingCount,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : categoryId = Value(categoryId),
       dhikrId = Value(dhikrId),
       remainingCount = Value(remainingCount);
  static Insertable<AzkarProgressEntry> custom({
    Expression<String>? categoryId,
    Expression<String>? dhikrId,
    Expression<int>? remainingCount,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (categoryId != null) 'category_id': categoryId,
      if (dhikrId != null) 'dhikr_id': dhikrId,
      if (remainingCount != null) 'remaining_count': remainingCount,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AzkarProgressEntriesCompanion copyWith({
    Value<String>? categoryId,
    Value<String>? dhikrId,
    Value<int>? remainingCount,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AzkarProgressEntriesCompanion(
      categoryId: categoryId ?? this.categoryId,
      dhikrId: dhikrId ?? this.dhikrId,
      remainingCount: remainingCount ?? this.remainingCount,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (dhikrId.present) {
      map['dhikr_id'] = Variable<String>(dhikrId.value);
    }
    if (remainingCount.present) {
      map['remaining_count'] = Variable<int>(remainingCount.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AzkarProgressEntriesCompanion(')
          ..write('categoryId: $categoryId, ')
          ..write('dhikrId: $dhikrId, ')
          ..write('remainingCount: $remainingCount, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TasbeehEntriesTable tasbeehEntries = $TasbeehEntriesTable(this);
  late final $WirdEntriesTable wirdEntries = $WirdEntriesTable(this);
  late final $TasbeehDailyLogsTable tasbeehDailyLogs = $TasbeehDailyLogsTable(
    this,
  );
  late final $QuranBookmarksTable quranBookmarks = $QuranBookmarksTable(this);
  late final $QuranReadingStatesTable quranReadingStates =
      $QuranReadingStatesTable(this);
  late final $AzkarProgressEntriesTable azkarProgressEntries =
      $AzkarProgressEntriesTable(this);
  late final TasbeehDao tasbeehDao = TasbeehDao(this as AppDatabase);
  late final QuranDao quranDao = QuranDao(this as AppDatabase);
  late final AzkarDao azkarDao = AzkarDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tasbeehEntries,
    wirdEntries,
    tasbeehDailyLogs,
    quranBookmarks,
    quranReadingStates,
    azkarProgressEntries,
  ];
}

typedef $$TasbeehEntriesTableCreateCompanionBuilder =
    TasbeehEntriesCompanion Function({
      required String id,
      required String arabicText,
      Value<int> currentCount,
      Value<int> totalCount,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$TasbeehEntriesTableUpdateCompanionBuilder =
    TasbeehEntriesCompanion Function({
      Value<String> id,
      Value<String> arabicText,
      Value<int> currentCount,
      Value<int> totalCount,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$TasbeehEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TasbeehEntriesTable> {
  $$TasbeehEntriesTableFilterComposer({
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

  ColumnFilters<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCount => $composableBuilder(
    column: $table.totalCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasbeehEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TasbeehEntriesTable> {
  $$TasbeehEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCount => $composableBuilder(
    column: $table.totalCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasbeehEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasbeehEntriesTable> {
  $$TasbeehEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCount => $composableBuilder(
    column: $table.totalCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$TasbeehEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasbeehEntriesTable,
          TasbeehEntry,
          $$TasbeehEntriesTableFilterComposer,
          $$TasbeehEntriesTableOrderingComposer,
          $$TasbeehEntriesTableAnnotationComposer,
          $$TasbeehEntriesTableCreateCompanionBuilder,
          $$TasbeehEntriesTableUpdateCompanionBuilder,
          (
            TasbeehEntry,
            BaseReferences<_$AppDatabase, $TasbeehEntriesTable, TasbeehEntry>,
          ),
          TasbeehEntry,
          PrefetchHooks Function()
        > {
  $$TasbeehEntriesTableTableManager(
    _$AppDatabase db,
    $TasbeehEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasbeehEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasbeehEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasbeehEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> arabicText = const Value.absent(),
                Value<int> currentCount = const Value.absent(),
                Value<int> totalCount = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasbeehEntriesCompanion(
                id: id,
                arabicText: arabicText,
                currentCount: currentCount,
                totalCount: totalCount,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String arabicText,
                Value<int> currentCount = const Value.absent(),
                Value<int> totalCount = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasbeehEntriesCompanion.insert(
                id: id,
                arabicText: arabicText,
                currentCount: currentCount,
                totalCount: totalCount,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasbeehEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasbeehEntriesTable,
      TasbeehEntry,
      $$TasbeehEntriesTableFilterComposer,
      $$TasbeehEntriesTableOrderingComposer,
      $$TasbeehEntriesTableAnnotationComposer,
      $$TasbeehEntriesTableCreateCompanionBuilder,
      $$TasbeehEntriesTableUpdateCompanionBuilder,
      (
        TasbeehEntry,
        BaseReferences<_$AppDatabase, $TasbeehEntriesTable, TasbeehEntry>,
      ),
      TasbeehEntry,
      PrefetchHooks Function()
    >;
typedef $$WirdEntriesTableCreateCompanionBuilder =
    WirdEntriesCompanion Function({
      required String id,
      required String arabicText,
      required int targetCount,
      Value<int> currentCount,
      Value<bool> isEnabled,
      Value<bool> isCustom,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$WirdEntriesTableUpdateCompanionBuilder =
    WirdEntriesCompanion Function({
      Value<String> id,
      Value<String> arabicText,
      Value<int> targetCount,
      Value<int> currentCount,
      Value<bool> isEnabled,
      Value<bool> isCustom,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$WirdEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WirdEntriesTable> {
  $$WirdEntriesTableFilterComposer({
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

  ColumnFilters<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WirdEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WirdEntriesTable> {
  $$WirdEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WirdEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WirdEntriesTable> {
  $$WirdEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetCount => $composableBuilder(
    column: $table.targetCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentCount => $composableBuilder(
    column: $table.currentCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$WirdEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WirdEntriesTable,
          WirdEntry,
          $$WirdEntriesTableFilterComposer,
          $$WirdEntriesTableOrderingComposer,
          $$WirdEntriesTableAnnotationComposer,
          $$WirdEntriesTableCreateCompanionBuilder,
          $$WirdEntriesTableUpdateCompanionBuilder,
          (
            WirdEntry,
            BaseReferences<_$AppDatabase, $WirdEntriesTable, WirdEntry>,
          ),
          WirdEntry,
          PrefetchHooks Function()
        > {
  $$WirdEntriesTableTableManager(_$AppDatabase db, $WirdEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WirdEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WirdEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WirdEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> arabicText = const Value.absent(),
                Value<int> targetCount = const Value.absent(),
                Value<int> currentCount = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WirdEntriesCompanion(
                id: id,
                arabicText: arabicText,
                targetCount: targetCount,
                currentCount: currentCount,
                isEnabled: isEnabled,
                isCustom: isCustom,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String arabicText,
                required int targetCount,
                Value<int> currentCount = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WirdEntriesCompanion.insert(
                id: id,
                arabicText: arabicText,
                targetCount: targetCount,
                currentCount: currentCount,
                isEnabled: isEnabled,
                isCustom: isCustom,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WirdEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WirdEntriesTable,
      WirdEntry,
      $$WirdEntriesTableFilterComposer,
      $$WirdEntriesTableOrderingComposer,
      $$WirdEntriesTableAnnotationComposer,
      $$WirdEntriesTableCreateCompanionBuilder,
      $$WirdEntriesTableUpdateCompanionBuilder,
      (WirdEntry, BaseReferences<_$AppDatabase, $WirdEntriesTable, WirdEntry>),
      WirdEntry,
      PrefetchHooks Function()
    >;
typedef $$TasbeehDailyLogsTableCreateCompanionBuilder =
    TasbeehDailyLogsCompanion Function({
      required String dateKey,
      Value<int> tasbeehCount,
      Value<int> wirdCompletedCount,
      Value<bool> allWirdCompleted,
      Value<int> quranAyahsRead,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$TasbeehDailyLogsTableUpdateCompanionBuilder =
    TasbeehDailyLogsCompanion Function({
      Value<String> dateKey,
      Value<int> tasbeehCount,
      Value<int> wirdCompletedCount,
      Value<bool> allWirdCompleted,
      Value<int> quranAyahsRead,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TasbeehDailyLogsTableFilterComposer
    extends Composer<_$AppDatabase, $TasbeehDailyLogsTable> {
  $$TasbeehDailyLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tasbeehCount => $composableBuilder(
    column: $table.tasbeehCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wirdCompletedCount => $composableBuilder(
    column: $table.wirdCompletedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allWirdCompleted => $composableBuilder(
    column: $table.allWirdCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quranAyahsRead => $composableBuilder(
    column: $table.quranAyahsRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasbeehDailyLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $TasbeehDailyLogsTable> {
  $$TasbeehDailyLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tasbeehCount => $composableBuilder(
    column: $table.tasbeehCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wirdCompletedCount => $composableBuilder(
    column: $table.wirdCompletedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allWirdCompleted => $composableBuilder(
    column: $table.allWirdCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quranAyahsRead => $composableBuilder(
    column: $table.quranAyahsRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasbeehDailyLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasbeehDailyLogsTable> {
  $$TasbeehDailyLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<int> get tasbeehCount => $composableBuilder(
    column: $table.tasbeehCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wirdCompletedCount => $composableBuilder(
    column: $table.wirdCompletedCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get allWirdCompleted => $composableBuilder(
    column: $table.allWirdCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quranAyahsRead => $composableBuilder(
    column: $table.quranAyahsRead,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TasbeehDailyLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasbeehDailyLogsTable,
          TasbeehDailyLog,
          $$TasbeehDailyLogsTableFilterComposer,
          $$TasbeehDailyLogsTableOrderingComposer,
          $$TasbeehDailyLogsTableAnnotationComposer,
          $$TasbeehDailyLogsTableCreateCompanionBuilder,
          $$TasbeehDailyLogsTableUpdateCompanionBuilder,
          (
            TasbeehDailyLog,
            BaseReferences<
              _$AppDatabase,
              $TasbeehDailyLogsTable,
              TasbeehDailyLog
            >,
          ),
          TasbeehDailyLog,
          PrefetchHooks Function()
        > {
  $$TasbeehDailyLogsTableTableManager(
    _$AppDatabase db,
    $TasbeehDailyLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasbeehDailyLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasbeehDailyLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasbeehDailyLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> dateKey = const Value.absent(),
                Value<int> tasbeehCount = const Value.absent(),
                Value<int> wirdCompletedCount = const Value.absent(),
                Value<bool> allWirdCompleted = const Value.absent(),
                Value<int> quranAyahsRead = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasbeehDailyLogsCompanion(
                dateKey: dateKey,
                tasbeehCount: tasbeehCount,
                wirdCompletedCount: wirdCompletedCount,
                allWirdCompleted: allWirdCompleted,
                quranAyahsRead: quranAyahsRead,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dateKey,
                Value<int> tasbeehCount = const Value.absent(),
                Value<int> wirdCompletedCount = const Value.absent(),
                Value<bool> allWirdCompleted = const Value.absent(),
                Value<int> quranAyahsRead = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasbeehDailyLogsCompanion.insert(
                dateKey: dateKey,
                tasbeehCount: tasbeehCount,
                wirdCompletedCount: wirdCompletedCount,
                allWirdCompleted: allWirdCompleted,
                quranAyahsRead: quranAyahsRead,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasbeehDailyLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasbeehDailyLogsTable,
      TasbeehDailyLog,
      $$TasbeehDailyLogsTableFilterComposer,
      $$TasbeehDailyLogsTableOrderingComposer,
      $$TasbeehDailyLogsTableAnnotationComposer,
      $$TasbeehDailyLogsTableCreateCompanionBuilder,
      $$TasbeehDailyLogsTableUpdateCompanionBuilder,
      (
        TasbeehDailyLog,
        BaseReferences<_$AppDatabase, $TasbeehDailyLogsTable, TasbeehDailyLog>,
      ),
      TasbeehDailyLog,
      PrefetchHooks Function()
    >;
typedef $$QuranBookmarksTableCreateCompanionBuilder =
    QuranBookmarksCompanion Function({
      Value<int> id,
      required int surahNumber,
      required String surahName,
      required int ayahNumber,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$QuranBookmarksTableUpdateCompanionBuilder =
    QuranBookmarksCompanion Function({
      Value<int> id,
      Value<int> surahNumber,
      Value<String> surahName,
      Value<int> ayahNumber,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

class $$QuranBookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $QuranBookmarksTable> {
  $$QuranBookmarksTableFilterComposer({
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

  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get surahName => $composableBuilder(
    column: $table.surahName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuranBookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $QuranBookmarksTable> {
  $$QuranBookmarksTableOrderingComposer({
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

  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get surahName => $composableBuilder(
    column: $table.surahName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuranBookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuranBookmarksTable> {
  $$QuranBookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get surahName =>
      $composableBuilder(column: $table.surahName, builder: (column) => column);

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$QuranBookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuranBookmarksTable,
          QuranBookmarkRow,
          $$QuranBookmarksTableFilterComposer,
          $$QuranBookmarksTableOrderingComposer,
          $$QuranBookmarksTableAnnotationComposer,
          $$QuranBookmarksTableCreateCompanionBuilder,
          $$QuranBookmarksTableUpdateCompanionBuilder,
          (
            QuranBookmarkRow,
            BaseReferences<
              _$AppDatabase,
              $QuranBookmarksTable,
              QuranBookmarkRow
            >,
          ),
          QuranBookmarkRow,
          PrefetchHooks Function()
        > {
  $$QuranBookmarksTableTableManager(
    _$AppDatabase db,
    $QuranBookmarksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuranBookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuranBookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuranBookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surahNumber = const Value.absent(),
                Value<String> surahName = const Value.absent(),
                Value<int> ayahNumber = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => QuranBookmarksCompanion(
                id: id,
                surahNumber: surahNumber,
                surahName: surahName,
                ayahNumber: ayahNumber,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surahNumber,
                required String surahName,
                required int ayahNumber,
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => QuranBookmarksCompanion.insert(
                id: id,
                surahNumber: surahNumber,
                surahName: surahName,
                ayahNumber: ayahNumber,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuranBookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuranBookmarksTable,
      QuranBookmarkRow,
      $$QuranBookmarksTableFilterComposer,
      $$QuranBookmarksTableOrderingComposer,
      $$QuranBookmarksTableAnnotationComposer,
      $$QuranBookmarksTableCreateCompanionBuilder,
      $$QuranBookmarksTableUpdateCompanionBuilder,
      (
        QuranBookmarkRow,
        BaseReferences<_$AppDatabase, $QuranBookmarksTable, QuranBookmarkRow>,
      ),
      QuranBookmarkRow,
      PrefetchHooks Function()
    >;
typedef $$QuranReadingStatesTableCreateCompanionBuilder =
    QuranReadingStatesCompanion Function({
      Value<int> id,
      Value<int> lastSurah,
      Value<String> lastSurahName,
      Value<int> lastAyah,
      Value<DateTime> lastReadAt,
      Value<int> wirdDailyCount,
      Value<int> wirdCursorAyah,
      Value<String?> wirdCompletedDate,
      Value<bool> wirdCursorCompleted,
      Value<int> wirdLastBatchEnd,
    });
typedef $$QuranReadingStatesTableUpdateCompanionBuilder =
    QuranReadingStatesCompanion Function({
      Value<int> id,
      Value<int> lastSurah,
      Value<String> lastSurahName,
      Value<int> lastAyah,
      Value<DateTime> lastReadAt,
      Value<int> wirdDailyCount,
      Value<int> wirdCursorAyah,
      Value<String?> wirdCompletedDate,
      Value<bool> wirdCursorCompleted,
      Value<int> wirdLastBatchEnd,
    });

class $$QuranReadingStatesTableFilterComposer
    extends Composer<_$AppDatabase, $QuranReadingStatesTable> {
  $$QuranReadingStatesTableFilterComposer({
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

  ColumnFilters<int> get lastSurah => $composableBuilder(
    column: $table.lastSurah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSurahName => $composableBuilder(
    column: $table.lastSurahName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastAyah => $composableBuilder(
    column: $table.lastAyah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wirdDailyCount => $composableBuilder(
    column: $table.wirdDailyCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wirdCursorAyah => $composableBuilder(
    column: $table.wirdCursorAyah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wirdCompletedDate => $composableBuilder(
    column: $table.wirdCompletedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get wirdCursorCompleted => $composableBuilder(
    column: $table.wirdCursorCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wirdLastBatchEnd => $composableBuilder(
    column: $table.wirdLastBatchEnd,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuranReadingStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuranReadingStatesTable> {
  $$QuranReadingStatesTableOrderingComposer({
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

  ColumnOrderings<int> get lastSurah => $composableBuilder(
    column: $table.lastSurah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSurahName => $composableBuilder(
    column: $table.lastSurahName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastAyah => $composableBuilder(
    column: $table.lastAyah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wirdDailyCount => $composableBuilder(
    column: $table.wirdDailyCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wirdCursorAyah => $composableBuilder(
    column: $table.wirdCursorAyah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wirdCompletedDate => $composableBuilder(
    column: $table.wirdCompletedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wirdCursorCompleted => $composableBuilder(
    column: $table.wirdCursorCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wirdLastBatchEnd => $composableBuilder(
    column: $table.wirdLastBatchEnd,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuranReadingStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuranReadingStatesTable> {
  $$QuranReadingStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get lastSurah =>
      $composableBuilder(column: $table.lastSurah, builder: (column) => column);

  GeneratedColumn<String> get lastSurahName => $composableBuilder(
    column: $table.lastSurahName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastAyah =>
      $composableBuilder(column: $table.lastAyah, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wirdDailyCount => $composableBuilder(
    column: $table.wirdDailyCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wirdCursorAyah => $composableBuilder(
    column: $table.wirdCursorAyah,
    builder: (column) => column,
  );

  GeneratedColumn<String> get wirdCompletedDate => $composableBuilder(
    column: $table.wirdCompletedDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get wirdCursorCompleted => $composableBuilder(
    column: $table.wirdCursorCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wirdLastBatchEnd => $composableBuilder(
    column: $table.wirdLastBatchEnd,
    builder: (column) => column,
  );
}

class $$QuranReadingStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuranReadingStatesTable,
          QuranReadingState,
          $$QuranReadingStatesTableFilterComposer,
          $$QuranReadingStatesTableOrderingComposer,
          $$QuranReadingStatesTableAnnotationComposer,
          $$QuranReadingStatesTableCreateCompanionBuilder,
          $$QuranReadingStatesTableUpdateCompanionBuilder,
          (
            QuranReadingState,
            BaseReferences<
              _$AppDatabase,
              $QuranReadingStatesTable,
              QuranReadingState
            >,
          ),
          QuranReadingState,
          PrefetchHooks Function()
        > {
  $$QuranReadingStatesTableTableManager(
    _$AppDatabase db,
    $QuranReadingStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuranReadingStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuranReadingStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuranReadingStatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lastSurah = const Value.absent(),
                Value<String> lastSurahName = const Value.absent(),
                Value<int> lastAyah = const Value.absent(),
                Value<DateTime> lastReadAt = const Value.absent(),
                Value<int> wirdDailyCount = const Value.absent(),
                Value<int> wirdCursorAyah = const Value.absent(),
                Value<String?> wirdCompletedDate = const Value.absent(),
                Value<bool> wirdCursorCompleted = const Value.absent(),
                Value<int> wirdLastBatchEnd = const Value.absent(),
              }) => QuranReadingStatesCompanion(
                id: id,
                lastSurah: lastSurah,
                lastSurahName: lastSurahName,
                lastAyah: lastAyah,
                lastReadAt: lastReadAt,
                wirdDailyCount: wirdDailyCount,
                wirdCursorAyah: wirdCursorAyah,
                wirdCompletedDate: wirdCompletedDate,
                wirdCursorCompleted: wirdCursorCompleted,
                wirdLastBatchEnd: wirdLastBatchEnd,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lastSurah = const Value.absent(),
                Value<String> lastSurahName = const Value.absent(),
                Value<int> lastAyah = const Value.absent(),
                Value<DateTime> lastReadAt = const Value.absent(),
                Value<int> wirdDailyCount = const Value.absent(),
                Value<int> wirdCursorAyah = const Value.absent(),
                Value<String?> wirdCompletedDate = const Value.absent(),
                Value<bool> wirdCursorCompleted = const Value.absent(),
                Value<int> wirdLastBatchEnd = const Value.absent(),
              }) => QuranReadingStatesCompanion.insert(
                id: id,
                lastSurah: lastSurah,
                lastSurahName: lastSurahName,
                lastAyah: lastAyah,
                lastReadAt: lastReadAt,
                wirdDailyCount: wirdDailyCount,
                wirdCursorAyah: wirdCursorAyah,
                wirdCompletedDate: wirdCompletedDate,
                wirdCursorCompleted: wirdCursorCompleted,
                wirdLastBatchEnd: wirdLastBatchEnd,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuranReadingStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuranReadingStatesTable,
      QuranReadingState,
      $$QuranReadingStatesTableFilterComposer,
      $$QuranReadingStatesTableOrderingComposer,
      $$QuranReadingStatesTableAnnotationComposer,
      $$QuranReadingStatesTableCreateCompanionBuilder,
      $$QuranReadingStatesTableUpdateCompanionBuilder,
      (
        QuranReadingState,
        BaseReferences<
          _$AppDatabase,
          $QuranReadingStatesTable,
          QuranReadingState
        >,
      ),
      QuranReadingState,
      PrefetchHooks Function()
    >;
typedef $$AzkarProgressEntriesTableCreateCompanionBuilder =
    AzkarProgressEntriesCompanion Function({
      required String categoryId,
      required String dhikrId,
      required int remainingCount,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AzkarProgressEntriesTableUpdateCompanionBuilder =
    AzkarProgressEntriesCompanion Function({
      Value<String> categoryId,
      Value<String> dhikrId,
      Value<int> remainingCount,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AzkarProgressEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AzkarProgressEntriesTable> {
  $$AzkarProgressEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dhikrId => $composableBuilder(
    column: $table.dhikrId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remainingCount => $composableBuilder(
    column: $table.remainingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AzkarProgressEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AzkarProgressEntriesTable> {
  $$AzkarProgressEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dhikrId => $composableBuilder(
    column: $table.dhikrId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remainingCount => $composableBuilder(
    column: $table.remainingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AzkarProgressEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AzkarProgressEntriesTable> {
  $$AzkarProgressEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dhikrId =>
      $composableBuilder(column: $table.dhikrId, builder: (column) => column);

  GeneratedColumn<int> get remainingCount => $composableBuilder(
    column: $table.remainingCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AzkarProgressEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AzkarProgressEntriesTable,
          AzkarProgressEntry,
          $$AzkarProgressEntriesTableFilterComposer,
          $$AzkarProgressEntriesTableOrderingComposer,
          $$AzkarProgressEntriesTableAnnotationComposer,
          $$AzkarProgressEntriesTableCreateCompanionBuilder,
          $$AzkarProgressEntriesTableUpdateCompanionBuilder,
          (
            AzkarProgressEntry,
            BaseReferences<
              _$AppDatabase,
              $AzkarProgressEntriesTable,
              AzkarProgressEntry
            >,
          ),
          AzkarProgressEntry,
          PrefetchHooks Function()
        > {
  $$AzkarProgressEntriesTableTableManager(
    _$AppDatabase db,
    $AzkarProgressEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AzkarProgressEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AzkarProgressEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AzkarProgressEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> categoryId = const Value.absent(),
                Value<String> dhikrId = const Value.absent(),
                Value<int> remainingCount = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AzkarProgressEntriesCompanion(
                categoryId: categoryId,
                dhikrId: dhikrId,
                remainingCount: remainingCount,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String categoryId,
                required String dhikrId,
                required int remainingCount,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AzkarProgressEntriesCompanion.insert(
                categoryId: categoryId,
                dhikrId: dhikrId,
                remainingCount: remainingCount,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AzkarProgressEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AzkarProgressEntriesTable,
      AzkarProgressEntry,
      $$AzkarProgressEntriesTableFilterComposer,
      $$AzkarProgressEntriesTableOrderingComposer,
      $$AzkarProgressEntriesTableAnnotationComposer,
      $$AzkarProgressEntriesTableCreateCompanionBuilder,
      $$AzkarProgressEntriesTableUpdateCompanionBuilder,
      (
        AzkarProgressEntry,
        BaseReferences<
          _$AppDatabase,
          $AzkarProgressEntriesTable,
          AzkarProgressEntry
        >,
      ),
      AzkarProgressEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TasbeehEntriesTableTableManager get tasbeehEntries =>
      $$TasbeehEntriesTableTableManager(_db, _db.tasbeehEntries);
  $$WirdEntriesTableTableManager get wirdEntries =>
      $$WirdEntriesTableTableManager(_db, _db.wirdEntries);
  $$TasbeehDailyLogsTableTableManager get tasbeehDailyLogs =>
      $$TasbeehDailyLogsTableTableManager(_db, _db.tasbeehDailyLogs);
  $$QuranBookmarksTableTableManager get quranBookmarks =>
      $$QuranBookmarksTableTableManager(_db, _db.quranBookmarks);
  $$QuranReadingStatesTableTableManager get quranReadingStates =>
      $$QuranReadingStatesTableTableManager(_db, _db.quranReadingStates);
  $$AzkarProgressEntriesTableTableManager get azkarProgressEntries =>
      $$AzkarProgressEntriesTableTableManager(_db, _db.azkarProgressEntries);
}
