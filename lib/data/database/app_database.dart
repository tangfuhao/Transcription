import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/transcriptions.dart';
import 'tables/segments.dart';
import 'tables/speaker_mappings.dart';
import 'tables/settings.dart';

part 'app_database.g.dart';

/// 應用數據庫
@DriftDatabase(
  tables: [
    Transcriptions,
    TranscriptionSegments,
    SpeakerMappings,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();

          // 創建 FTS5 全文搜索虛擬表
          await customStatement('''
            CREATE VIRTUAL TABLE IF NOT EXISTS segments_fts USING fts5(
              text,
              content='transcription_segments',
              content_rowid='rowid'
            );
          ''');

          // 觸發器：插入時同步到 FTS
          await customStatement('''
            CREATE TRIGGER IF NOT EXISTS segments_ai AFTER INSERT ON transcription_segments BEGIN
              INSERT INTO segments_fts(rowid, text) VALUES (new.rowid, new.text);
            END;
          ''');

          // 觸發器：刪除時同步到 FTS
          await customStatement('''
            CREATE TRIGGER IF NOT EXISTS segments_ad AFTER DELETE ON transcription_segments BEGIN
              INSERT INTO segments_fts(segments_fts, rowid, text) 
              VALUES('delete', old.rowid, old.text);
            END;
          ''');

          // 觸發器：更新時同步到 FTS
          await customStatement('''
            CREATE TRIGGER IF NOT EXISTS segments_au AFTER UPDATE ON transcription_segments BEGIN
              INSERT INTO segments_fts(segments_fts, rowid, text) 
              VALUES('delete', old.rowid, old.text);
              INSERT INTO segments_fts(rowid, text) VALUES (new.rowid, new.text);
            END;
          ''');
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // 從版本 1 升級到版本 2：添加 audio_file_path 欄位
          if (from < 2) {
            await customStatement('''
              ALTER TABLE transcriptions ADD COLUMN audio_file_path TEXT;
            ''');
          }
        },
      );

  // ==================== Transcriptions ====================

  /// 獲取所有轉錄記錄
  Future<List<Transcription>> getAllTranscriptions() {
    return (select(transcriptions)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// 獲取單個轉錄記錄
  Future<Transcription?> getTranscription(String id) {
    return (select(transcriptions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// 插入轉錄記錄
  Future<void> insertTranscription(TranscriptionsCompanion entry) {
    return into(transcriptions).insert(entry);
  }

  /// 更新轉錄記錄
  Future<void> updateTranscription(TranscriptionsCompanion entry) {
    return (update(transcriptions)..where((t) => t.id.equals(entry.id.value)))
        .write(entry);
  }

  /// 刪除轉錄記錄
  Future<void> deleteTranscription(String id) async {
    // 先刪除相關的片段和說話人映射
    await (delete(transcriptionSegments)
          ..where((s) => s.transcriptionId.equals(id)))
        .go();
    await (delete(speakerMappings)..where((m) => m.transcriptionId.equals(id)))
        .go();
    // 再刪除轉錄記錄
    await (delete(transcriptions)..where((t) => t.id.equals(id))).go();
  }

  // ==================== Segments ====================

  /// 獲取轉錄的所有片段
  Future<List<TranscriptionSegment>> getSegments(String transcriptionId) {
    return (select(transcriptionSegments)
          ..where((s) => s.transcriptionId.equals(transcriptionId))
          ..orderBy([(s) => OrderingTerm.asc(s.orderIndex)]))
        .get();
  }

  /// 批量插入片段
  Future<void> insertSegments(
      List<TranscriptionSegmentsCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(transcriptionSegments, entries);
    });
  }

  /// 更新片段
  Future<void> updateSegment(TranscriptionSegmentsCompanion entry) {
    return (update(transcriptionSegments)
          ..where((s) => s.id.equals(entry.id.value)))
        .write(entry);
  }

  // ==================== Speaker Mappings ====================

  /// 獲取說話人映射
  Future<List<SpeakerMapping>> getSpeakerMappings(String transcriptionId) {
    return (select(speakerMappings)
          ..where((m) => m.transcriptionId.equals(transcriptionId)))
        .get();
  }

  /// 插入/更新說話人映射
  Future<void> upsertSpeakerMapping(SpeakerMappingsCompanion entry) {
    return into(speakerMappings).insertOnConflictUpdate(entry);
  }

  // ==================== Settings ====================

  /// 獲取設置值
  Future<String?> getSetting(String key) async {
    final result = await (select(appSettings)..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    return result?.value;
  }

  /// 設置值
  Future<void> setSetting(String key, String value) {
    return into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion(
        key: Value(key),
        value: Value(value),
      ),
    );
  }

  /// 刪除設置
  Future<void> deleteSetting(String key) {
    return (delete(appSettings)..where((s) => s.key.equals(key))).go();
  }

  // ==================== Search ====================

  /// 全文搜索（基礎版）
  Future<List<TranscriptionSegment>> searchSegments(String query) async {
    // 使用 raw query 進行 FTS 搜索
    final results = await customSelect(
      '''
      SELECT ts.* FROM transcription_segments ts
      INNER JOIN segments_fts fts ON ts.rowid = fts.rowid
      WHERE segments_fts MATCH ?
      ''',
      variables: [Variable.withString(query)],
      readsFrom: {transcriptionSegments},
    ).get();

    // 手動映射結果
    return results.map((row) {
      return TranscriptionSegment(
        id: row.read<String>('id'),
        transcriptionId: row.read<String>('transcription_id'),
        speakerLabel: row.read<String>('speaker_label'),
        startTimeMs: row.read<int>('start_time_ms'),
        endTimeMs: row.read<int>('end_time_ms'),
        content: row.read<String>('text'),
        orderIndex: row.read<int>('order_index'),
      );
    }).toList();
  }

  /// 全文搜索（包含轉錄信息）
  ///
  /// 使用 LIKE 查詢支持子字符串匹配，適用於中文等非空格分隔的語言
  /// 返回搜索結果及其所屬的轉錄記錄信息
  Future<List<SearchResult>> searchWithTranscriptionInfo(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return [];

    // 使用 LIKE 進行子字符串匹配（支持中文）
    // 轉義 LIKE 特殊字符
    final escapedQuery = _escapeForLike(trimmedQuery);
    final likePattern = '%$escapedQuery%';

    final results = await customSelect(
      '''
      SELECT 
        ts.id,
        ts.transcription_id,
        ts.speaker_label,
        ts.start_time_ms,
        ts.end_time_ms,
        ts.text as content,
        ts.order_index,
        t.title as transcription_title,
        t.created_at as transcription_created_at,
        t.language_code as transcription_language_code
      FROM transcription_segments ts
      INNER JOIN transcriptions t ON ts.transcription_id = t.id
      WHERE ts.text LIKE ? ESCAPE '\\'
      ORDER BY t.created_at DESC, ts.order_index ASC
      LIMIT 50
      ''',
      variables: [Variable.withString(likePattern)],
      readsFrom: {transcriptionSegments, transcriptions},
    ).get();

    return results.map((row) {
      return SearchResult(
        segment: TranscriptionSegment(
          id: row.read<String>('id'),
          transcriptionId: row.read<String>('transcription_id'),
          speakerLabel: row.read<String>('speaker_label'),
          startTimeMs: row.read<int>('start_time_ms'),
          endTimeMs: row.read<int>('end_time_ms'),
          content: row.read<String>('content'),
          orderIndex: row.read<int>('order_index'),
        ),
        transcriptionTitle: row.read<String?>('transcription_title'),
        transcriptionCreatedAt: row.read<int>('transcription_created_at'),
        transcriptionLanguageCode: row.read<String>('transcription_language_code'),
      );
    }).toList();
  }

  /// 轉義 LIKE 查詢中的特殊字符
  ///
  /// 處理 %, _, \ 等 LIKE 運算符的特殊字符
  String _escapeForLike(String query) {
    return query
        .replaceAll('\\', '\\\\') // 先轉義反斜線
        .replaceAll('%', '\\%')   // 轉義百分號
        .replaceAll('_', '\\_');  // 轉義下劃線
  }
}

/// 搜索結果模型
/// 
/// 包含匹配的片段及其所屬轉錄的信息
class SearchResult {
  final TranscriptionSegment segment;
  final String? transcriptionTitle;
  final int transcriptionCreatedAt;
  final String transcriptionLanguageCode;

  const SearchResult({
    required this.segment,
    required this.transcriptionTitle,
    required this.transcriptionCreatedAt,
    required this.transcriptionLanguageCode,
  });

  /// 獲取顯示標題
  String get displayTitle {
    if (transcriptionTitle != null && transcriptionTitle!.isNotEmpty) {
      return transcriptionTitle!;
    }
    return '未命名轉錄';
  }

  /// 獲取格式化的創建時間
  String get formattedDate {
    final date = DateTime.fromMillisecondsSinceEpoch(transcriptionCreatedAt * 1000);
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'macaron.db'));
    return NativeDatabase.createInBackground(file);
  });
}
