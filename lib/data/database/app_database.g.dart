// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DecksTable extends Decks with TableInfo<$DecksTable, DeckRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isBuiltInMeta = const VerificationMeta(
    'isBuiltIn',
  );
  @override
  late final GeneratedColumn<bool> isBuiltIn = GeneratedColumn<bool>(
    'is_built_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_built_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    name,
    description,
    level,
    isBuiltIn,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'decks';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeckRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('is_built_in')) {
      context.handle(
        _isBuiltInMeta,
        isBuiltIn.isAcceptableOrUnknown(data['is_built_in']!, _isBuiltInMeta),
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
  DeckRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeckRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      isBuiltIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_built_in'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DecksTable createAlias(String alias) {
    return $DecksTable(attachedDatabase, alias);
  }
}

class DeckRow extends DataClass implements Insertable<DeckRow> {
  final String id;
  final String name;
  final String description;
  final String level;
  final bool isBuiltIn;
  final DateTime createdAt;
  const DeckRow({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.isBuiltIn,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['level'] = Variable<String>(level);
    map['is_built_in'] = Variable<bool>(isBuiltIn);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DecksCompanion toCompanion(bool nullToAbsent) {
    return DecksCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      level: Value(level),
      isBuiltIn: Value(isBuiltIn),
      createdAt: Value(createdAt),
    );
  }

  factory DeckRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeckRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      level: serializer.fromJson<String>(json['level']),
      isBuiltIn: serializer.fromJson<bool>(json['isBuiltIn']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'level': serializer.toJson<String>(level),
      'isBuiltIn': serializer.toJson<bool>(isBuiltIn),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DeckRow copyWith({
    String? id,
    String? name,
    String? description,
    String? level,
    bool? isBuiltIn,
    DateTime? createdAt,
  }) => DeckRow(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    level: level ?? this.level,
    isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    createdAt: createdAt ?? this.createdAt,
  );
  DeckRow copyWithCompanion(DecksCompanion data) {
    return DeckRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      level: data.level.present ? data.level.value : this.level,
      isBuiltIn: data.isBuiltIn.present ? data.isBuiltIn.value : this.isBuiltIn,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeckRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('level: $level, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, level, isBuiltIn, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeckRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.level == this.level &&
          other.isBuiltIn == this.isBuiltIn &&
          other.createdAt == this.createdAt);
}

class DecksCompanion extends UpdateCompanion<DeckRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> level;
  final Value<bool> isBuiltIn;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DecksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.level = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DecksCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String level,
    this.isBuiltIn = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       level = Value(level);
  static Insertable<DeckRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? level,
    Expression<bool>? isBuiltIn,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (level != null) 'level': level,
      if (isBuiltIn != null) 'is_built_in': isBuiltIn,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DecksCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String>? level,
    Value<bool>? isBuiltIn,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DecksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      level: level ?? this.level,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (isBuiltIn.present) {
      map['is_built_in'] = Variable<bool>(isBuiltIn.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DecksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('level: $level, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardsTable extends Cards with TableInfo<$CardsTable, CardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<String> deckId = GeneratedColumn<String>(
    'deck_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES decks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _koreanMeta = const VerificationMeta('korean');
  @override
  late final GeneratedColumn<String> korean = GeneratedColumn<String>(
    'korean',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _romanizationMeta = const VerificationMeta(
    'romanization',
  );
  @override
  late final GeneratedColumn<String> romanization = GeneratedColumn<String>(
    'romanization',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meaningZhMeta = const VerificationMeta(
    'meaningZh',
  );
  @override
  late final GeneratedColumn<String> meaningZh = GeneratedColumn<String>(
    'meaning_zh',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meaningEnMeta = const VerificationMeta(
    'meaningEn',
  );
  @override
  late final GeneratedColumn<String> meaningEn = GeneratedColumn<String>(
    'meaning_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exampleSentenceMeta = const VerificationMeta(
    'exampleSentence',
  );
  @override
  late final GeneratedColumn<String> exampleSentence = GeneratedColumn<String>(
    'example_sentence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _exampleTranslationMeta =
      const VerificationMeta('exampleTranslation');
  @override
  late final GeneratedColumn<String> exampleTranslation =
      GeneratedColumn<String>(
        'example_translation',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
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
    deckId,
    korean,
    romanization,
    meaningZh,
    meaningEn,
    exampleSentence,
    exampleTranslation,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('deck_id')) {
      context.handle(
        _deckIdMeta,
        deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('korean')) {
      context.handle(
        _koreanMeta,
        korean.isAcceptableOrUnknown(data['korean']!, _koreanMeta),
      );
    } else if (isInserting) {
      context.missing(_koreanMeta);
    }
    if (data.containsKey('romanization')) {
      context.handle(
        _romanizationMeta,
        romanization.isAcceptableOrUnknown(
          data['romanization']!,
          _romanizationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_romanizationMeta);
    }
    if (data.containsKey('meaning_zh')) {
      context.handle(
        _meaningZhMeta,
        meaningZh.isAcceptableOrUnknown(data['meaning_zh']!, _meaningZhMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningZhMeta);
    }
    if (data.containsKey('meaning_en')) {
      context.handle(
        _meaningEnMeta,
        meaningEn.isAcceptableOrUnknown(data['meaning_en']!, _meaningEnMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningEnMeta);
    }
    if (data.containsKey('example_sentence')) {
      context.handle(
        _exampleSentenceMeta,
        exampleSentence.isAcceptableOrUnknown(
          data['example_sentence']!,
          _exampleSentenceMeta,
        ),
      );
    }
    if (data.containsKey('example_translation')) {
      context.handle(
        _exampleTranslationMeta,
        exampleTranslation.isAcceptableOrUnknown(
          data['example_translation']!,
          _exampleTranslationMeta,
        ),
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
  CardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deckId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deck_id'],
      )!,
      korean: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}korean'],
      )!,
      romanization: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}romanization'],
      )!,
      meaningZh: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning_zh'],
      )!,
      meaningEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning_en'],
      )!,
      exampleSentence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_sentence'],
      )!,
      exampleTranslation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_translation'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }
}

class CardRow extends DataClass implements Insertable<CardRow> {
  final String id;
  final String deckId;
  final String korean;
  final String romanization;
  final String meaningZh;
  final String meaningEn;
  final String exampleSentence;
  final String exampleTranslation;
  final DateTime createdAt;
  const CardRow({
    required this.id,
    required this.deckId,
    required this.korean,
    required this.romanization,
    required this.meaningZh,
    required this.meaningEn,
    required this.exampleSentence,
    required this.exampleTranslation,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['deck_id'] = Variable<String>(deckId);
    map['korean'] = Variable<String>(korean);
    map['romanization'] = Variable<String>(romanization);
    map['meaning_zh'] = Variable<String>(meaningZh);
    map['meaning_en'] = Variable<String>(meaningEn);
    map['example_sentence'] = Variable<String>(exampleSentence);
    map['example_translation'] = Variable<String>(exampleTranslation);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      deckId: Value(deckId),
      korean: Value(korean),
      romanization: Value(romanization),
      meaningZh: Value(meaningZh),
      meaningEn: Value(meaningEn),
      exampleSentence: Value(exampleSentence),
      exampleTranslation: Value(exampleTranslation),
      createdAt: Value(createdAt),
    );
  }

  factory CardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardRow(
      id: serializer.fromJson<String>(json['id']),
      deckId: serializer.fromJson<String>(json['deckId']),
      korean: serializer.fromJson<String>(json['korean']),
      romanization: serializer.fromJson<String>(json['romanization']),
      meaningZh: serializer.fromJson<String>(json['meaningZh']),
      meaningEn: serializer.fromJson<String>(json['meaningEn']),
      exampleSentence: serializer.fromJson<String>(json['exampleSentence']),
      exampleTranslation: serializer.fromJson<String>(
        json['exampleTranslation'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deckId': serializer.toJson<String>(deckId),
      'korean': serializer.toJson<String>(korean),
      'romanization': serializer.toJson<String>(romanization),
      'meaningZh': serializer.toJson<String>(meaningZh),
      'meaningEn': serializer.toJson<String>(meaningEn),
      'exampleSentence': serializer.toJson<String>(exampleSentence),
      'exampleTranslation': serializer.toJson<String>(exampleTranslation),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CardRow copyWith({
    String? id,
    String? deckId,
    String? korean,
    String? romanization,
    String? meaningZh,
    String? meaningEn,
    String? exampleSentence,
    String? exampleTranslation,
    DateTime? createdAt,
  }) => CardRow(
    id: id ?? this.id,
    deckId: deckId ?? this.deckId,
    korean: korean ?? this.korean,
    romanization: romanization ?? this.romanization,
    meaningZh: meaningZh ?? this.meaningZh,
    meaningEn: meaningEn ?? this.meaningEn,
    exampleSentence: exampleSentence ?? this.exampleSentence,
    exampleTranslation: exampleTranslation ?? this.exampleTranslation,
    createdAt: createdAt ?? this.createdAt,
  );
  CardRow copyWithCompanion(CardsCompanion data) {
    return CardRow(
      id: data.id.present ? data.id.value : this.id,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      korean: data.korean.present ? data.korean.value : this.korean,
      romanization: data.romanization.present
          ? data.romanization.value
          : this.romanization,
      meaningZh: data.meaningZh.present ? data.meaningZh.value : this.meaningZh,
      meaningEn: data.meaningEn.present ? data.meaningEn.value : this.meaningEn,
      exampleSentence: data.exampleSentence.present
          ? data.exampleSentence.value
          : this.exampleSentence,
      exampleTranslation: data.exampleTranslation.present
          ? data.exampleTranslation.value
          : this.exampleTranslation,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardRow(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('korean: $korean, ')
          ..write('romanization: $romanization, ')
          ..write('meaningZh: $meaningZh, ')
          ..write('meaningEn: $meaningEn, ')
          ..write('exampleSentence: $exampleSentence, ')
          ..write('exampleTranslation: $exampleTranslation, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deckId,
    korean,
    romanization,
    meaningZh,
    meaningEn,
    exampleSentence,
    exampleTranslation,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardRow &&
          other.id == this.id &&
          other.deckId == this.deckId &&
          other.korean == this.korean &&
          other.romanization == this.romanization &&
          other.meaningZh == this.meaningZh &&
          other.meaningEn == this.meaningEn &&
          other.exampleSentence == this.exampleSentence &&
          other.exampleTranslation == this.exampleTranslation &&
          other.createdAt == this.createdAt);
}

class CardsCompanion extends UpdateCompanion<CardRow> {
  final Value<String> id;
  final Value<String> deckId;
  final Value<String> korean;
  final Value<String> romanization;
  final Value<String> meaningZh;
  final Value<String> meaningEn;
  final Value<String> exampleSentence;
  final Value<String> exampleTranslation;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.deckId = const Value.absent(),
    this.korean = const Value.absent(),
    this.romanization = const Value.absent(),
    this.meaningZh = const Value.absent(),
    this.meaningEn = const Value.absent(),
    this.exampleSentence = const Value.absent(),
    this.exampleTranslation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardsCompanion.insert({
    required String id,
    required String deckId,
    required String korean,
    required String romanization,
    required String meaningZh,
    required String meaningEn,
    this.exampleSentence = const Value.absent(),
    this.exampleTranslation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       deckId = Value(deckId),
       korean = Value(korean),
       romanization = Value(romanization),
       meaningZh = Value(meaningZh),
       meaningEn = Value(meaningEn);
  static Insertable<CardRow> custom({
    Expression<String>? id,
    Expression<String>? deckId,
    Expression<String>? korean,
    Expression<String>? romanization,
    Expression<String>? meaningZh,
    Expression<String>? meaningEn,
    Expression<String>? exampleSentence,
    Expression<String>? exampleTranslation,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckId != null) 'deck_id': deckId,
      if (korean != null) 'korean': korean,
      if (romanization != null) 'romanization': romanization,
      if (meaningZh != null) 'meaning_zh': meaningZh,
      if (meaningEn != null) 'meaning_en': meaningEn,
      if (exampleSentence != null) 'example_sentence': exampleSentence,
      if (exampleTranslation != null) 'example_translation': exampleTranslation,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardsCompanion copyWith({
    Value<String>? id,
    Value<String>? deckId,
    Value<String>? korean,
    Value<String>? romanization,
    Value<String>? meaningZh,
    Value<String>? meaningEn,
    Value<String>? exampleSentence,
    Value<String>? exampleTranslation,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CardsCompanion(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      korean: korean ?? this.korean,
      romanization: romanization ?? this.romanization,
      meaningZh: meaningZh ?? this.meaningZh,
      meaningEn: meaningEn ?? this.meaningEn,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      exampleTranslation: exampleTranslation ?? this.exampleTranslation,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deckId.present) {
      map['deck_id'] = Variable<String>(deckId.value);
    }
    if (korean.present) {
      map['korean'] = Variable<String>(korean.value);
    }
    if (romanization.present) {
      map['romanization'] = Variable<String>(romanization.value);
    }
    if (meaningZh.present) {
      map['meaning_zh'] = Variable<String>(meaningZh.value);
    }
    if (meaningEn.present) {
      map['meaning_en'] = Variable<String>(meaningEn.value);
    }
    if (exampleSentence.present) {
      map['example_sentence'] = Variable<String>(exampleSentence.value);
    }
    if (exampleTranslation.present) {
      map['example_translation'] = Variable<String>(exampleTranslation.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('korean: $korean, ')
          ..write('romanization: $romanization, ')
          ..write('meaningZh: $meaningZh, ')
          ..write('meaningEn: $meaningEn, ')
          ..write('exampleSentence: $exampleSentence, ')
          ..write('exampleTranslation: $exampleTranslation, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewRecordsTable extends ReviewRecords
    with TableInfo<$ReviewRecordsTable, ReviewRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cards (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _easeFactorMeta = const VerificationMeta(
    'easeFactor',
  );
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
    'ease_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _intervalMeta = const VerificationMeta(
    'interval',
  );
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
    'interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextReviewAtMeta = const VerificationMeta(
    'nextReviewAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextReviewAt = GeneratedColumn<DateTime>(
    'next_review_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastReviewedAtMeta = const VerificationMeta(
    'lastReviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>(
        'last_reviewed_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    cardId,
    easeFactor,
    interval,
    repetitions,
    nextReviewAt,
    lastReviewedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewRecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
        _easeFactorMeta,
        easeFactor.isAcceptableOrUnknown(data['ease_factor']!, _easeFactorMeta),
      );
    }
    if (data.containsKey('interval')) {
      context.handle(
        _intervalMeta,
        interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('next_review_at')) {
      context.handle(
        _nextReviewAtMeta,
        nextReviewAt.isAcceptableOrUnknown(
          data['next_review_at']!,
          _nextReviewAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextReviewAtMeta);
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
        _lastReviewedAtMeta,
        lastReviewedAt.isAcceptableOrUnknown(
          data['last_reviewed_at']!,
          _lastReviewedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastReviewedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardId};
  @override
  ReviewRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewRecordRow(
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      easeFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ease_factor'],
      )!,
      interval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval'],
      )!,
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      nextReviewAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_review_at'],
      )!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reviewed_at'],
      )!,
    );
  }

  @override
  $ReviewRecordsTable createAlias(String alias) {
    return $ReviewRecordsTable(attachedDatabase, alias);
  }
}

class ReviewRecordRow extends DataClass implements Insertable<ReviewRecordRow> {
  final String cardId;
  final double easeFactor;
  final int interval;
  final int repetitions;
  final DateTime nextReviewAt;
  final DateTime lastReviewedAt;
  const ReviewRecordRow({
    required this.cardId,
    required this.easeFactor,
    required this.interval,
    required this.repetitions,
    required this.nextReviewAt,
    required this.lastReviewedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['card_id'] = Variable<String>(cardId);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['interval'] = Variable<int>(interval);
    map['repetitions'] = Variable<int>(repetitions);
    map['next_review_at'] = Variable<DateTime>(nextReviewAt);
    map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    return map;
  }

  ReviewRecordsCompanion toCompanion(bool nullToAbsent) {
    return ReviewRecordsCompanion(
      cardId: Value(cardId),
      easeFactor: Value(easeFactor),
      interval: Value(interval),
      repetitions: Value(repetitions),
      nextReviewAt: Value(nextReviewAt),
      lastReviewedAt: Value(lastReviewedAt),
    );
  }

  factory ReviewRecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewRecordRow(
      cardId: serializer.fromJson<String>(json['cardId']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      interval: serializer.fromJson<int>(json['interval']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      nextReviewAt: serializer.fromJson<DateTime>(json['nextReviewAt']),
      lastReviewedAt: serializer.fromJson<DateTime>(json['lastReviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardId': serializer.toJson<String>(cardId),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'interval': serializer.toJson<int>(interval),
      'repetitions': serializer.toJson<int>(repetitions),
      'nextReviewAt': serializer.toJson<DateTime>(nextReviewAt),
      'lastReviewedAt': serializer.toJson<DateTime>(lastReviewedAt),
    };
  }

  ReviewRecordRow copyWith({
    String? cardId,
    double? easeFactor,
    int? interval,
    int? repetitions,
    DateTime? nextReviewAt,
    DateTime? lastReviewedAt,
  }) => ReviewRecordRow(
    cardId: cardId ?? this.cardId,
    easeFactor: easeFactor ?? this.easeFactor,
    interval: interval ?? this.interval,
    repetitions: repetitions ?? this.repetitions,
    nextReviewAt: nextReviewAt ?? this.nextReviewAt,
    lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
  );
  ReviewRecordRow copyWithCompanion(ReviewRecordsCompanion data) {
    return ReviewRecordRow(
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      easeFactor: data.easeFactor.present
          ? data.easeFactor.value
          : this.easeFactor,
      interval: data.interval.present ? data.interval.value : this.interval,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      nextReviewAt: data.nextReviewAt.present
          ? data.nextReviewAt.value
          : this.nextReviewAt,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewRecordRow(')
          ..write('cardId: $cardId, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('interval: $interval, ')
          ..write('repetitions: $repetitions, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    cardId,
    easeFactor,
    interval,
    repetitions,
    nextReviewAt,
    lastReviewedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewRecordRow &&
          other.cardId == this.cardId &&
          other.easeFactor == this.easeFactor &&
          other.interval == this.interval &&
          other.repetitions == this.repetitions &&
          other.nextReviewAt == this.nextReviewAt &&
          other.lastReviewedAt == this.lastReviewedAt);
}

class ReviewRecordsCompanion extends UpdateCompanion<ReviewRecordRow> {
  final Value<String> cardId;
  final Value<double> easeFactor;
  final Value<int> interval;
  final Value<int> repetitions;
  final Value<DateTime> nextReviewAt;
  final Value<DateTime> lastReviewedAt;
  final Value<int> rowid;
  const ReviewRecordsCompanion({
    this.cardId = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.interval = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReviewRecordsCompanion.insert({
    required String cardId,
    this.easeFactor = const Value.absent(),
    this.interval = const Value.absent(),
    this.repetitions = const Value.absent(),
    required DateTime nextReviewAt,
    required DateTime lastReviewedAt,
    this.rowid = const Value.absent(),
  }) : cardId = Value(cardId),
       nextReviewAt = Value(nextReviewAt),
       lastReviewedAt = Value(lastReviewedAt);
  static Insertable<ReviewRecordRow> custom({
    Expression<String>? cardId,
    Expression<double>? easeFactor,
    Expression<int>? interval,
    Expression<int>? repetitions,
    Expression<DateTime>? nextReviewAt,
    Expression<DateTime>? lastReviewedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cardId != null) 'card_id': cardId,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (interval != null) 'interval': interval,
      if (repetitions != null) 'repetitions': repetitions,
      if (nextReviewAt != null) 'next_review_at': nextReviewAt,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReviewRecordsCompanion copyWith({
    Value<String>? cardId,
    Value<double>? easeFactor,
    Value<int>? interval,
    Value<int>? repetitions,
    Value<DateTime>? nextReviewAt,
    Value<DateTime>? lastReviewedAt,
    Value<int>? rowid,
  }) {
    return ReviewRecordsCompanion(
      cardId: cardId ?? this.cardId,
      easeFactor: easeFactor ?? this.easeFactor,
      interval: interval ?? this.interval,
      repetitions: repetitions ?? this.repetitions,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (nextReviewAt.present) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewRecordsCompanion(')
          ..write('cardId: $cardId, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('interval: $interval, ')
          ..write('repetitions: $repetitions, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTableTable extends AchievementsTable
    with TableInfo<$AchievementsTableTable, AchievementsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleKeyMeta = const VerificationMeta(
    'titleKey',
  );
  @override
  late final GeneratedColumn<String> titleKey = GeneratedColumn<String>(
    'title_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descKeyMeta = const VerificationMeta(
    'descKey',
  );
  @override
  late final GeneratedColumn<String> descKey = GeneratedColumn<String>(
    'desc_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conditionMeta = const VerificationMeta(
    'condition',
  );
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thresholdMeta = const VerificationMeta(
    'threshold',
  );
  @override
  late final GeneratedColumn<int> threshold = GeneratedColumn<int>(
    'threshold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockedMeta = const VerificationMeta(
    'unlocked',
  );
  @override
  late final GeneratedColumn<bool> unlocked = GeneratedColumn<bool>(
    'unlocked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("unlocked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
    'unlocked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    titleKey,
    descKey,
    iconName,
    condition,
    threshold,
    unlocked,
    unlockedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(
    Insertable<AchievementsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title_key')) {
      context.handle(
        _titleKeyMeta,
        titleKey.isAcceptableOrUnknown(data['title_key']!, _titleKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_titleKeyMeta);
    }
    if (data.containsKey('desc_key')) {
      context.handle(
        _descKeyMeta,
        descKey.isAcceptableOrUnknown(data['desc_key']!, _descKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_descKeyMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    } else if (isInserting) {
      context.missing(_iconNameMeta);
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    } else if (isInserting) {
      context.missing(_conditionMeta);
    }
    if (data.containsKey('threshold')) {
      context.handle(
        _thresholdMeta,
        threshold.isAcceptableOrUnknown(data['threshold']!, _thresholdMeta),
      );
    } else if (isInserting) {
      context.missing(_thresholdMeta);
    }
    if (data.containsKey('unlocked')) {
      context.handle(
        _unlockedMeta,
        unlocked.isAcceptableOrUnknown(data['unlocked']!, _unlockedMeta),
      );
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AchievementsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AchievementsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      titleKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_key'],
      )!,
      descKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}desc_key'],
      )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      )!,
      condition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition'],
      )!,
      threshold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}threshold'],
      )!,
      unlocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}unlocked'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
      ),
    );
  }

  @override
  $AchievementsTableTable createAlias(String alias) {
    return $AchievementsTableTable(attachedDatabase, alias);
  }
}

class AchievementsTableData extends DataClass
    implements Insertable<AchievementsTableData> {
  final String id;
  final String titleKey;
  final String descKey;
  final String iconName;
  final String condition;
  final int threshold;
  final bool unlocked;
  final DateTime? unlockedAt;
  const AchievementsTableData({
    required this.id,
    required this.titleKey,
    required this.descKey,
    required this.iconName,
    required this.condition,
    required this.threshold,
    required this.unlocked,
    this.unlockedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title_key'] = Variable<String>(titleKey);
    map['desc_key'] = Variable<String>(descKey);
    map['icon_name'] = Variable<String>(iconName);
    map['condition'] = Variable<String>(condition);
    map['threshold'] = Variable<int>(threshold);
    map['unlocked'] = Variable<bool>(unlocked);
    if (!nullToAbsent || unlockedAt != null) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    }
    return map;
  }

  AchievementsTableCompanion toCompanion(bool nullToAbsent) {
    return AchievementsTableCompanion(
      id: Value(id),
      titleKey: Value(titleKey),
      descKey: Value(descKey),
      iconName: Value(iconName),
      condition: Value(condition),
      threshold: Value(threshold),
      unlocked: Value(unlocked),
      unlockedAt: unlockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockedAt),
    );
  }

  factory AchievementsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AchievementsTableData(
      id: serializer.fromJson<String>(json['id']),
      titleKey: serializer.fromJson<String>(json['titleKey']),
      descKey: serializer.fromJson<String>(json['descKey']),
      iconName: serializer.fromJson<String>(json['iconName']),
      condition: serializer.fromJson<String>(json['condition']),
      threshold: serializer.fromJson<int>(json['threshold']),
      unlocked: serializer.fromJson<bool>(json['unlocked']),
      unlockedAt: serializer.fromJson<DateTime?>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'titleKey': serializer.toJson<String>(titleKey),
      'descKey': serializer.toJson<String>(descKey),
      'iconName': serializer.toJson<String>(iconName),
      'condition': serializer.toJson<String>(condition),
      'threshold': serializer.toJson<int>(threshold),
      'unlocked': serializer.toJson<bool>(unlocked),
      'unlockedAt': serializer.toJson<DateTime?>(unlockedAt),
    };
  }

  AchievementsTableData copyWith({
    String? id,
    String? titleKey,
    String? descKey,
    String? iconName,
    String? condition,
    int? threshold,
    bool? unlocked,
    Value<DateTime?> unlockedAt = const Value.absent(),
  }) => AchievementsTableData(
    id: id ?? this.id,
    titleKey: titleKey ?? this.titleKey,
    descKey: descKey ?? this.descKey,
    iconName: iconName ?? this.iconName,
    condition: condition ?? this.condition,
    threshold: threshold ?? this.threshold,
    unlocked: unlocked ?? this.unlocked,
    unlockedAt: unlockedAt.present ? unlockedAt.value : this.unlockedAt,
  );
  AchievementsTableData copyWithCompanion(AchievementsTableCompanion data) {
    return AchievementsTableData(
      id: data.id.present ? data.id.value : this.id,
      titleKey: data.titleKey.present ? data.titleKey.value : this.titleKey,
      descKey: data.descKey.present ? data.descKey.value : this.descKey,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      condition: data.condition.present ? data.condition.value : this.condition,
      threshold: data.threshold.present ? data.threshold.value : this.threshold,
      unlocked: data.unlocked.present ? data.unlocked.value : this.unlocked,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsTableData(')
          ..write('id: $id, ')
          ..write('titleKey: $titleKey, ')
          ..write('descKey: $descKey, ')
          ..write('iconName: $iconName, ')
          ..write('condition: $condition, ')
          ..write('threshold: $threshold, ')
          ..write('unlocked: $unlocked, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    titleKey,
    descKey,
    iconName,
    condition,
    threshold,
    unlocked,
    unlockedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AchievementsTableData &&
          other.id == this.id &&
          other.titleKey == this.titleKey &&
          other.descKey == this.descKey &&
          other.iconName == this.iconName &&
          other.condition == this.condition &&
          other.threshold == this.threshold &&
          other.unlocked == this.unlocked &&
          other.unlockedAt == this.unlockedAt);
}

class AchievementsTableCompanion
    extends UpdateCompanion<AchievementsTableData> {
  final Value<String> id;
  final Value<String> titleKey;
  final Value<String> descKey;
  final Value<String> iconName;
  final Value<String> condition;
  final Value<int> threshold;
  final Value<bool> unlocked;
  final Value<DateTime?> unlockedAt;
  final Value<int> rowid;
  const AchievementsTableCompanion({
    this.id = const Value.absent(),
    this.titleKey = const Value.absent(),
    this.descKey = const Value.absent(),
    this.iconName = const Value.absent(),
    this.condition = const Value.absent(),
    this.threshold = const Value.absent(),
    this.unlocked = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementsTableCompanion.insert({
    required String id,
    required String titleKey,
    required String descKey,
    required String iconName,
    required String condition,
    required int threshold,
    this.unlocked = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       titleKey = Value(titleKey),
       descKey = Value(descKey),
       iconName = Value(iconName),
       condition = Value(condition),
       threshold = Value(threshold);
  static Insertable<AchievementsTableData> custom({
    Expression<String>? id,
    Expression<String>? titleKey,
    Expression<String>? descKey,
    Expression<String>? iconName,
    Expression<String>? condition,
    Expression<int>? threshold,
    Expression<bool>? unlocked,
    Expression<DateTime>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titleKey != null) 'title_key': titleKey,
      if (descKey != null) 'desc_key': descKey,
      if (iconName != null) 'icon_name': iconName,
      if (condition != null) 'condition': condition,
      if (threshold != null) 'threshold': threshold,
      if (unlocked != null) 'unlocked': unlocked,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? titleKey,
    Value<String>? descKey,
    Value<String>? iconName,
    Value<String>? condition,
    Value<int>? threshold,
    Value<bool>? unlocked,
    Value<DateTime?>? unlockedAt,
    Value<int>? rowid,
  }) {
    return AchievementsTableCompanion(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      descKey: descKey ?? this.descKey,
      iconName: iconName ?? this.iconName,
      condition: condition ?? this.condition,
      threshold: threshold ?? this.threshold,
      unlocked: unlocked ?? this.unlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (titleKey.present) {
      map['title_key'] = Variable<String>(titleKey.value);
    }
    if (descKey.present) {
      map['desc_key'] = Variable<String>(descKey.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (threshold.present) {
      map['threshold'] = Variable<int>(threshold.value);
    }
    if (unlocked.present) {
      map['unlocked'] = Variable<bool>(unlocked.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsTableCompanion(')
          ..write('id: $id, ')
          ..write('titleKey: $titleKey, ')
          ..write('descKey: $descKey, ')
          ..write('iconName: $iconName, ')
          ..write('condition: $condition, ')
          ..write('threshold: $threshold, ')
          ..write('unlocked: $unlocked, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserStatsTableTable extends UserStatsTable
    with TableInfo<$UserStatsTableTable, UserStatsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserStatsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _currentStreakMeta = const VerificationMeta(
    'currentStreak',
  );
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
    'current_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _longestStreakMeta = const VerificationMeta(
    'longestStreak',
  );
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
    'longest_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalCardsReviewedMeta =
      const VerificationMeta('totalCardsReviewed');
  @override
  late final GeneratedColumn<int> totalCardsReviewed = GeneratedColumn<int>(
    'total_cards_reviewed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalCorrectMeta = const VerificationMeta(
    'totalCorrect',
  );
  @override
  late final GeneratedColumn<int> totalCorrect = GeneratedColumn<int>(
    'total_correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastStudiedAtMeta = const VerificationMeta(
    'lastStudiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastStudiedAt =
      GeneratedColumn<DateTime>(
        'last_studied_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    currentStreak,
    longestStreak,
    totalCardsReviewed,
    totalCorrect,
    lastStudiedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserStatsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current_streak')) {
      context.handle(
        _currentStreakMeta,
        currentStreak.isAcceptableOrUnknown(
          data['current_streak']!,
          _currentStreakMeta,
        ),
      );
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
        _longestStreakMeta,
        longestStreak.isAcceptableOrUnknown(
          data['longest_streak']!,
          _longestStreakMeta,
        ),
      );
    }
    if (data.containsKey('total_cards_reviewed')) {
      context.handle(
        _totalCardsReviewedMeta,
        totalCardsReviewed.isAcceptableOrUnknown(
          data['total_cards_reviewed']!,
          _totalCardsReviewedMeta,
        ),
      );
    }
    if (data.containsKey('total_correct')) {
      context.handle(
        _totalCorrectMeta,
        totalCorrect.isAcceptableOrUnknown(
          data['total_correct']!,
          _totalCorrectMeta,
        ),
      );
    }
    if (data.containsKey('last_studied_at')) {
      context.handle(
        _lastStudiedAtMeta,
        lastStudiedAt.isAcceptableOrUnknown(
          data['last_studied_at']!,
          _lastStudiedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserStatsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserStatsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      currentStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak'],
      )!,
      longestStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}longest_streak'],
      )!,
      totalCardsReviewed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_cards_reviewed'],
      )!,
      totalCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_correct'],
      )!,
      lastStudiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_studied_at'],
      ),
    );
  }

  @override
  $UserStatsTableTable createAlias(String alias) {
    return $UserStatsTableTable(attachedDatabase, alias);
  }
}

class UserStatsTableData extends DataClass
    implements Insertable<UserStatsTableData> {
  final int id;
  final int currentStreak;
  final int longestStreak;
  final int totalCardsReviewed;
  final int totalCorrect;
  final DateTime? lastStudiedAt;
  const UserStatsTableData({
    required this.id,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalCardsReviewed,
    required this.totalCorrect,
    this.lastStudiedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['current_streak'] = Variable<int>(currentStreak);
    map['longest_streak'] = Variable<int>(longestStreak);
    map['total_cards_reviewed'] = Variable<int>(totalCardsReviewed);
    map['total_correct'] = Variable<int>(totalCorrect);
    if (!nullToAbsent || lastStudiedAt != null) {
      map['last_studied_at'] = Variable<DateTime>(lastStudiedAt);
    }
    return map;
  }

  UserStatsTableCompanion toCompanion(bool nullToAbsent) {
    return UserStatsTableCompanion(
      id: Value(id),
      currentStreak: Value(currentStreak),
      longestStreak: Value(longestStreak),
      totalCardsReviewed: Value(totalCardsReviewed),
      totalCorrect: Value(totalCorrect),
      lastStudiedAt: lastStudiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastStudiedAt),
    );
  }

  factory UserStatsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserStatsTableData(
      id: serializer.fromJson<int>(json['id']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      totalCardsReviewed: serializer.fromJson<int>(json['totalCardsReviewed']),
      totalCorrect: serializer.fromJson<int>(json['totalCorrect']),
      lastStudiedAt: serializer.fromJson<DateTime?>(json['lastStudiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'totalCardsReviewed': serializer.toJson<int>(totalCardsReviewed),
      'totalCorrect': serializer.toJson<int>(totalCorrect),
      'lastStudiedAt': serializer.toJson<DateTime?>(lastStudiedAt),
    };
  }

  UserStatsTableData copyWith({
    int? id,
    int? currentStreak,
    int? longestStreak,
    int? totalCardsReviewed,
    int? totalCorrect,
    Value<DateTime?> lastStudiedAt = const Value.absent(),
  }) => UserStatsTableData(
    id: id ?? this.id,
    currentStreak: currentStreak ?? this.currentStreak,
    longestStreak: longestStreak ?? this.longestStreak,
    totalCardsReviewed: totalCardsReviewed ?? this.totalCardsReviewed,
    totalCorrect: totalCorrect ?? this.totalCorrect,
    lastStudiedAt: lastStudiedAt.present
        ? lastStudiedAt.value
        : this.lastStudiedAt,
  );
  UserStatsTableData copyWithCompanion(UserStatsTableCompanion data) {
    return UserStatsTableData(
      id: data.id.present ? data.id.value : this.id,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      longestStreak: data.longestStreak.present
          ? data.longestStreak.value
          : this.longestStreak,
      totalCardsReviewed: data.totalCardsReviewed.present
          ? data.totalCardsReviewed.value
          : this.totalCardsReviewed,
      totalCorrect: data.totalCorrect.present
          ? data.totalCorrect.value
          : this.totalCorrect,
      lastStudiedAt: data.lastStudiedAt.present
          ? data.lastStudiedAt.value
          : this.lastStudiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserStatsTableData(')
          ..write('id: $id, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('totalCardsReviewed: $totalCardsReviewed, ')
          ..write('totalCorrect: $totalCorrect, ')
          ..write('lastStudiedAt: $lastStudiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    currentStreak,
    longestStreak,
    totalCardsReviewed,
    totalCorrect,
    lastStudiedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserStatsTableData &&
          other.id == this.id &&
          other.currentStreak == this.currentStreak &&
          other.longestStreak == this.longestStreak &&
          other.totalCardsReviewed == this.totalCardsReviewed &&
          other.totalCorrect == this.totalCorrect &&
          other.lastStudiedAt == this.lastStudiedAt);
}

class UserStatsTableCompanion extends UpdateCompanion<UserStatsTableData> {
  final Value<int> id;
  final Value<int> currentStreak;
  final Value<int> longestStreak;
  final Value<int> totalCardsReviewed;
  final Value<int> totalCorrect;
  final Value<DateTime?> lastStudiedAt;
  const UserStatsTableCompanion({
    this.id = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.totalCardsReviewed = const Value.absent(),
    this.totalCorrect = const Value.absent(),
    this.lastStudiedAt = const Value.absent(),
  });
  UserStatsTableCompanion.insert({
    this.id = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.totalCardsReviewed = const Value.absent(),
    this.totalCorrect = const Value.absent(),
    this.lastStudiedAt = const Value.absent(),
  });
  static Insertable<UserStatsTableData> custom({
    Expression<int>? id,
    Expression<int>? currentStreak,
    Expression<int>? longestStreak,
    Expression<int>? totalCardsReviewed,
    Expression<int>? totalCorrect,
    Expression<DateTime>? lastStudiedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (totalCardsReviewed != null)
        'total_cards_reviewed': totalCardsReviewed,
      if (totalCorrect != null) 'total_correct': totalCorrect,
      if (lastStudiedAt != null) 'last_studied_at': lastStudiedAt,
    });
  }

  UserStatsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? currentStreak,
    Value<int>? longestStreak,
    Value<int>? totalCardsReviewed,
    Value<int>? totalCorrect,
    Value<DateTime?>? lastStudiedAt,
  }) {
    return UserStatsTableCompanion(
      id: id ?? this.id,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalCardsReviewed: totalCardsReviewed ?? this.totalCardsReviewed,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      lastStudiedAt: lastStudiedAt ?? this.lastStudiedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (totalCardsReviewed.present) {
      map['total_cards_reviewed'] = Variable<int>(totalCardsReviewed.value);
    }
    if (totalCorrect.present) {
      map['total_correct'] = Variable<int>(totalCorrect.value);
    }
    if (lastStudiedAt.present) {
      map['last_studied_at'] = Variable<DateTime>(lastStudiedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserStatsTableCompanion(')
          ..write('id: $id, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('totalCardsReviewed: $totalCardsReviewed, ')
          ..write('totalCorrect: $totalCorrect, ')
          ..write('lastStudiedAt: $lastStudiedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyReviewCountsTable extends DailyReviewCounts
    with TableInfo<$DailyReviewCountsTable, DailyReviewCount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyReviewCountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [date, count];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_review_counts';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyReviewCount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DailyReviewCount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyReviewCount(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
    );
  }

  @override
  $DailyReviewCountsTable createAlias(String alias) {
    return $DailyReviewCountsTable(attachedDatabase, alias);
  }
}

class DailyReviewCount extends DataClass
    implements Insertable<DailyReviewCount> {
  final DateTime date;
  final int count;
  const DailyReviewCount({required this.date, required this.count});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<DateTime>(date);
    map['count'] = Variable<int>(count);
    return map;
  }

  DailyReviewCountsCompanion toCompanion(bool nullToAbsent) {
    return DailyReviewCountsCompanion(date: Value(date), count: Value(count));
  }

  factory DailyReviewCount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyReviewCount(
      date: serializer.fromJson<DateTime>(json['date']),
      count: serializer.fromJson<int>(json['count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
      'count': serializer.toJson<int>(count),
    };
  }

  DailyReviewCount copyWith({DateTime? date, int? count}) =>
      DailyReviewCount(date: date ?? this.date, count: count ?? this.count);
  DailyReviewCount copyWithCompanion(DailyReviewCountsCompanion data) {
    return DailyReviewCount(
      date: data.date.present ? data.date.value : this.date,
      count: data.count.present ? data.count.value : this.count,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyReviewCount(')
          ..write('date: $date, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, count);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyReviewCount &&
          other.date == this.date &&
          other.count == this.count);
}

class DailyReviewCountsCompanion extends UpdateCompanion<DailyReviewCount> {
  final Value<DateTime> date;
  final Value<int> count;
  final Value<int> rowid;
  const DailyReviewCountsCompanion({
    this.date = const Value.absent(),
    this.count = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyReviewCountsCompanion.insert({
    required DateTime date,
    this.count = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyReviewCount> custom({
    Expression<DateTime>? date,
    Expression<int>? count,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (count != null) 'count': count,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyReviewCountsCompanion copyWith({
    Value<DateTime>? date,
    Value<int>? count,
    Value<int>? rowid,
  }) {
    return DailyReviewCountsCompanion(
      date: date ?? this.date,
      count: count ?? this.count,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyReviewCountsCompanion(')
          ..write('date: $date, ')
          ..write('count: $count, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DecksTable decks = $DecksTable(this);
  late final $CardsTable cards = $CardsTable(this);
  late final $ReviewRecordsTable reviewRecords = $ReviewRecordsTable(this);
  late final $AchievementsTableTable achievementsTable =
      $AchievementsTableTable(this);
  late final $UserStatsTableTable userStatsTable = $UserStatsTableTable(this);
  late final $DailyReviewCountsTable dailyReviewCounts =
      $DailyReviewCountsTable(this);
  late final DeckDao deckDao = DeckDao(this as AppDatabase);
  late final CardDao cardDao = CardDao(this as AppDatabase);
  late final ReviewDao reviewDao = ReviewDao(this as AppDatabase);
  late final StatsDao statsDao = StatsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    decks,
    cards,
    reviewRecords,
    achievementsTable,
    userStatsTable,
    dailyReviewCounts,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'decks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cards', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('review_records', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$DecksTableCreateCompanionBuilder =
    DecksCompanion Function({
      required String id,
      required String name,
      Value<String> description,
      required String level,
      Value<bool> isBuiltIn,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$DecksTableUpdateCompanionBuilder =
    DecksCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> description,
      Value<String> level,
      Value<bool> isBuiltIn,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$DecksTableReferences
    extends BaseReferences<_$AppDatabase, $DecksTable, DeckRow> {
  $$DecksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CardsTable, List<CardRow>> _cardsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cards,
    aliasName: $_aliasNameGenerator(db.decks.id, db.cards.deckId),
  );

  $$CardsTableProcessedTableManager get cardsRefs {
    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.deckId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DecksTableFilterComposer extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cardsRefs(
    Expression<bool> Function($$CardsTableFilterComposer f) f,
  ) {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.deckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DecksTableOrderingComposer
    extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DecksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltIn =>
      $composableBuilder(column: $table.isBuiltIn, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> cardsRefs<T extends Object>(
    Expression<T> Function($$CardsTableAnnotationComposer a) f,
  ) {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.deckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DecksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DecksTable,
          DeckRow,
          $$DecksTableFilterComposer,
          $$DecksTableOrderingComposer,
          $$DecksTableAnnotationComposer,
          $$DecksTableCreateCompanionBuilder,
          $$DecksTableUpdateCompanionBuilder,
          (DeckRow, $$DecksTableReferences),
          DeckRow,
          PrefetchHooks Function({bool cardsRefs})
        > {
  $$DecksTableTableManager(_$AppDatabase db, $DecksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DecksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DecksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DecksCompanion(
                id: id,
                name: name,
                description: description,
                level: level,
                isBuiltIn: isBuiltIn,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> description = const Value.absent(),
                required String level,
                Value<bool> isBuiltIn = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DecksCompanion.insert(
                id: id,
                name: name,
                description: description,
                level: level,
                isBuiltIn: isBuiltIn,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$DecksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({cardsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (cardsRefs) db.cards],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cardsRefs)
                    await $_getPrefetchedData<DeckRow, $DecksTable, CardRow>(
                      currentTable: table,
                      referencedTable: $$DecksTableReferences._cardsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$DecksTableReferences(db, table, p0).cardsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.deckId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DecksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DecksTable,
      DeckRow,
      $$DecksTableFilterComposer,
      $$DecksTableOrderingComposer,
      $$DecksTableAnnotationComposer,
      $$DecksTableCreateCompanionBuilder,
      $$DecksTableUpdateCompanionBuilder,
      (DeckRow, $$DecksTableReferences),
      DeckRow,
      PrefetchHooks Function({bool cardsRefs})
    >;
typedef $$CardsTableCreateCompanionBuilder =
    CardsCompanion Function({
      required String id,
      required String deckId,
      required String korean,
      required String romanization,
      required String meaningZh,
      required String meaningEn,
      Value<String> exampleSentence,
      Value<String> exampleTranslation,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$CardsTableUpdateCompanionBuilder =
    CardsCompanion Function({
      Value<String> id,
      Value<String> deckId,
      Value<String> korean,
      Value<String> romanization,
      Value<String> meaningZh,
      Value<String> meaningEn,
      Value<String> exampleSentence,
      Value<String> exampleTranslation,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$CardsTableReferences
    extends BaseReferences<_$AppDatabase, $CardsTable, CardRow> {
  $$CardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DecksTable _deckIdTable(_$AppDatabase db) =>
      db.decks.createAlias($_aliasNameGenerator(db.cards.deckId, db.decks.id));

  $$DecksTableProcessedTableManager get deckId {
    final $_column = $_itemColumn<String>('deck_id')!;

    final manager = $$DecksTableTableManager(
      $_db,
      $_db.decks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deckIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReviewRecordsTable, List<ReviewRecordRow>>
  _reviewRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reviewRecords,
    aliasName: $_aliasNameGenerator(db.cards.id, db.reviewRecords.cardId),
  );

  $$ReviewRecordsTableProcessedTableManager get reviewRecordsRefs {
    final manager = $$ReviewRecordsTableTableManager(
      $_db,
      $_db.reviewRecords,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
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

  ColumnFilters<String> get korean => $composableBuilder(
    column: $table.korean,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get romanization => $composableBuilder(
    column: $table.romanization,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningZh => $composableBuilder(
    column: $table.meaningZh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaningEn => $composableBuilder(
    column: $table.meaningEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleSentence => $composableBuilder(
    column: $table.exampleSentence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleTranslation => $composableBuilder(
    column: $table.exampleTranslation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DecksTableFilterComposer get deckId {
    final $$DecksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableFilterComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> reviewRecordsRefs(
    Expression<bool> Function($$ReviewRecordsTableFilterComposer f) f,
  ) {
    final $$ReviewRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewRecords,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewRecordsTableFilterComposer(
            $db: $db,
            $table: $db.reviewRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
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

  ColumnOrderings<String> get korean => $composableBuilder(
    column: $table.korean,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get romanization => $composableBuilder(
    column: $table.romanization,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningZh => $composableBuilder(
    column: $table.meaningZh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaningEn => $composableBuilder(
    column: $table.meaningEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleSentence => $composableBuilder(
    column: $table.exampleSentence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleTranslation => $composableBuilder(
    column: $table.exampleTranslation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DecksTableOrderingComposer get deckId {
    final $$DecksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableOrderingComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get korean =>
      $composableBuilder(column: $table.korean, builder: (column) => column);

  GeneratedColumn<String> get romanization => $composableBuilder(
    column: $table.romanization,
    builder: (column) => column,
  );

  GeneratedColumn<String> get meaningZh =>
      $composableBuilder(column: $table.meaningZh, builder: (column) => column);

  GeneratedColumn<String> get meaningEn =>
      $composableBuilder(column: $table.meaningEn, builder: (column) => column);

  GeneratedColumn<String> get exampleSentence => $composableBuilder(
    column: $table.exampleSentence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exampleTranslation => $composableBuilder(
    column: $table.exampleTranslation,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DecksTableAnnotationComposer get deckId {
    final $$DecksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.decks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecksTableAnnotationComposer(
            $db: $db,
            $table: $db.decks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> reviewRecordsRefs<T extends Object>(
    Expression<T> Function($$ReviewRecordsTableAnnotationComposer a) f,
  ) {
    final $$ReviewRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewRecords,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.reviewRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardsTable,
          CardRow,
          $$CardsTableFilterComposer,
          $$CardsTableOrderingComposer,
          $$CardsTableAnnotationComposer,
          $$CardsTableCreateCompanionBuilder,
          $$CardsTableUpdateCompanionBuilder,
          (CardRow, $$CardsTableReferences),
          CardRow,
          PrefetchHooks Function({bool deckId, bool reviewRecordsRefs})
        > {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> deckId = const Value.absent(),
                Value<String> korean = const Value.absent(),
                Value<String> romanization = const Value.absent(),
                Value<String> meaningZh = const Value.absent(),
                Value<String> meaningEn = const Value.absent(),
                Value<String> exampleSentence = const Value.absent(),
                Value<String> exampleTranslation = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardsCompanion(
                id: id,
                deckId: deckId,
                korean: korean,
                romanization: romanization,
                meaningZh: meaningZh,
                meaningEn: meaningEn,
                exampleSentence: exampleSentence,
                exampleTranslation: exampleTranslation,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String deckId,
                required String korean,
                required String romanization,
                required String meaningZh,
                required String meaningEn,
                Value<String> exampleSentence = const Value.absent(),
                Value<String> exampleTranslation = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardsCompanion.insert(
                id: id,
                deckId: deckId,
                korean: korean,
                romanization: romanization,
                meaningZh: meaningZh,
                meaningEn: meaningEn,
                exampleSentence: exampleSentence,
                exampleTranslation: exampleTranslation,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CardsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({deckId = false, reviewRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (reviewRecordsRefs) db.reviewRecords,
              ],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (deckId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.deckId,
                                referencedTable: $$CardsTableReferences
                                    ._deckIdTable(db),
                                referencedColumn: $$CardsTableReferences
                                    ._deckIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reviewRecordsRefs)
                    await $_getPrefetchedData<
                      CardRow,
                      $CardsTable,
                      ReviewRecordRow
                    >(
                      currentTable: table,
                      referencedTable: $$CardsTableReferences
                          ._reviewRecordsRefsTable(db),
                      managerFromTypedResult: (p0) => $$CardsTableReferences(
                        db,
                        table,
                        p0,
                      ).reviewRecordsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.cardId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardsTable,
      CardRow,
      $$CardsTableFilterComposer,
      $$CardsTableOrderingComposer,
      $$CardsTableAnnotationComposer,
      $$CardsTableCreateCompanionBuilder,
      $$CardsTableUpdateCompanionBuilder,
      (CardRow, $$CardsTableReferences),
      CardRow,
      PrefetchHooks Function({bool deckId, bool reviewRecordsRefs})
    >;
typedef $$ReviewRecordsTableCreateCompanionBuilder =
    ReviewRecordsCompanion Function({
      required String cardId,
      Value<double> easeFactor,
      Value<int> interval,
      Value<int> repetitions,
      required DateTime nextReviewAt,
      required DateTime lastReviewedAt,
      Value<int> rowid,
    });
typedef $$ReviewRecordsTableUpdateCompanionBuilder =
    ReviewRecordsCompanion Function({
      Value<String> cardId,
      Value<double> easeFactor,
      Value<int> interval,
      Value<int> repetitions,
      Value<DateTime> nextReviewAt,
      Value<DateTime> lastReviewedAt,
      Value<int> rowid,
    });

final class $$ReviewRecordsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ReviewRecordsTable, ReviewRecordRow> {
  $$ReviewRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CardsTable _cardIdTable(_$AppDatabase db) => db.cards.createAlias(
    $_aliasNameGenerator(db.reviewRecords.cardId, db.cards.id),
  );

  $$CardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<String>('card_id')!;

    final manager = $$CardsTableTableManager(
      $_db,
      $_db.cards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReviewRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewRecordsTable> {
  $$ReviewRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CardsTableFilterComposer get cardId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableFilterComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewRecordsTable> {
  $$ReviewRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CardsTableOrderingComposer get cardId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableOrderingComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewRecordsTable> {
  $$ReviewRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => column,
  );

  $$CardsTableAnnotationComposer get cardId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardsTableAnnotationComposer(
            $db: $db,
            $table: $db.cards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewRecordsTable,
          ReviewRecordRow,
          $$ReviewRecordsTableFilterComposer,
          $$ReviewRecordsTableOrderingComposer,
          $$ReviewRecordsTableAnnotationComposer,
          $$ReviewRecordsTableCreateCompanionBuilder,
          $$ReviewRecordsTableUpdateCompanionBuilder,
          (ReviewRecordRow, $$ReviewRecordsTableReferences),
          ReviewRecordRow,
          PrefetchHooks Function({bool cardId})
        > {
  $$ReviewRecordsTableTableManager(_$AppDatabase db, $ReviewRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> cardId = const Value.absent(),
                Value<double> easeFactor = const Value.absent(),
                Value<int> interval = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<DateTime> nextReviewAt = const Value.absent(),
                Value<DateTime> lastReviewedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewRecordsCompanion(
                cardId: cardId,
                easeFactor: easeFactor,
                interval: interval,
                repetitions: repetitions,
                nextReviewAt: nextReviewAt,
                lastReviewedAt: lastReviewedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cardId,
                Value<double> easeFactor = const Value.absent(),
                Value<int> interval = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                required DateTime nextReviewAt,
                required DateTime lastReviewedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReviewRecordsCompanion.insert(
                cardId: cardId,
                easeFactor: easeFactor,
                interval: interval,
                repetitions: repetitions,
                nextReviewAt: nextReviewAt,
                lastReviewedAt: lastReviewedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReviewRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cardId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cardId,
                                referencedTable: $$ReviewRecordsTableReferences
                                    ._cardIdTable(db),
                                referencedColumn: $$ReviewRecordsTableReferences
                                    ._cardIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReviewRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewRecordsTable,
      ReviewRecordRow,
      $$ReviewRecordsTableFilterComposer,
      $$ReviewRecordsTableOrderingComposer,
      $$ReviewRecordsTableAnnotationComposer,
      $$ReviewRecordsTableCreateCompanionBuilder,
      $$ReviewRecordsTableUpdateCompanionBuilder,
      (ReviewRecordRow, $$ReviewRecordsTableReferences),
      ReviewRecordRow,
      PrefetchHooks Function({bool cardId})
    >;
typedef $$AchievementsTableTableCreateCompanionBuilder =
    AchievementsTableCompanion Function({
      required String id,
      required String titleKey,
      required String descKey,
      required String iconName,
      required String condition,
      required int threshold,
      Value<bool> unlocked,
      Value<DateTime?> unlockedAt,
      Value<int> rowid,
    });
typedef $$AchievementsTableTableUpdateCompanionBuilder =
    AchievementsTableCompanion Function({
      Value<String> id,
      Value<String> titleKey,
      Value<String> descKey,
      Value<String> iconName,
      Value<String> condition,
      Value<int> threshold,
      Value<bool> unlocked,
      Value<DateTime?> unlockedAt,
      Value<int> rowid,
    });

class $$AchievementsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTableTable> {
  $$AchievementsTableTableFilterComposer({
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

  ColumnFilters<String> get titleKey => $composableBuilder(
    column: $table.titleKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descKey => $composableBuilder(
    column: $table.descKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get threshold => $composableBuilder(
    column: $table.threshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get unlocked => $composableBuilder(
    column: $table.unlocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AchievementsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTableTable> {
  $$AchievementsTableTableOrderingComposer({
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

  ColumnOrderings<String> get titleKey => $composableBuilder(
    column: $table.titleKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descKey => $composableBuilder(
    column: $table.descKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get threshold => $composableBuilder(
    column: $table.threshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get unlocked => $composableBuilder(
    column: $table.unlocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AchievementsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTableTable> {
  $$AchievementsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titleKey =>
      $composableBuilder(column: $table.titleKey, builder: (column) => column);

  GeneratedColumn<String> get descKey =>
      $composableBuilder(column: $table.descKey, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<int> get threshold =>
      $composableBuilder(column: $table.threshold, builder: (column) => column);

  GeneratedColumn<bool> get unlocked =>
      $composableBuilder(column: $table.unlocked, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );
}

class $$AchievementsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AchievementsTableTable,
          AchievementsTableData,
          $$AchievementsTableTableFilterComposer,
          $$AchievementsTableTableOrderingComposer,
          $$AchievementsTableTableAnnotationComposer,
          $$AchievementsTableTableCreateCompanionBuilder,
          $$AchievementsTableTableUpdateCompanionBuilder,
          (
            AchievementsTableData,
            BaseReferences<
              _$AppDatabase,
              $AchievementsTableTable,
              AchievementsTableData
            >,
          ),
          AchievementsTableData,
          PrefetchHooks Function()
        > {
  $$AchievementsTableTableTableManager(
    _$AppDatabase db,
    $AchievementsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> titleKey = const Value.absent(),
                Value<String> descKey = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<String> condition = const Value.absent(),
                Value<int> threshold = const Value.absent(),
                Value<bool> unlocked = const Value.absent(),
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementsTableCompanion(
                id: id,
                titleKey: titleKey,
                descKey: descKey,
                iconName: iconName,
                condition: condition,
                threshold: threshold,
                unlocked: unlocked,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String titleKey,
                required String descKey,
                required String iconName,
                required String condition,
                required int threshold,
                Value<bool> unlocked = const Value.absent(),
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementsTableCompanion.insert(
                id: id,
                titleKey: titleKey,
                descKey: descKey,
                iconName: iconName,
                condition: condition,
                threshold: threshold,
                unlocked: unlocked,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AchievementsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AchievementsTableTable,
      AchievementsTableData,
      $$AchievementsTableTableFilterComposer,
      $$AchievementsTableTableOrderingComposer,
      $$AchievementsTableTableAnnotationComposer,
      $$AchievementsTableTableCreateCompanionBuilder,
      $$AchievementsTableTableUpdateCompanionBuilder,
      (
        AchievementsTableData,
        BaseReferences<
          _$AppDatabase,
          $AchievementsTableTable,
          AchievementsTableData
        >,
      ),
      AchievementsTableData,
      PrefetchHooks Function()
    >;
typedef $$UserStatsTableTableCreateCompanionBuilder =
    UserStatsTableCompanion Function({
      Value<int> id,
      Value<int> currentStreak,
      Value<int> longestStreak,
      Value<int> totalCardsReviewed,
      Value<int> totalCorrect,
      Value<DateTime?> lastStudiedAt,
    });
typedef $$UserStatsTableTableUpdateCompanionBuilder =
    UserStatsTableCompanion Function({
      Value<int> id,
      Value<int> currentStreak,
      Value<int> longestStreak,
      Value<int> totalCardsReviewed,
      Value<int> totalCorrect,
      Value<DateTime?> lastStudiedAt,
    });

class $$UserStatsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserStatsTableTable> {
  $$UserStatsTableTableFilterComposer({
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

  ColumnFilters<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCardsReviewed => $composableBuilder(
    column: $table.totalCardsReviewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCorrect => $composableBuilder(
    column: $table.totalCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastStudiedAt => $composableBuilder(
    column: $table.lastStudiedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserStatsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserStatsTableTable> {
  $$UserStatsTableTableOrderingComposer({
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

  ColumnOrderings<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCardsReviewed => $composableBuilder(
    column: $table.totalCardsReviewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCorrect => $composableBuilder(
    column: $table.totalCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastStudiedAt => $composableBuilder(
    column: $table.lastStudiedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserStatsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserStatsTableTable> {
  $$UserStatsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCardsReviewed => $composableBuilder(
    column: $table.totalCardsReviewed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCorrect => $composableBuilder(
    column: $table.totalCorrect,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastStudiedAt => $composableBuilder(
    column: $table.lastStudiedAt,
    builder: (column) => column,
  );
}

class $$UserStatsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserStatsTableTable,
          UserStatsTableData,
          $$UserStatsTableTableFilterComposer,
          $$UserStatsTableTableOrderingComposer,
          $$UserStatsTableTableAnnotationComposer,
          $$UserStatsTableTableCreateCompanionBuilder,
          $$UserStatsTableTableUpdateCompanionBuilder,
          (
            UserStatsTableData,
            BaseReferences<
              _$AppDatabase,
              $UserStatsTableTable,
              UserStatsTableData
            >,
          ),
          UserStatsTableData,
          PrefetchHooks Function()
        > {
  $$UserStatsTableTableTableManager(
    _$AppDatabase db,
    $UserStatsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserStatsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserStatsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserStatsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<int> totalCardsReviewed = const Value.absent(),
                Value<int> totalCorrect = const Value.absent(),
                Value<DateTime?> lastStudiedAt = const Value.absent(),
              }) => UserStatsTableCompanion(
                id: id,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                totalCardsReviewed: totalCardsReviewed,
                totalCorrect: totalCorrect,
                lastStudiedAt: lastStudiedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<int> totalCardsReviewed = const Value.absent(),
                Value<int> totalCorrect = const Value.absent(),
                Value<DateTime?> lastStudiedAt = const Value.absent(),
              }) => UserStatsTableCompanion.insert(
                id: id,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                totalCardsReviewed: totalCardsReviewed,
                totalCorrect: totalCorrect,
                lastStudiedAt: lastStudiedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserStatsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserStatsTableTable,
      UserStatsTableData,
      $$UserStatsTableTableFilterComposer,
      $$UserStatsTableTableOrderingComposer,
      $$UserStatsTableTableAnnotationComposer,
      $$UserStatsTableTableCreateCompanionBuilder,
      $$UserStatsTableTableUpdateCompanionBuilder,
      (
        UserStatsTableData,
        BaseReferences<_$AppDatabase, $UserStatsTableTable, UserStatsTableData>,
      ),
      UserStatsTableData,
      PrefetchHooks Function()
    >;
typedef $$DailyReviewCountsTableCreateCompanionBuilder =
    DailyReviewCountsCompanion Function({
      required DateTime date,
      Value<int> count,
      Value<int> rowid,
    });
typedef $$DailyReviewCountsTableUpdateCompanionBuilder =
    DailyReviewCountsCompanion Function({
      Value<DateTime> date,
      Value<int> count,
      Value<int> rowid,
    });

class $$DailyReviewCountsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyReviewCountsTable> {
  $$DailyReviewCountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyReviewCountsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyReviewCountsTable> {
  $$DailyReviewCountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyReviewCountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyReviewCountsTable> {
  $$DailyReviewCountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);
}

class $$DailyReviewCountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyReviewCountsTable,
          DailyReviewCount,
          $$DailyReviewCountsTableFilterComposer,
          $$DailyReviewCountsTableOrderingComposer,
          $$DailyReviewCountsTableAnnotationComposer,
          $$DailyReviewCountsTableCreateCompanionBuilder,
          $$DailyReviewCountsTableUpdateCompanionBuilder,
          (
            DailyReviewCount,
            BaseReferences<
              _$AppDatabase,
              $DailyReviewCountsTable,
              DailyReviewCount
            >,
          ),
          DailyReviewCount,
          PrefetchHooks Function()
        > {
  $$DailyReviewCountsTableTableManager(
    _$AppDatabase db,
    $DailyReviewCountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyReviewCountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyReviewCountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyReviewCountsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<DateTime> date = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyReviewCountsCompanion(
                date: date,
                count: count,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime date,
                Value<int> count = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyReviewCountsCompanion.insert(
                date: date,
                count: count,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyReviewCountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyReviewCountsTable,
      DailyReviewCount,
      $$DailyReviewCountsTableFilterComposer,
      $$DailyReviewCountsTableOrderingComposer,
      $$DailyReviewCountsTableAnnotationComposer,
      $$DailyReviewCountsTableCreateCompanionBuilder,
      $$DailyReviewCountsTableUpdateCompanionBuilder,
      (
        DailyReviewCount,
        BaseReferences<
          _$AppDatabase,
          $DailyReviewCountsTable,
          DailyReviewCount
        >,
      ),
      DailyReviewCount,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DecksTableTableManager get decks =>
      $$DecksTableTableManager(_db, _db.decks);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
  $$ReviewRecordsTableTableManager get reviewRecords =>
      $$ReviewRecordsTableTableManager(_db, _db.reviewRecords);
  $$AchievementsTableTableTableManager get achievementsTable =>
      $$AchievementsTableTableTableManager(_db, _db.achievementsTable);
  $$UserStatsTableTableTableManager get userStatsTable =>
      $$UserStatsTableTableTableManager(_db, _db.userStatsTable);
  $$DailyReviewCountsTableTableManager get dailyReviewCounts =>
      $$DailyReviewCountsTableTableManager(_db, _db.dailyReviewCounts);
}
