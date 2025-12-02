// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TranscriptionsTable extends Transcriptions
    with TableInfo<$TranscriptionsTable, Transcription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _durationMsMeta =
      const VerificationMeta('durationMs');
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
      'duration_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _languageCodeMeta =
      const VerificationMeta('languageCode');
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
      'language_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _speakerCountMeta =
      const VerificationMeta('speakerCount');
  @override
  late final GeneratedColumn<int> speakerCount = GeneratedColumn<int>(
      'speaker_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _audioFilePathMeta =
      const VerificationMeta('audioFilePath');
  @override
  late final GeneratedColumn<String> audioFilePath = GeneratedColumn<String>(
      'audio_file_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        createdAt,
        updatedAt,
        durationMs,
        languageCode,
        speakerCount,
        audioFilePath
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transcriptions';
  @override
  VerificationContext validateIntegrity(Insertable<Transcription> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
          _durationMsMeta,
          durationMs.isAcceptableOrUnknown(
              data['duration_ms']!, _durationMsMeta));
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
          _languageCodeMeta,
          languageCode.isAcceptableOrUnknown(
              data['language_code']!, _languageCodeMeta));
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('speaker_count')) {
      context.handle(
          _speakerCountMeta,
          speakerCount.isAcceptableOrUnknown(
              data['speaker_count']!, _speakerCountMeta));
    } else if (isInserting) {
      context.missing(_speakerCountMeta);
    }
    if (data.containsKey('audio_file_path')) {
      context.handle(
          _audioFilePathMeta,
          audioFilePath.isAcceptableOrUnknown(
              data['audio_file_path']!, _audioFilePathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transcription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transcription(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      durationMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_ms'])!,
      languageCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language_code'])!,
      speakerCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}speaker_count'])!,
      audioFilePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_file_path']),
    );
  }

  @override
  $TranscriptionsTable createAlias(String alias) {
    return $TranscriptionsTable(attachedDatabase, alias);
  }
}

class Transcription extends DataClass implements Insertable<Transcription> {
  /// 唯一標識
  final String id;

  /// 標題
  final String? title;

  /// 創建時間 (Unix timestamp)
  final int createdAt;

  /// 更新時間 (Unix timestamp)
  final int updatedAt;

  /// 時長 (毫秒)
  final int durationMs;

  /// 語言代碼
  final String languageCode;

  /// 說話人數量
  final int speakerCount;

  /// 音頻文件路徑（可選，用於播放源音頻）
  final String? audioFilePath;
  const Transcription(
      {required this.id,
      this.title,
      required this.createdAt,
      required this.updatedAt,
      required this.durationMs,
      required this.languageCode,
      required this.speakerCount,
      this.audioFilePath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['duration_ms'] = Variable<int>(durationMs);
    map['language_code'] = Variable<String>(languageCode);
    map['speaker_count'] = Variable<int>(speakerCount);
    if (!nullToAbsent || audioFilePath != null) {
      map['audio_file_path'] = Variable<String>(audioFilePath);
    }
    return map;
  }

  TranscriptionsCompanion toCompanion(bool nullToAbsent) {
    return TranscriptionsCompanion(
      id: Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      durationMs: Value(durationMs),
      languageCode: Value(languageCode),
      speakerCount: Value(speakerCount),
      audioFilePath: audioFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioFilePath),
    );
  }

  factory Transcription.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transcription(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      speakerCount: serializer.fromJson<int>(json['speakerCount']),
      audioFilePath: serializer.fromJson<String?>(json['audioFilePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String?>(title),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'durationMs': serializer.toJson<int>(durationMs),
      'languageCode': serializer.toJson<String>(languageCode),
      'speakerCount': serializer.toJson<int>(speakerCount),
      'audioFilePath': serializer.toJson<String?>(audioFilePath),
    };
  }

  Transcription copyWith(
          {String? id,
          Value<String?> title = const Value.absent(),
          int? createdAt,
          int? updatedAt,
          int? durationMs,
          String? languageCode,
          int? speakerCount,
          Value<String?> audioFilePath = const Value.absent()}) =>
      Transcription(
        id: id ?? this.id,
        title: title.present ? title.value : this.title,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        durationMs: durationMs ?? this.durationMs,
        languageCode: languageCode ?? this.languageCode,
        speakerCount: speakerCount ?? this.speakerCount,
        audioFilePath:
            audioFilePath.present ? audioFilePath.value : this.audioFilePath,
      );
  Transcription copyWithCompanion(TranscriptionsCompanion data) {
    return Transcription(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      durationMs:
          data.durationMs.present ? data.durationMs.value : this.durationMs,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      speakerCount: data.speakerCount.present
          ? data.speakerCount.value
          : this.speakerCount,
      audioFilePath: data.audioFilePath.present
          ? data.audioFilePath.value
          : this.audioFilePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transcription(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('languageCode: $languageCode, ')
          ..write('speakerCount: $speakerCount, ')
          ..write('audioFilePath: $audioFilePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, createdAt, updatedAt, durationMs,
      languageCode, speakerCount, audioFilePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transcription &&
          other.id == this.id &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.durationMs == this.durationMs &&
          other.languageCode == this.languageCode &&
          other.speakerCount == this.speakerCount &&
          other.audioFilePath == this.audioFilePath);
}

class TranscriptionsCompanion extends UpdateCompanion<Transcription> {
  final Value<String> id;
  final Value<String?> title;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> durationMs;
  final Value<String> languageCode;
  final Value<int> speakerCount;
  final Value<String?> audioFilePath;
  final Value<int> rowid;
  const TranscriptionsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.speakerCount = const Value.absent(),
    this.audioFilePath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TranscriptionsCompanion.insert({
    required String id,
    this.title = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    required int durationMs,
    required String languageCode,
    required int speakerCount,
    this.audioFilePath = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        durationMs = Value(durationMs),
        languageCode = Value(languageCode),
        speakerCount = Value(speakerCount);
  static Insertable<Transcription> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? durationMs,
    Expression<String>? languageCode,
    Expression<int>? speakerCount,
    Expression<String>? audioFilePath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (durationMs != null) 'duration_ms': durationMs,
      if (languageCode != null) 'language_code': languageCode,
      if (speakerCount != null) 'speaker_count': speakerCount,
      if (audioFilePath != null) 'audio_file_path': audioFilePath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TranscriptionsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? title,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? durationMs,
      Value<String>? languageCode,
      Value<int>? speakerCount,
      Value<String?>? audioFilePath,
      Value<int>? rowid}) {
    return TranscriptionsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      durationMs: durationMs ?? this.durationMs,
      languageCode: languageCode ?? this.languageCode,
      speakerCount: speakerCount ?? this.speakerCount,
      audioFilePath: audioFilePath ?? this.audioFilePath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (speakerCount.present) {
      map['speaker_count'] = Variable<int>(speakerCount.value);
    }
    if (audioFilePath.present) {
      map['audio_file_path'] = Variable<String>(audioFilePath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('languageCode: $languageCode, ')
          ..write('speakerCount: $speakerCount, ')
          ..write('audioFilePath: $audioFilePath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TranscriptionSegmentsTable extends TranscriptionSegments
    with TableInfo<$TranscriptionSegmentsTable, TranscriptionSegment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranscriptionSegmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transcriptionIdMeta =
      const VerificationMeta('transcriptionId');
  @override
  late final GeneratedColumn<String> transcriptionId = GeneratedColumn<String>(
      'transcription_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES transcriptions (id)'));
  static const VerificationMeta _speakerLabelMeta =
      const VerificationMeta('speakerLabel');
  @override
  late final GeneratedColumn<String> speakerLabel = GeneratedColumn<String>(
      'speaker_label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMsMeta =
      const VerificationMeta('startTimeMs');
  @override
  late final GeneratedColumn<int> startTimeMs = GeneratedColumn<int>(
      'start_time_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMsMeta =
      const VerificationMeta('endTimeMs');
  @override
  late final GeneratedColumn<int> endTimeMs = GeneratedColumn<int>(
      'end_time_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        transcriptionId,
        speakerLabel,
        startTimeMs,
        endTimeMs,
        content,
        orderIndex
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transcription_segments';
  @override
  VerificationContext validateIntegrity(
      Insertable<TranscriptionSegment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transcription_id')) {
      context.handle(
          _transcriptionIdMeta,
          transcriptionId.isAcceptableOrUnknown(
              data['transcription_id']!, _transcriptionIdMeta));
    } else if (isInserting) {
      context.missing(_transcriptionIdMeta);
    }
    if (data.containsKey('speaker_label')) {
      context.handle(
          _speakerLabelMeta,
          speakerLabel.isAcceptableOrUnknown(
              data['speaker_label']!, _speakerLabelMeta));
    } else if (isInserting) {
      context.missing(_speakerLabelMeta);
    }
    if (data.containsKey('start_time_ms')) {
      context.handle(
          _startTimeMsMeta,
          startTimeMs.isAcceptableOrUnknown(
              data['start_time_ms']!, _startTimeMsMeta));
    } else if (isInserting) {
      context.missing(_startTimeMsMeta);
    }
    if (data.containsKey('end_time_ms')) {
      context.handle(
          _endTimeMsMeta,
          endTimeMs.isAcceptableOrUnknown(
              data['end_time_ms']!, _endTimeMsMeta));
    } else if (isInserting) {
      context.missing(_endTimeMsMeta);
    }
    if (data.containsKey('text')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['text']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TranscriptionSegment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TranscriptionSegment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      transcriptionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}transcription_id'])!,
      speakerLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}speaker_label'])!,
      startTimeMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_time_ms'])!,
      endTimeMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_time_ms'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
    );
  }

  @override
  $TranscriptionSegmentsTable createAlias(String alias) {
    return $TranscriptionSegmentsTable(attachedDatabase, alias);
  }
}

class TranscriptionSegment extends DataClass
    implements Insertable<TranscriptionSegment> {
  /// 唯一標識
  final String id;

  /// 所屬轉錄記錄 ID
  final String transcriptionId;

  /// 說話人標籤 (如 "Speaker A" 或自定義名稱)
  final String speakerLabel;

  /// 開始時間 (毫秒)
  final int startTimeMs;

  /// 結束時間 (毫秒)
  final int endTimeMs;

  /// 文字內容
  final String content;

  /// 排序索引
  final int orderIndex;
  const TranscriptionSegment(
      {required this.id,
      required this.transcriptionId,
      required this.speakerLabel,
      required this.startTimeMs,
      required this.endTimeMs,
      required this.content,
      required this.orderIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transcription_id'] = Variable<String>(transcriptionId);
    map['speaker_label'] = Variable<String>(speakerLabel);
    map['start_time_ms'] = Variable<int>(startTimeMs);
    map['end_time_ms'] = Variable<int>(endTimeMs);
    map['text'] = Variable<String>(content);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  TranscriptionSegmentsCompanion toCompanion(bool nullToAbsent) {
    return TranscriptionSegmentsCompanion(
      id: Value(id),
      transcriptionId: Value(transcriptionId),
      speakerLabel: Value(speakerLabel),
      startTimeMs: Value(startTimeMs),
      endTimeMs: Value(endTimeMs),
      content: Value(content),
      orderIndex: Value(orderIndex),
    );
  }

  factory TranscriptionSegment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TranscriptionSegment(
      id: serializer.fromJson<String>(json['id']),
      transcriptionId: serializer.fromJson<String>(json['transcriptionId']),
      speakerLabel: serializer.fromJson<String>(json['speakerLabel']),
      startTimeMs: serializer.fromJson<int>(json['startTimeMs']),
      endTimeMs: serializer.fromJson<int>(json['endTimeMs']),
      content: serializer.fromJson<String>(json['content']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transcriptionId': serializer.toJson<String>(transcriptionId),
      'speakerLabel': serializer.toJson<String>(speakerLabel),
      'startTimeMs': serializer.toJson<int>(startTimeMs),
      'endTimeMs': serializer.toJson<int>(endTimeMs),
      'content': serializer.toJson<String>(content),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  TranscriptionSegment copyWith(
          {String? id,
          String? transcriptionId,
          String? speakerLabel,
          int? startTimeMs,
          int? endTimeMs,
          String? content,
          int? orderIndex}) =>
      TranscriptionSegment(
        id: id ?? this.id,
        transcriptionId: transcriptionId ?? this.transcriptionId,
        speakerLabel: speakerLabel ?? this.speakerLabel,
        startTimeMs: startTimeMs ?? this.startTimeMs,
        endTimeMs: endTimeMs ?? this.endTimeMs,
        content: content ?? this.content,
        orderIndex: orderIndex ?? this.orderIndex,
      );
  TranscriptionSegment copyWithCompanion(TranscriptionSegmentsCompanion data) {
    return TranscriptionSegment(
      id: data.id.present ? data.id.value : this.id,
      transcriptionId: data.transcriptionId.present
          ? data.transcriptionId.value
          : this.transcriptionId,
      speakerLabel: data.speakerLabel.present
          ? data.speakerLabel.value
          : this.speakerLabel,
      startTimeMs:
          data.startTimeMs.present ? data.startTimeMs.value : this.startTimeMs,
      endTimeMs: data.endTimeMs.present ? data.endTimeMs.value : this.endTimeMs,
      content: data.content.present ? data.content.value : this.content,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TranscriptionSegment(')
          ..write('id: $id, ')
          ..write('transcriptionId: $transcriptionId, ')
          ..write('speakerLabel: $speakerLabel, ')
          ..write('startTimeMs: $startTimeMs, ')
          ..write('endTimeMs: $endTimeMs, ')
          ..write('content: $content, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, transcriptionId, speakerLabel,
      startTimeMs, endTimeMs, content, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TranscriptionSegment &&
          other.id == this.id &&
          other.transcriptionId == this.transcriptionId &&
          other.speakerLabel == this.speakerLabel &&
          other.startTimeMs == this.startTimeMs &&
          other.endTimeMs == this.endTimeMs &&
          other.content == this.content &&
          other.orderIndex == this.orderIndex);
}

class TranscriptionSegmentsCompanion
    extends UpdateCompanion<TranscriptionSegment> {
  final Value<String> id;
  final Value<String> transcriptionId;
  final Value<String> speakerLabel;
  final Value<int> startTimeMs;
  final Value<int> endTimeMs;
  final Value<String> content;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const TranscriptionSegmentsCompanion({
    this.id = const Value.absent(),
    this.transcriptionId = const Value.absent(),
    this.speakerLabel = const Value.absent(),
    this.startTimeMs = const Value.absent(),
    this.endTimeMs = const Value.absent(),
    this.content = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TranscriptionSegmentsCompanion.insert({
    required String id,
    required String transcriptionId,
    required String speakerLabel,
    required int startTimeMs,
    required int endTimeMs,
    required String content,
    required int orderIndex,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        transcriptionId = Value(transcriptionId),
        speakerLabel = Value(speakerLabel),
        startTimeMs = Value(startTimeMs),
        endTimeMs = Value(endTimeMs),
        content = Value(content),
        orderIndex = Value(orderIndex);
  static Insertable<TranscriptionSegment> custom({
    Expression<String>? id,
    Expression<String>? transcriptionId,
    Expression<String>? speakerLabel,
    Expression<int>? startTimeMs,
    Expression<int>? endTimeMs,
    Expression<String>? content,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transcriptionId != null) 'transcription_id': transcriptionId,
      if (speakerLabel != null) 'speaker_label': speakerLabel,
      if (startTimeMs != null) 'start_time_ms': startTimeMs,
      if (endTimeMs != null) 'end_time_ms': endTimeMs,
      if (content != null) 'text': content,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TranscriptionSegmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? transcriptionId,
      Value<String>? speakerLabel,
      Value<int>? startTimeMs,
      Value<int>? endTimeMs,
      Value<String>? content,
      Value<int>? orderIndex,
      Value<int>? rowid}) {
    return TranscriptionSegmentsCompanion(
      id: id ?? this.id,
      transcriptionId: transcriptionId ?? this.transcriptionId,
      speakerLabel: speakerLabel ?? this.speakerLabel,
      startTimeMs: startTimeMs ?? this.startTimeMs,
      endTimeMs: endTimeMs ?? this.endTimeMs,
      content: content ?? this.content,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transcriptionId.present) {
      map['transcription_id'] = Variable<String>(transcriptionId.value);
    }
    if (speakerLabel.present) {
      map['speaker_label'] = Variable<String>(speakerLabel.value);
    }
    if (startTimeMs.present) {
      map['start_time_ms'] = Variable<int>(startTimeMs.value);
    }
    if (endTimeMs.present) {
      map['end_time_ms'] = Variable<int>(endTimeMs.value);
    }
    if (content.present) {
      map['text'] = Variable<String>(content.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranscriptionSegmentsCompanion(')
          ..write('id: $id, ')
          ..write('transcriptionId: $transcriptionId, ')
          ..write('speakerLabel: $speakerLabel, ')
          ..write('startTimeMs: $startTimeMs, ')
          ..write('endTimeMs: $endTimeMs, ')
          ..write('content: $content, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpeakerMappingsTable extends SpeakerMappings
    with TableInfo<$SpeakerMappingsTable, SpeakerMapping> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeakerMappingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _transcriptionIdMeta =
      const VerificationMeta('transcriptionId');
  @override
  late final GeneratedColumn<String> transcriptionId = GeneratedColumn<String>(
      'transcription_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES transcriptions (id)'));
  static const VerificationMeta _originalLabelMeta =
      const VerificationMeta('originalLabel');
  @override
  late final GeneratedColumn<String> originalLabel = GeneratedColumn<String>(
      'original_label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customNameMeta =
      const VerificationMeta('customName');
  @override
  late final GeneratedColumn<String> customName = GeneratedColumn<String>(
      'custom_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, transcriptionId, originalLabel, customName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'speaker_mappings';
  @override
  VerificationContext validateIntegrity(Insertable<SpeakerMapping> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transcription_id')) {
      context.handle(
          _transcriptionIdMeta,
          transcriptionId.isAcceptableOrUnknown(
              data['transcription_id']!, _transcriptionIdMeta));
    } else if (isInserting) {
      context.missing(_transcriptionIdMeta);
    }
    if (data.containsKey('original_label')) {
      context.handle(
          _originalLabelMeta,
          originalLabel.isAcceptableOrUnknown(
              data['original_label']!, _originalLabelMeta));
    } else if (isInserting) {
      context.missing(_originalLabelMeta);
    }
    if (data.containsKey('custom_name')) {
      context.handle(
          _customNameMeta,
          customName.isAcceptableOrUnknown(
              data['custom_name']!, _customNameMeta));
    } else if (isInserting) {
      context.missing(_customNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpeakerMapping map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeakerMapping(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      transcriptionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}transcription_id'])!,
      originalLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}original_label'])!,
      customName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_name'])!,
    );
  }

  @override
  $SpeakerMappingsTable createAlias(String alias) {
    return $SpeakerMappingsTable(attachedDatabase, alias);
  }
}

class SpeakerMapping extends DataClass implements Insertable<SpeakerMapping> {
  /// 唯一標識
  final String id;

  /// 所屬轉錄記錄 ID
  final String transcriptionId;

  /// 原始標籤 ("A", "B", "C")
  final String originalLabel;

  /// 自定義名稱 ("張三")
  final String customName;
  const SpeakerMapping(
      {required this.id,
      required this.transcriptionId,
      required this.originalLabel,
      required this.customName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transcription_id'] = Variable<String>(transcriptionId);
    map['original_label'] = Variable<String>(originalLabel);
    map['custom_name'] = Variable<String>(customName);
    return map;
  }

  SpeakerMappingsCompanion toCompanion(bool nullToAbsent) {
    return SpeakerMappingsCompanion(
      id: Value(id),
      transcriptionId: Value(transcriptionId),
      originalLabel: Value(originalLabel),
      customName: Value(customName),
    );
  }

  factory SpeakerMapping.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeakerMapping(
      id: serializer.fromJson<String>(json['id']),
      transcriptionId: serializer.fromJson<String>(json['transcriptionId']),
      originalLabel: serializer.fromJson<String>(json['originalLabel']),
      customName: serializer.fromJson<String>(json['customName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transcriptionId': serializer.toJson<String>(transcriptionId),
      'originalLabel': serializer.toJson<String>(originalLabel),
      'customName': serializer.toJson<String>(customName),
    };
  }

  SpeakerMapping copyWith(
          {String? id,
          String? transcriptionId,
          String? originalLabel,
          String? customName}) =>
      SpeakerMapping(
        id: id ?? this.id,
        transcriptionId: transcriptionId ?? this.transcriptionId,
        originalLabel: originalLabel ?? this.originalLabel,
        customName: customName ?? this.customName,
      );
  SpeakerMapping copyWithCompanion(SpeakerMappingsCompanion data) {
    return SpeakerMapping(
      id: data.id.present ? data.id.value : this.id,
      transcriptionId: data.transcriptionId.present
          ? data.transcriptionId.value
          : this.transcriptionId,
      originalLabel: data.originalLabel.present
          ? data.originalLabel.value
          : this.originalLabel,
      customName:
          data.customName.present ? data.customName.value : this.customName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeakerMapping(')
          ..write('id: $id, ')
          ..write('transcriptionId: $transcriptionId, ')
          ..write('originalLabel: $originalLabel, ')
          ..write('customName: $customName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, transcriptionId, originalLabel, customName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeakerMapping &&
          other.id == this.id &&
          other.transcriptionId == this.transcriptionId &&
          other.originalLabel == this.originalLabel &&
          other.customName == this.customName);
}

class SpeakerMappingsCompanion extends UpdateCompanion<SpeakerMapping> {
  final Value<String> id;
  final Value<String> transcriptionId;
  final Value<String> originalLabel;
  final Value<String> customName;
  final Value<int> rowid;
  const SpeakerMappingsCompanion({
    this.id = const Value.absent(),
    this.transcriptionId = const Value.absent(),
    this.originalLabel = const Value.absent(),
    this.customName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpeakerMappingsCompanion.insert({
    required String id,
    required String transcriptionId,
    required String originalLabel,
    required String customName,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        transcriptionId = Value(transcriptionId),
        originalLabel = Value(originalLabel),
        customName = Value(customName);
  static Insertable<SpeakerMapping> custom({
    Expression<String>? id,
    Expression<String>? transcriptionId,
    Expression<String>? originalLabel,
    Expression<String>? customName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transcriptionId != null) 'transcription_id': transcriptionId,
      if (originalLabel != null) 'original_label': originalLabel,
      if (customName != null) 'custom_name': customName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpeakerMappingsCompanion copyWith(
      {Value<String>? id,
      Value<String>? transcriptionId,
      Value<String>? originalLabel,
      Value<String>? customName,
      Value<int>? rowid}) {
    return SpeakerMappingsCompanion(
      id: id ?? this.id,
      transcriptionId: transcriptionId ?? this.transcriptionId,
      originalLabel: originalLabel ?? this.originalLabel,
      customName: customName ?? this.customName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transcriptionId.present) {
      map['transcription_id'] = Variable<String>(transcriptionId.value);
    }
    if (originalLabel.present) {
      map['original_label'] = Variable<String>(originalLabel.value);
    }
    if (customName.present) {
      map['custom_name'] = Variable<String>(customName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeakerMappingsCompanion(')
          ..write('id: $id, ')
          ..write('transcriptionId: $transcriptionId, ')
          ..write('originalLabel: $originalLabel, ')
          ..write('customName: $customName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  /// 設置 Key
  final String key;

  /// 設置值
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) => AppSetting(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TranscriptionsTable transcriptions = $TranscriptionsTable(this);
  late final $TranscriptionSegmentsTable transcriptionSegments =
      $TranscriptionSegmentsTable(this);
  late final $SpeakerMappingsTable speakerMappings =
      $SpeakerMappingsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [transcriptions, transcriptionSegments, speakerMappings, appSettings];
}

typedef $$TranscriptionsTableCreateCompanionBuilder = TranscriptionsCompanion
    Function({
  required String id,
  Value<String?> title,
  required int createdAt,
  required int updatedAt,
  required int durationMs,
  required String languageCode,
  required int speakerCount,
  Value<String?> audioFilePath,
  Value<int> rowid,
});
typedef $$TranscriptionsTableUpdateCompanionBuilder = TranscriptionsCompanion
    Function({
  Value<String> id,
  Value<String?> title,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> durationMs,
  Value<String> languageCode,
  Value<int> speakerCount,
  Value<String?> audioFilePath,
  Value<int> rowid,
});

final class $$TranscriptionsTableReferences
    extends BaseReferences<_$AppDatabase, $TranscriptionsTable, Transcription> {
  $$TranscriptionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TranscriptionSegmentsTable,
      List<TranscriptionSegment>> _transcriptionSegmentsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.transcriptionSegments,
          aliasName: $_aliasNameGenerator(
              db.transcriptions.id, db.transcriptionSegments.transcriptionId));

  $$TranscriptionSegmentsTableProcessedTableManager
      get transcriptionSegmentsRefs {
    final manager = $$TranscriptionSegmentsTableTableManager(
            $_db, $_db.transcriptionSegments)
        .filter(
            (f) => f.transcriptionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transcriptionSegmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SpeakerMappingsTable, List<SpeakerMapping>>
      _speakerMappingsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.speakerMappings,
              aliasName: $_aliasNameGenerator(
                  db.transcriptions.id, db.speakerMappings.transcriptionId));

  $$SpeakerMappingsTableProcessedTableManager get speakerMappingsRefs {
    final manager =
        $$SpeakerMappingsTableTableManager($_db, $_db.speakerMappings).filter(
            (f) => f.transcriptionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_speakerMappingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TranscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $TranscriptionsTable> {
  $$TranscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get languageCode => $composableBuilder(
      column: $table.languageCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get speakerCount => $composableBuilder(
      column: $table.speakerCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioFilePath => $composableBuilder(
      column: $table.audioFilePath, builder: (column) => ColumnFilters(column));

  Expression<bool> transcriptionSegmentsRefs(
      Expression<bool> Function($$TranscriptionSegmentsTableFilterComposer f)
          f) {
    final $$TranscriptionSegmentsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.transcriptionSegments,
            getReferencedColumn: (t) => t.transcriptionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$TranscriptionSegmentsTableFilterComposer(
                  $db: $db,
                  $table: $db.transcriptionSegments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> speakerMappingsRefs(
      Expression<bool> Function($$SpeakerMappingsTableFilterComposer f) f) {
    final $$SpeakerMappingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.speakerMappings,
        getReferencedColumn: (t) => t.transcriptionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeakerMappingsTableFilterComposer(
              $db: $db,
              $table: $db.speakerMappings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TranscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TranscriptionsTable> {
  $$TranscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get languageCode => $composableBuilder(
      column: $table.languageCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get speakerCount => $composableBuilder(
      column: $table.speakerCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioFilePath => $composableBuilder(
      column: $table.audioFilePath,
      builder: (column) => ColumnOrderings(column));
}

class $$TranscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranscriptionsTable> {
  $$TranscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => column);

  GeneratedColumn<String> get languageCode => $composableBuilder(
      column: $table.languageCode, builder: (column) => column);

  GeneratedColumn<int> get speakerCount => $composableBuilder(
      column: $table.speakerCount, builder: (column) => column);

  GeneratedColumn<String> get audioFilePath => $composableBuilder(
      column: $table.audioFilePath, builder: (column) => column);

  Expression<T> transcriptionSegmentsRefs<T extends Object>(
      Expression<T> Function($$TranscriptionSegmentsTableAnnotationComposer a)
          f) {
    final $$TranscriptionSegmentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.transcriptionSegments,
            getReferencedColumn: (t) => t.transcriptionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$TranscriptionSegmentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.transcriptionSegments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> speakerMappingsRefs<T extends Object>(
      Expression<T> Function($$SpeakerMappingsTableAnnotationComposer a) f) {
    final $$SpeakerMappingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.speakerMappings,
        getReferencedColumn: (t) => t.transcriptionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SpeakerMappingsTableAnnotationComposer(
              $db: $db,
              $table: $db.speakerMappings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TranscriptionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TranscriptionsTable,
    Transcription,
    $$TranscriptionsTableFilterComposer,
    $$TranscriptionsTableOrderingComposer,
    $$TranscriptionsTableAnnotationComposer,
    $$TranscriptionsTableCreateCompanionBuilder,
    $$TranscriptionsTableUpdateCompanionBuilder,
    (Transcription, $$TranscriptionsTableReferences),
    Transcription,
    PrefetchHooks Function(
        {bool transcriptionSegmentsRefs, bool speakerMappingsRefs})> {
  $$TranscriptionsTableTableManager(
      _$AppDatabase db, $TranscriptionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TranscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranscriptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> durationMs = const Value.absent(),
            Value<String> languageCode = const Value.absent(),
            Value<int> speakerCount = const Value.absent(),
            Value<String?> audioFilePath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TranscriptionsCompanion(
            id: id,
            title: title,
            createdAt: createdAt,
            updatedAt: updatedAt,
            durationMs: durationMs,
            languageCode: languageCode,
            speakerCount: speakerCount,
            audioFilePath: audioFilePath,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> title = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            required int durationMs,
            required String languageCode,
            required int speakerCount,
            Value<String?> audioFilePath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TranscriptionsCompanion.insert(
            id: id,
            title: title,
            createdAt: createdAt,
            updatedAt: updatedAt,
            durationMs: durationMs,
            languageCode: languageCode,
            speakerCount: speakerCount,
            audioFilePath: audioFilePath,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TranscriptionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {transcriptionSegmentsRefs = false,
              speakerMappingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transcriptionSegmentsRefs) db.transcriptionSegments,
                if (speakerMappingsRefs) db.speakerMappings
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transcriptionSegmentsRefs)
                    await $_getPrefetchedData<Transcription,
                            $TranscriptionsTable, TranscriptionSegment>(
                        currentTable: table,
                        referencedTable: $$TranscriptionsTableReferences
                            ._transcriptionSegmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TranscriptionsTableReferences(db, table, p0)
                                .transcriptionSegmentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.transcriptionId == item.id),
                        typedResults: items),
                  if (speakerMappingsRefs)
                    await $_getPrefetchedData<Transcription,
                            $TranscriptionsTable, SpeakerMapping>(
                        currentTable: table,
                        referencedTable: $$TranscriptionsTableReferences
                            ._speakerMappingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TranscriptionsTableReferences(db, table, p0)
                                .speakerMappingsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.transcriptionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TranscriptionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TranscriptionsTable,
    Transcription,
    $$TranscriptionsTableFilterComposer,
    $$TranscriptionsTableOrderingComposer,
    $$TranscriptionsTableAnnotationComposer,
    $$TranscriptionsTableCreateCompanionBuilder,
    $$TranscriptionsTableUpdateCompanionBuilder,
    (Transcription, $$TranscriptionsTableReferences),
    Transcription,
    PrefetchHooks Function(
        {bool transcriptionSegmentsRefs, bool speakerMappingsRefs})>;
typedef $$TranscriptionSegmentsTableCreateCompanionBuilder
    = TranscriptionSegmentsCompanion Function({
  required String id,
  required String transcriptionId,
  required String speakerLabel,
  required int startTimeMs,
  required int endTimeMs,
  required String content,
  required int orderIndex,
  Value<int> rowid,
});
typedef $$TranscriptionSegmentsTableUpdateCompanionBuilder
    = TranscriptionSegmentsCompanion Function({
  Value<String> id,
  Value<String> transcriptionId,
  Value<String> speakerLabel,
  Value<int> startTimeMs,
  Value<int> endTimeMs,
  Value<String> content,
  Value<int> orderIndex,
  Value<int> rowid,
});

final class $$TranscriptionSegmentsTableReferences extends BaseReferences<
    _$AppDatabase, $TranscriptionSegmentsTable, TranscriptionSegment> {
  $$TranscriptionSegmentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TranscriptionsTable _transcriptionIdTable(_$AppDatabase db) =>
      db.transcriptions.createAlias($_aliasNameGenerator(
          db.transcriptionSegments.transcriptionId, db.transcriptions.id));

  $$TranscriptionsTableProcessedTableManager get transcriptionId {
    final $_column = $_itemColumn<String>('transcription_id')!;

    final manager = $$TranscriptionsTableTableManager($_db, $_db.transcriptions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transcriptionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TranscriptionSegmentsTableFilterComposer
    extends Composer<_$AppDatabase, $TranscriptionSegmentsTable> {
  $$TranscriptionSegmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get speakerLabel => $composableBuilder(
      column: $table.speakerLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startTimeMs => $composableBuilder(
      column: $table.startTimeMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endTimeMs => $composableBuilder(
      column: $table.endTimeMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  $$TranscriptionsTableFilterComposer get transcriptionId {
    final $$TranscriptionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transcriptionId,
        referencedTable: $db.transcriptions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranscriptionsTableFilterComposer(
              $db: $db,
              $table: $db.transcriptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TranscriptionSegmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $TranscriptionSegmentsTable> {
  $$TranscriptionSegmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get speakerLabel => $composableBuilder(
      column: $table.speakerLabel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startTimeMs => $composableBuilder(
      column: $table.startTimeMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endTimeMs => $composableBuilder(
      column: $table.endTimeMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  $$TranscriptionsTableOrderingComposer get transcriptionId {
    final $$TranscriptionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transcriptionId,
        referencedTable: $db.transcriptions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranscriptionsTableOrderingComposer(
              $db: $db,
              $table: $db.transcriptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TranscriptionSegmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranscriptionSegmentsTable> {
  $$TranscriptionSegmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get speakerLabel => $composableBuilder(
      column: $table.speakerLabel, builder: (column) => column);

  GeneratedColumn<int> get startTimeMs => $composableBuilder(
      column: $table.startTimeMs, builder: (column) => column);

  GeneratedColumn<int> get endTimeMs =>
      $composableBuilder(column: $table.endTimeMs, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  $$TranscriptionsTableAnnotationComposer get transcriptionId {
    final $$TranscriptionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transcriptionId,
        referencedTable: $db.transcriptions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranscriptionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transcriptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TranscriptionSegmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TranscriptionSegmentsTable,
    TranscriptionSegment,
    $$TranscriptionSegmentsTableFilterComposer,
    $$TranscriptionSegmentsTableOrderingComposer,
    $$TranscriptionSegmentsTableAnnotationComposer,
    $$TranscriptionSegmentsTableCreateCompanionBuilder,
    $$TranscriptionSegmentsTableUpdateCompanionBuilder,
    (TranscriptionSegment, $$TranscriptionSegmentsTableReferences),
    TranscriptionSegment,
    PrefetchHooks Function({bool transcriptionId})> {
  $$TranscriptionSegmentsTableTableManager(
      _$AppDatabase db, $TranscriptionSegmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranscriptionSegmentsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$TranscriptionSegmentsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranscriptionSegmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> transcriptionId = const Value.absent(),
            Value<String> speakerLabel = const Value.absent(),
            Value<int> startTimeMs = const Value.absent(),
            Value<int> endTimeMs = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TranscriptionSegmentsCompanion(
            id: id,
            transcriptionId: transcriptionId,
            speakerLabel: speakerLabel,
            startTimeMs: startTimeMs,
            endTimeMs: endTimeMs,
            content: content,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String transcriptionId,
            required String speakerLabel,
            required int startTimeMs,
            required int endTimeMs,
            required String content,
            required int orderIndex,
            Value<int> rowid = const Value.absent(),
          }) =>
              TranscriptionSegmentsCompanion.insert(
            id: id,
            transcriptionId: transcriptionId,
            speakerLabel: speakerLabel,
            startTimeMs: startTimeMs,
            endTimeMs: endTimeMs,
            content: content,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TranscriptionSegmentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({transcriptionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (transcriptionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.transcriptionId,
                    referencedTable: $$TranscriptionSegmentsTableReferences
                        ._transcriptionIdTable(db),
                    referencedColumn: $$TranscriptionSegmentsTableReferences
                        ._transcriptionIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TranscriptionSegmentsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $TranscriptionSegmentsTable,
        TranscriptionSegment,
        $$TranscriptionSegmentsTableFilterComposer,
        $$TranscriptionSegmentsTableOrderingComposer,
        $$TranscriptionSegmentsTableAnnotationComposer,
        $$TranscriptionSegmentsTableCreateCompanionBuilder,
        $$TranscriptionSegmentsTableUpdateCompanionBuilder,
        (TranscriptionSegment, $$TranscriptionSegmentsTableReferences),
        TranscriptionSegment,
        PrefetchHooks Function({bool transcriptionId})>;
typedef $$SpeakerMappingsTableCreateCompanionBuilder = SpeakerMappingsCompanion
    Function({
  required String id,
  required String transcriptionId,
  required String originalLabel,
  required String customName,
  Value<int> rowid,
});
typedef $$SpeakerMappingsTableUpdateCompanionBuilder = SpeakerMappingsCompanion
    Function({
  Value<String> id,
  Value<String> transcriptionId,
  Value<String> originalLabel,
  Value<String> customName,
  Value<int> rowid,
});

final class $$SpeakerMappingsTableReferences extends BaseReferences<
    _$AppDatabase, $SpeakerMappingsTable, SpeakerMapping> {
  $$SpeakerMappingsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TranscriptionsTable _transcriptionIdTable(_$AppDatabase db) =>
      db.transcriptions.createAlias($_aliasNameGenerator(
          db.speakerMappings.transcriptionId, db.transcriptions.id));

  $$TranscriptionsTableProcessedTableManager get transcriptionId {
    final $_column = $_itemColumn<String>('transcription_id')!;

    final manager = $$TranscriptionsTableTableManager($_db, $_db.transcriptions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transcriptionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SpeakerMappingsTableFilterComposer
    extends Composer<_$AppDatabase, $SpeakerMappingsTable> {
  $$SpeakerMappingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalLabel => $composableBuilder(
      column: $table.originalLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customName => $composableBuilder(
      column: $table.customName, builder: (column) => ColumnFilters(column));

  $$TranscriptionsTableFilterComposer get transcriptionId {
    final $$TranscriptionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transcriptionId,
        referencedTable: $db.transcriptions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranscriptionsTableFilterComposer(
              $db: $db,
              $table: $db.transcriptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SpeakerMappingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SpeakerMappingsTable> {
  $$SpeakerMappingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalLabel => $composableBuilder(
      column: $table.originalLabel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customName => $composableBuilder(
      column: $table.customName, builder: (column) => ColumnOrderings(column));

  $$TranscriptionsTableOrderingComposer get transcriptionId {
    final $$TranscriptionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transcriptionId,
        referencedTable: $db.transcriptions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranscriptionsTableOrderingComposer(
              $db: $db,
              $table: $db.transcriptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SpeakerMappingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpeakerMappingsTable> {
  $$SpeakerMappingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get originalLabel => $composableBuilder(
      column: $table.originalLabel, builder: (column) => column);

  GeneratedColumn<String> get customName => $composableBuilder(
      column: $table.customName, builder: (column) => column);

  $$TranscriptionsTableAnnotationComposer get transcriptionId {
    final $$TranscriptionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transcriptionId,
        referencedTable: $db.transcriptions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TranscriptionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transcriptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SpeakerMappingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SpeakerMappingsTable,
    SpeakerMapping,
    $$SpeakerMappingsTableFilterComposer,
    $$SpeakerMappingsTableOrderingComposer,
    $$SpeakerMappingsTableAnnotationComposer,
    $$SpeakerMappingsTableCreateCompanionBuilder,
    $$SpeakerMappingsTableUpdateCompanionBuilder,
    (SpeakerMapping, $$SpeakerMappingsTableReferences),
    SpeakerMapping,
    PrefetchHooks Function({bool transcriptionId})> {
  $$SpeakerMappingsTableTableManager(
      _$AppDatabase db, $SpeakerMappingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeakerMappingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeakerMappingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeakerMappingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> transcriptionId = const Value.absent(),
            Value<String> originalLabel = const Value.absent(),
            Value<String> customName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SpeakerMappingsCompanion(
            id: id,
            transcriptionId: transcriptionId,
            originalLabel: originalLabel,
            customName: customName,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String transcriptionId,
            required String originalLabel,
            required String customName,
            Value<int> rowid = const Value.absent(),
          }) =>
              SpeakerMappingsCompanion.insert(
            id: id,
            transcriptionId: transcriptionId,
            originalLabel: originalLabel,
            customName: customName,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SpeakerMappingsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({transcriptionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (transcriptionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.transcriptionId,
                    referencedTable: $$SpeakerMappingsTableReferences
                        ._transcriptionIdTable(db),
                    referencedColumn: $$SpeakerMappingsTableReferences
                        ._transcriptionIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SpeakerMappingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SpeakerMappingsTable,
    SpeakerMapping,
    $$SpeakerMappingsTableFilterComposer,
    $$SpeakerMappingsTableOrderingComposer,
    $$SpeakerMappingsTableAnnotationComposer,
    $$SpeakerMappingsTableCreateCompanionBuilder,
    $$SpeakerMappingsTableUpdateCompanionBuilder,
    (SpeakerMapping, $$SpeakerMappingsTableReferences),
    SpeakerMapping,
    PrefetchHooks Function({bool transcriptionId})>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TranscriptionsTableTableManager get transcriptions =>
      $$TranscriptionsTableTableManager(_db, _db.transcriptions);
  $$TranscriptionSegmentsTableTableManager get transcriptionSegments =>
      $$TranscriptionSegmentsTableTableManager(_db, _db.transcriptionSegments);
  $$SpeakerMappingsTableTableManager get speakerMappings =>
      $$SpeakerMappingsTableTableManager(_db, _db.speakerMappings);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
