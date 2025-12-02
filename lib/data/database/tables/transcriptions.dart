import 'package:drift/drift.dart';

/// 轉錄記錄表
class Transcriptions extends Table {
  /// 唯一標識
  TextColumn get id => text()();

  /// 標題
  TextColumn get title => text().nullable()();

  /// 創建時間 (Unix timestamp)
  IntColumn get createdAt => integer()();

  /// 更新時間 (Unix timestamp)
  IntColumn get updatedAt => integer()();

  /// 時長 (毫秒)
  IntColumn get durationMs => integer()();

  /// 語言代碼
  TextColumn get languageCode => text()();

  /// 說話人數量
  IntColumn get speakerCount => integer()();

  /// 音頻文件路徑（可選，用於播放源音頻）
  TextColumn get audioFilePath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

