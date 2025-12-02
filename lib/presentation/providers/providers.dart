import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../data/database/app_database.dart';

/// 數據庫 Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// 轉錄列表 Provider
final transcriptionsProvider =
    FutureProvider<List<Transcription>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getAllTranscriptions();
});

/// 單個轉錄 Provider
final transcriptionProvider =
    FutureProvider.family<Transcription?, String>((ref, id) async {
  final db = ref.watch(databaseProvider);
  return db.getTranscription(id);
});

/// 轉錄片段 Provider
final segmentsProvider =
    FutureProvider.family<List<TranscriptionSegment>, String>((ref, id) async {
  final db = ref.watch(databaseProvider);
  return db.getSegments(id);
});

/// 搜索結果 Provider（基礎版）
final searchResultsProvider =
    FutureProvider.family<List<TranscriptionSegment>, String>(
        (ref, query) async {
  if (query.isEmpty) return [];
  final db = ref.watch(databaseProvider);
  return db.searchSegments(query);
});

/// 搜索結果 Provider（包含轉錄信息，用於主頁搜索）
final searchWithInfoProvider =
    FutureProvider.family<List<SearchResult>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  final db = ref.watch(databaseProvider);
  return db.searchWithTranscriptionInfo(query);
});

/// 默認語言設置 Provider
/// 
/// 返回值說明：
/// - `null`: 未設置默認語言，每次轉錄需要選擇
/// - `SupportedLanguage`: 已設置的默認語言
final defaultLanguageProvider = FutureProvider<SupportedLanguage?>((ref) async {
  final db = ref.watch(databaseProvider);
  final value = await db.getSetting(SettingsKeys.defaultLanguage);
  
  // 未設置或設置為「不設置默認值」
  if (value == null || value == SettingsKeys.noDefaultLanguage) {
    return null;
  }
  
  // 查找對應的語言枚舉
  try {
    return SupportedLanguage.values.firstWhere((lang) => lang.code == value);
  } catch (_) {
    // 找不到對應的語言（可能是舊數據），返回 null
    return null;
  }
});

/// 設置默認語言的 Notifier
class DefaultLanguageNotifier extends AsyncNotifier<SupportedLanguage?> {
  @override
  Future<SupportedLanguage?> build() async {
    final db = ref.watch(databaseProvider);
    final value = await db.getSetting(SettingsKeys.defaultLanguage);
    
    if (value == null || value == SettingsKeys.noDefaultLanguage) {
      return null;
    }
    
    try {
      return SupportedLanguage.values.firstWhere((lang) => lang.code == value);
    } catch (_) {
      return null;
    }
  }
  
  /// 設置默認語言
  /// 
  /// [language] 為 null 時表示「不設置默認值」
  Future<void> setDefaultLanguage(SupportedLanguage? language) async {
    final db = ref.read(databaseProvider);
    
    if (language == null) {
      await db.setSetting(SettingsKeys.defaultLanguage, SettingsKeys.noDefaultLanguage);
    } else {
      await db.setSetting(SettingsKeys.defaultLanguage, language.code);
    }
    
    // 更新狀態
    state = AsyncData(language);
    
    // 同時刷新 defaultLanguageProvider
    ref.invalidate(defaultLanguageProvider);
  }
}

final defaultLanguageNotifierProvider =
    AsyncNotifierProvider<DefaultLanguageNotifier, SupportedLanguage?>(
  DefaultLanguageNotifier.new,
);
