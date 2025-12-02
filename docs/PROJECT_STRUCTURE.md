# Macaron Transcription - 項目結構

> 版本：2.0.0  
> 更新日期：2025-12-02

---

## 📁 項目結構

```
macaron_transcription/
│
├── 📁 lib/                              # Flutter 主代碼
│   │
│   ├── 📄 main.dart                     # 應用入口
│   │
│   ├── 📁 app/                          # 應用配置
│   │   ├── app.dart                      # MaterialApp 配置
│   │   ├── router.dart                   # 路由配置 (go_router)
│   │   └── theme.dart                    # 主題配置
│   │
│   ├── 📁 core/                         # 核心工具
│   │   ├── constants.dart                # 常量定義
│   │   ├── extensions.dart               # 擴展方法
│   │   └── utils.dart                    # 工具函數
│   │
│   ├── 📁 data/                         # 數據層
│   │   ├── 📁 database/
│   │   │   ├── app_database.dart         # drift 數據庫
│   │   │   ├── app_database.g.dart       # 生成文件
│   │   │   └── 📁 tables/
│   │   │       ├── transcriptions.dart
│   │   │       ├── segments.dart
│   │   │       ├── speaker_mappings.dart
│   │   │       └── settings.dart
│   │   │
│   │   ├── 📁 models/
│   │   │   ├── transcription_model.dart
│   │   │   ├── segment_model.dart
│   │   │   └── transcription_model.freezed.dart
│   │   │
│   │   └── 📁 repositories/
│   │       ├── transcription_repository.dart
│   │       └── settings_repository.dart
│   │
│   ├── 📁 services/                     # 服務層
│   │   ├── assemblyai_service.dart       # AssemblyAI API
│   │   ├── audio_recorder_service.dart   # 音頻錄製
│   │   ├── transcription_manager.dart    # 轉錄管理
│   │   └── api_key_service.dart          # API Key 管理
│   │
│   ├── 📁 presentation/                 # 表現層
│   │   ├── 📁 providers/                # Riverpod 狀態
│   │   │   ├── transcription_provider.dart
│   │   │   ├── home_provider.dart
│   │   │   ├── settings_provider.dart
│   │   │   └── providers.dart
│   │   │
│   │   ├── 📁 pages/
│   │   │   ├── 📁 home/
│   │   │   │   ├── home_page.dart
│   │   │   │   └── 📁 widgets/
│   │   │   │       ├── transcription_list.dart
│   │   │   │       ├── transcription_card.dart
│   │   │   │       └── search_bar.dart
│   │   │   │
│   │   │   ├── 📁 transcription/
│   │   │   │   ├── transcription_page.dart
│   │   │   │   └── 📁 widgets/
│   │   │   │       ├── live_transcript_view.dart
│   │   │   │       ├── segment_bubble.dart
│   │   │   │       ├── recording_timer.dart
│   │   │   │       └── control_bar.dart
│   │   │   │
│   │   │   ├── 📁 detail/
│   │   │   │   ├── detail_page.dart
│   │   │   │   └── 📁 widgets/
│   │   │   │       ├── editable_segment.dart
│   │   │   │       └── speaker_rename_dialog.dart
│   │   │   │
│   │   │   ├── 📁 settings/
│   │   │   │   ├── settings_page.dart
│   │   │   │   └── 📁 widgets/
│   │   │   │       ├── api_key_section.dart
│   │   │   │       └── language_selector.dart
│   │   │   │
│   │   │   └── 📁 onboarding/
│   │   │       └── api_key_setup_page.dart
│   │   │
│   │   └── 📁 widgets/                  # 共用組件
│   │       ├── confirm_dialog.dart
│   │       ├── loading_overlay.dart
│   │       └── speaker_avatar.dart
│   │
│   └── 📁 l10n/                         # 國際化 (可選)
│       ├── app_en.arb
│       └── app_zh.arb
│
├── 📁 assets/                           # 資源文件
│   └── 📁 images/
│       └── logo.png
│
├── 📁 docs/                             # 文檔
│   ├── TECHNICAL_DESIGN.md
│   └── PROJECT_STRUCTURE.md
│
├── 📁 test/                             # 測試
│   ├── 📁 services/
│   ├── 📁 repositories/
│   └── 📁 widgets/
│
├── 📄 pubspec.yaml                      # 依賴配置
├── 📄 analysis_options.yaml             # Lint 配置
├── 📄 .gitignore
└── 📄 README.md
```

---

## 📦 依賴配置

```yaml
# pubspec.yaml

name: macaron_transcription
description: Macaron Transcription - 實時語音轉錄應用

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # UI
  cupertino_icons: ^1.0.6
  
  # 狀態管理
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  
  # 路由
  go_router: ^13.0.0
  
  # 數據庫
  drift: ^2.14.1
  sqlite3_flutter_libs: ^0.5.18
  path_provider: ^2.1.1
  path: ^1.8.3
  
  # 網絡
  web_socket_channel: ^2.4.0
  http: ^1.1.0
  
  # 安全存儲
  flutter_secure_storage: ^9.0.0
  
  # 權限
  permission_handler: ^11.1.0
  
  # 音頻錄製
  record: ^5.0.4
  
  # 工具
  uuid: ^4.2.1
  intl: ^0.18.1
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  equatable: ^2.0.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # 代碼生成
  build_runner: ^2.4.7
  drift_dev: ^2.14.1
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  riverpod_generator: ^2.3.9
  
  # Lint
  flutter_lints: ^3.0.1
  
  # 測試
  mocktail: ^1.0.1

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
```

---

## 🏗️ 架構說明

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           Presentation Layer                                │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                         │
│  │    Pages    │  │   Widgets   │  │  Providers  │                         │
│  └──────┬──────┘  └─────────────┘  └──────┬──────┘                         │
│         │                                 │                                 │
│         └─────────────────────────────────┘                                 │
│                           │                                                 │
├───────────────────────────┼─────────────────────────────────────────────────┤
│                           ▼                                                 │
│                      Service Layer                                          │
│  ┌───────────────────┐  ┌───────────────────┐  ┌───────────────────────┐   │
│  │  AssemblyAI       │  │  AudioRecorder    │  │  TranscriptionManager │   │
│  │  Service          │  │  Service          │  │                       │   │
│  └─────────┬─────────┘  └───────────────────┘  └───────────────────────┘   │
│            │                                                                │
│            │  WebSocket                                                     │
│            ▼                                                                │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │                        AssemblyAI Cloud                               │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────────┤
│                           Data Layer                                        │
│  ┌───────────────────┐  ┌───────────────────┐                              │
│  │   Repositories    │  │   Database        │                              │
│  │                   │  │   (drift + SQLite)│                              │
│  └───────────────────┘  └───────────────────┘                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🎨 主題配置

```dart
// lib/app/theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // Macaron 品牌色
  static const Color primaryColor = Color(0xFFE8A0BF);      // 馬卡龍粉
  static const Color secondaryColor = Color(0xFFBA90C6);    // 馬卡龍紫
  static const Color accentColor = Color(0xFFC0DBEA);       // 馬卡龍藍
  static const Color surfaceColor = Color(0xFFFDF4F5);      // 奶油白
  
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: surfaceColor,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
  
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
    ),
  );
}
```

---

## 🔗 路由配置

```dart
// lib/app/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/transcription/transcription_page.dart';
import '../presentation/pages/detail/detail_page.dart';
import '../presentation/pages/settings/settings_page.dart';
import '../presentation/pages/onboarding/api_key_setup_page.dart';
import '../services/api_key_service.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      // 檢查是否有 API Key
      final hasApiKey = await ApiKeyService.getApiKey() != null;
      final isOnboarding = state.matchedLocation == '/onboarding';
      
      if (!hasApiKey && !isOnboarding) {
        return '/onboarding';
      }
      if (hasApiKey && isOnboarding) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const ApiKeySetupPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/transcription',
        builder: (context, state) {
          final language = state.extra as String?;
          return TranscriptionPage(languageCode: language);
        },
      ),
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailPage(transcriptionId: id);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
});
```

---

## 🗃️ 數據庫配置

```dart
// lib/data/database/app_database.dart

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
  int get schemaVersion => 1;
  
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      
      // 創建 FTS5 全文搜索表
      await customStatement('''
        CREATE VIRTUAL TABLE IF NOT EXISTS segments_fts USING fts5(
          text,
          content='transcription_segments',
          content_rowid='rowid'
        );
      ''');
      
      // 觸發器：同步更新 FTS
      await customStatement('''
        CREATE TRIGGER segments_ai AFTER INSERT ON transcription_segments BEGIN
          INSERT INTO segments_fts(rowid, text) VALUES (new.rowid, new.text);
        END;
      ''');
      
      await customStatement('''
        CREATE TRIGGER segments_ad AFTER DELETE ON transcription_segments BEGIN
          INSERT INTO segments_fts(segments_fts, rowid, text) 
          VALUES('delete', old.rowid, old.text);
        END;
      ''');
      
      await customStatement('''
        CREATE TRIGGER segments_au AFTER UPDATE ON transcription_segments BEGIN
          INSERT INTO segments_fts(segments_fts, rowid, text) 
          VALUES('delete', old.rowid, old.text);
          INSERT INTO segments_fts(rowid, text) VALUES (new.rowid, new.text);
        END;
      ''');
    },
  );
  
  /// 全文搜索
  Future<List<TranscriptionSegment>> searchSegments(String query) async {
    return customSelect(
      '''
      SELECT s.* FROM transcription_segments s
      WHERE s.rowid IN (
        SELECT rowid FROM segments_fts WHERE segments_fts MATCH ?
      )
      ''',
      variables: [Variable.withString(query)],
      readsFrom: {transcriptionSegments},
    ).map((row) => TranscriptionSegment.fromData(row.data)).get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'macaron.db'));
    return NativeDatabase.createInBackground(file);
  });
}
```

---

## 📄 表定義

```dart
// lib/data/database/tables/transcriptions.dart

import 'package:drift/drift.dart';

class Transcriptions extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get durationMs => integer()();
  TextColumn get languageCode => text()();
  IntColumn get speakerCount => integer()();
  
  @override
  Set<Column> get primaryKey => {id};
}
```

```dart
// lib/data/database/tables/segments.dart

import 'package:drift/drift.dart';
import 'transcriptions.dart';

class TranscriptionSegments extends Table {
  TextColumn get id => text()();
  TextColumn get transcriptionId => text().references(Transcriptions, #id)();
  TextColumn get speakerLabel => text()();
  IntColumn get startTimeMs => integer()();
  IntColumn get endTimeMs => integer()();
  TextColumn get text => text()();
  IntColumn get orderIndex => integer()();
  
  @override
  Set<Column> get primaryKey => {id};
}
```

```dart
// lib/data/database/tables/speaker_mappings.dart

import 'package:drift/drift.dart';
import 'transcriptions.dart';

class SpeakerMappings extends Table {
  TextColumn get id => text()();
  TextColumn get transcriptionId => text().references(Transcriptions, #id)();
  TextColumn get originalLabel => text()();  // "A", "B"
  TextColumn get customName => text()();     // "張三"
  
  @override
  Set<Column> get primaryKey => {id};
}
```

---

## 🚀 快速開始

### 1. 創建項目

```bash
flutter create --org com.macaron macaron_transcription
cd macaron_transcription
```

### 2. 複製依賴配置

將上述 `pubspec.yaml` 內容替換到項目中。

### 3. 安裝依賴

```bash
flutter pub get
```

### 4. 創建目錄結構

```bash
mkdir -p lib/{app,core,data/{database/tables,models,repositories},services,presentation/{providers,pages/{home,transcription,detail,settings,onboarding}/widgets,widgets}}
mkdir -p assets/images
mkdir -p docs
```

### 5. 生成代碼

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 6. 運行

```bash
flutter run
```

---

## 📝 開發 Checklist

### Phase 1: 項目搭建 (3天)
- [ ] 創建 Flutter 項目
- [ ] 配置 pubspec.yaml
- [ ] 創建目錄結構
- [ ] 配置主題 (theme.dart)
- [ ] 配置路由 (router.dart)
- [ ] 配置數據庫 (app_database.dart)
- [ ] 主頁 UI 骨架
- [ ] 設置頁 UI 骨架

### Phase 2: AssemblyAI 整合 (4天)
- [ ] API Key 輸入/存儲
- [ ] AssemblyAI WebSocket 服務
- [ ] 音頻錄製服務
- [ ] 轉錄管理器
- [ ] 實時轉錄 UI
- [ ] 語言選擇

### Phase 3: 數據持久化 (3天)
- [ ] 保存轉錄
- [ ] 讀取轉錄列表
- [ ] FTS5 全文搜索
- [ ] 說話人名稱映射

### Phase 4: 編輯功能 (3天)
- [ ] 轉錄詳情頁
- [ ] 文字編輯
- [ ] 說話人重命名
- [ ] 刪除功能

### Phase 5: 完善發布 (2天)
- [ ] 錯誤處理
- [ ] 斷線重連
- [ ] UI 動畫
- [ ] 測試
- [ ] 發布準備

---

> **文檔維護者**：Development Team  
> **最後更新**：2025-12-02
