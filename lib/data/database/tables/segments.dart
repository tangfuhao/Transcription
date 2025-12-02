import 'package:drift/drift.dart';

import 'transcriptions.dart';

/// 轉錄片段表
class TranscriptionSegments extends Table {
  /// 唯一標識
  TextColumn get id => text()();

  /// 所屬轉錄記錄 ID
  TextColumn get transcriptionId => text().references(Transcriptions, #id)();

  /// 說話人標籤 (如 "Speaker A" 或自定義名稱)
  TextColumn get speakerLabel => text()();

  /// 開始時間 (毫秒)
  IntColumn get startTimeMs => integer()();

  /// 結束時間 (毫秒)
  IntColumn get endTimeMs => integer()();

  /// 文字內容
  TextColumn get content => text().named('text')();

  /// 排序索引
  IntColumn get orderIndex => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

