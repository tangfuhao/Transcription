import 'package:drift/drift.dart';

import 'transcriptions.dart';

/// 說話人名稱映射表
/// 用於存儲單次轉錄中的說話人自定義名稱 (A → 張三)
class SpeakerMappings extends Table {
  /// 唯一標識
  TextColumn get id => text()();

  /// 所屬轉錄記錄 ID
  TextColumn get transcriptionId => text().references(Transcriptions, #id)();

  /// 原始標籤 ("A", "B", "C")
  TextColumn get originalLabel => text()();

  /// 自定義名稱 ("張三")
  TextColumn get customName => text()();

  @override
  Set<Column> get primaryKey => {id};
}

