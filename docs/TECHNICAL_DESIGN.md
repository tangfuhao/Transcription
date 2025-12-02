# Macaron Transcription - 技術設計文檔

> 版本：2.0.0  
> 更新日期：2025-12-02  
> 狀態：設計階段

---

## 📋 目錄

1. [項目概述](#1-項目概述)
2. [技術架構](#2-技術架構)
3. [AssemblyAI 整合](#3-assemblyai-整合)
4. [數據模型設計](#4-數據模型設計)
5. [UI/UX 設計](#5-uiux-設計)
6. [開發計劃](#6-開發計劃)

---

## 1. 項目概述

### 1.1 應用信息

| 項目 | 內容 |
|------|------|
| **應用名稱** | Macaron Transcription |
| **品牌** | Macaron |
| **核心功能** | 實時語音轉錄 + 說話人識別 |
| **目標平台** | iOS、Android |
| **開發框架** | Flutter |
| **雲服務** | AssemblyAI |

### 1.2 核心功能

- 🎙️ **實時轉錄**：邊說邊轉，即時查看結果
- 👥 **說話人識別**：自動區分會議中的不同說話人
- 🌍 **多語言支持**：用戶可選擇轉錄語言
- ✏️ **可編輯**：支持手動修正文字和說話人標記
- 🔍 **全文搜索**：快速找到歷史轉錄內容

### 1.3 技術棧

| 層級 | 技術選型 |
|------|----------|
| **UI 框架** | Flutter 3.x |
| **狀態管理** | Riverpod |
| **路由** | go_router |
| **數據庫** | SQLite + drift + FTS5 |
| **語音轉錄** | AssemblyAI (Real-time API) |
| **網絡** | WebSocket + HTTP |

---

## 2. 技術架構

### 2.1 系統架構圖

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              Flutter App                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   UI/UX     │  │   State     │  │  Business   │  │   Data Repository   │ │
│  │   Widgets   │  │  Management │  │   Logic     │  │                     │ │
│  │             │  │  (Riverpod) │  │             │  │                     │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────────────┘ │
├─────────────────────────────────────────────────────────────────────────────┤
│                              Service Layer                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────┐  ┌─────────────────────┐  ┌─────────────────────┐  │
│  │  AudioRecorder      │  │  AssemblyAI         │  │  Storage            │  │
│  │  Service            │  │  Service            │  │  Service            │  │
│  │  (錄音 + 音頻流)     │  │  (WebSocket 轉錄)   │  │  (本地存儲)         │  │
│  └──────────┬──────────┘  └──────────┬──────────┘  └─────────────────────┘  │
│             │                        │                                       │
│             │    Audio Stream        │                                       │
│             └────────────────────────┘                                       │
│                                      │                                       │
├──────────────────────────────────────┼───────────────────────────────────────┤
│                                      ▼                                       │
│                         ┌─────────────────────────┐                         │
│                         │   AssemblyAI Cloud      │                         │
│                         │   (Real-time WebSocket) │                         │
│                         └─────────────────────────┘                         │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2.2 實時轉錄數據流

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                              實時轉錄流程                                     │
└──────────────────────────────────────────────────────────────────────────────┘

   ┌─────────────┐
   │   麥克風     │
   │  (16kHz)    │
   └──────┬──────┘
          │
          │ PCM Audio Stream
          ▼
   ┌─────────────┐         WebSocket          ┌─────────────────────────┐
   │   Flutter   │ ─────────────────────────▶ │     AssemblyAI          │
   │   App       │                            │     Real-time API       │
   │             │ ◀───────────────────────── │                         │
   └──────┬──────┘    Transcription Events    └─────────────────────────┘
          │
          │  Events:
          │  - PartialTranscript (即時，可能變化)
          │  - FinalTranscript (確定，不變)
          │  - SpeakerLabel (說話人標籤)
          │
          ▼
   ┌─────────────┐
   │   UI 更新    │
   │  (實時顯示)  │
   └─────────────┘
```

---

## 3. AssemblyAI 整合

### 3.1 API 概述

AssemblyAI 提供兩種轉錄方式：

| 方式 | 用途 | 說話人識別 |
|------|------|-----------|
| **Real-time (WebSocket)** | 實時轉錄 | ✅ 支持 |
| **Async (HTTP)** | 上傳音頻後處理 | ✅ 支持 |

我們使用 **Real-time API** 實現邊說邊轉。

### 3.2 Real-time API 流程

```
1. 建立 WebSocket 連接
   wss://api.assemblyai.com/v2/realtime/ws?sample_rate=16000

2. 發送音頻數據 (Base64 編碼)
   {"audio_data": "base64_encoded_audio"}

3. 接收轉錄結果
   {
     "message_type": "FinalTranscript",
     "text": "Hello world",
     "words": [
       {"text": "Hello", "start": 0, "end": 500, "speaker": "A"},
       {"text": "world", "start": 500, "end": 1000, "speaker": "A"}
     ]
   }

4. 結束時關閉連接
   {"terminate_session": true}
```

### 3.3 Flutter 服務實現

```dart
/// AssemblyAI 實時轉錄服務
class AssemblyAIService {
  static const String _baseUrl = 'wss://api.assemblyai.com/v2/realtime/ws';
  
  WebSocketChannel? _channel;
  final String _apiKey;
  
  final _transcriptController = StreamController<TranscriptEvent>.broadcast();
  Stream<TranscriptEvent> get transcriptStream => _transcriptController.stream;
  
  AssemblyAIService({required String apiKey}) : _apiKey = apiKey;
  
  /// 開始實時轉錄會話
  Future<void> startSession({
    int sampleRate = 16000,
    String? languageCode,
    bool speakerLabels = true,
  }) async {
    final params = {
      'sample_rate': sampleRate.toString(),
      if (languageCode != null) 'language_code': languageCode,
      'speaker_labels': speakerLabels.toString(),
    };
    
    final uri = Uri.parse(_baseUrl).replace(queryParameters: params);
    
    _channel = WebSocketChannel.connect(
      uri,
      headers: {'Authorization': _apiKey},
    );
    
    _channel!.stream.listen(
      _handleMessage,
      onError: _handleError,
      onDone: _handleDone,
    );
  }
  
  /// 發送音頻數據
  void sendAudio(Uint8List audioData) {
    if (_channel == null) return;
    
    final base64Audio = base64Encode(audioData);
    _channel!.sink.add(jsonEncode({'audio_data': base64Audio}));
  }
  
  /// 結束會話
  Future<void> endSession() async {
    if (_channel == null) return;
    
    _channel!.sink.add(jsonEncode({'terminate_session': true}));
    await _channel!.sink.close();
    _channel = null;
  }
  
  void _handleMessage(dynamic message) {
    final data = jsonDecode(message as String) as Map<String, dynamic>;
    final messageType = data['message_type'] as String;
    
    switch (messageType) {
      case 'PartialTranscript':
        _transcriptController.add(PartialTranscriptEvent(
          text: data['text'] as String,
        ));
        break;
        
      case 'FinalTranscript':
        final words = (data['words'] as List?)
            ?.map((w) => WordInfo(
                  text: w['text'] as String,
                  start: w['start'] as int,
                  end: w['end'] as int,
                  speaker: w['speaker'] as String?,
                ))
            .toList();
        
        _transcriptController.add(FinalTranscriptEvent(
          text: data['text'] as String,
          words: words ?? [],
        ));
        break;
        
      case 'SessionBegins':
        _transcriptController.add(SessionStartedEvent(
          sessionId: data['session_id'] as String,
        ));
        break;
        
      case 'SessionTerminated':
        _transcriptController.add(SessionEndedEvent());
        break;
    }
  }
  
  void dispose() {
    _channel?.sink.close();
    _transcriptController.close();
  }
}

/// 轉錄事件基類
sealed class TranscriptEvent {}

class SessionStartedEvent extends TranscriptEvent {
  final String sessionId;
  SessionStartedEvent({required this.sessionId});
}

class PartialTranscriptEvent extends TranscriptEvent {
  final String text;
  PartialTranscriptEvent({required this.text});
}

class FinalTranscriptEvent extends TranscriptEvent {
  final String text;
  final List<WordInfo> words;
  FinalTranscriptEvent({required this.text, required this.words});
}

class SessionEndedEvent extends TranscriptEvent {}

/// 詞信息
class WordInfo {
  final String text;
  final int start;  // 毫秒
  final int end;    // 毫秒
  final String? speaker;  // "A", "B", "C", ...
  
  WordInfo({
    required this.text,
    required this.start,
    required this.end,
    this.speaker,
  });
}
```

### 3.4 音頻錄製服務

```dart
/// 音頻錄製服務
class AudioRecorderService {
  static const int sampleRate = 16000;
  static const int channels = 1;
  static const int bitDepth = 16;
  
  final _audioStreamController = StreamController<Uint8List>.broadcast();
  Stream<Uint8List> get audioStream => _audioStreamController.stream;
  
  bool _isRecording = false;
  bool get isRecording => _isRecording;
  
  /// 開始錄音
  Future<void> startRecording() async {
    // 請求麥克風權限
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw Exception('Microphone permission denied');
    }
    
    _isRecording = true;
    
    // 使用平台原生錄音 (通過 Platform Channel 或音頻插件)
    // 將音頻數據流式發送到 _audioStreamController
    await _startNativeRecording();
  }
  
  /// 停止錄音
  Future<void> stopRecording() async {
    _isRecording = false;
    await _stopNativeRecording();
  }
  
  void dispose() {
    _audioStreamController.close();
  }
}
```

### 3.5 轉錄管理器（整合錄音和轉錄）

```dart
/// 轉錄管理器 - 協調錄音和轉錄服務
class TranscriptionManager {
  final AudioRecorderService _recorder;
  final AssemblyAIService _assemblyAI;
  
  StreamSubscription? _audioSubscription;
  StreamSubscription? _transcriptSubscription;
  
  final _stateController = StreamController<TranscriptionState>.broadcast();
  Stream<TranscriptionState> get stateStream => _stateController.stream;
  
  final List<TranscriptionSegment> _segments = [];
  List<TranscriptionSegment> get segments => List.unmodifiable(_segments);
  
  String? _currentPartialText;
  
  TranscriptionManager({
    required AudioRecorderService recorder,
    required AssemblyAIService assemblyAI,
  })  : _recorder = recorder,
        _assemblyAI = assemblyAI;
  
  /// 開始轉錄
  Future<void> start({String? languageCode}) async {
    // 1. 開始 AssemblyAI 會話
    await _assemblyAI.startSession(
      languageCode: languageCode,
      speakerLabels: true,
    );
    
    // 2. 監聽轉錄結果
    _transcriptSubscription = _assemblyAI.transcriptStream.listen(_handleTranscript);
    
    // 3. 開始錄音
    await _recorder.startRecording();
    
    // 4. 將音頻流發送到 AssemblyAI
    _audioSubscription = _recorder.audioStream.listen((audioData) {
      _assemblyAI.sendAudio(audioData);
    });
    
    _stateController.add(TranscriptionState.recording);
  }
  
  /// 停止轉錄
  Future<void> stop() async {
    await _audioSubscription?.cancel();
    await _recorder.stopRecording();
    await _assemblyAI.endSession();
    await _transcriptSubscription?.cancel();
    
    _stateController.add(TranscriptionState.stopped);
  }
  
  void _handleTranscript(TranscriptEvent event) {
    switch (event) {
      case PartialTranscriptEvent(:final text):
        _currentPartialText = text;
        _stateController.add(TranscriptionState.recording);
        break;
        
      case FinalTranscriptEvent(:final text, :final words):
        if (text.isEmpty) return;
        
        // 按說話人分組
        final grouped = _groupBySpeaker(words);
        for (final segment in grouped) {
          _segments.add(segment);
        }
        _currentPartialText = null;
        _stateController.add(TranscriptionState.recording);
        break;
        
      default:
        break;
    }
  }
  
  /// 將連續相同說話人的詞合併為片段
  List<TranscriptionSegment> _groupBySpeaker(List<WordInfo> words) {
    if (words.isEmpty) return [];
    
    final segments = <TranscriptionSegment>[];
    String? currentSpeaker = words.first.speaker;
    final buffer = StringBuffer();
    int startTime = words.first.start;
    int endTime = words.first.end;
    
    for (final word in words) {
      if (word.speaker != currentSpeaker) {
        // 保存當前片段
        segments.add(TranscriptionSegment(
          speaker: currentSpeaker ?? 'Unknown',
          text: buffer.toString().trim(),
          startTime: startTime,
          endTime: endTime,
        ));
        
        // 開始新片段
        currentSpeaker = word.speaker;
        buffer.clear();
        startTime = word.start;
      }
      
      buffer.write('${word.text} ');
      endTime = word.end;
    }
    
    // 保存最後一個片段
    if (buffer.isNotEmpty) {
      segments.add(TranscriptionSegment(
        speaker: currentSpeaker ?? 'Unknown',
        text: buffer.toString().trim(),
        startTime: startTime,
        endTime: endTime,
      ));
    }
    
    return segments;
  }
  
  void dispose() {
    _audioSubscription?.cancel();
    _transcriptSubscription?.cancel();
    _stateController.close();
  }
}

/// 轉錄狀態
enum TranscriptionState {
  idle,
  recording,
  stopped,
}

/// 轉錄片段
class TranscriptionSegment {
  final String speaker;
  final String text;
  final int startTime;  // 毫秒
  final int endTime;    // 毫秒
  
  TranscriptionSegment({
    required this.speaker,
    required this.text,
    required this.startTime,
    required this.endTime,
  });
}
```

### 3.6 支持的語言

AssemblyAI 支持的語言列表（用戶可選）：

```dart
/// 支持的語言
enum SupportedLanguage {
  auto('auto', '自動檢測'),
  english('en', 'English'),
  chinese('zh', '中文'),
  japanese('ja', '日本語'),
  korean('ko', '한국어'),
  spanish('es', 'Español'),
  french('fr', 'Français'),
  german('de', 'Deutsch'),
  italian('it', 'Italiano'),
  portuguese('pt', 'Português'),
  dutch('nl', 'Nederlands'),
  russian('ru', 'Русский'),
  // ... 更多語言
  ;
  
  final String code;
  final String displayName;
  
  const SupportedLanguage(this.code, this.displayName);
}
```

### 3.7 API Key 管理

```dart
/// API Key 安全存儲
class ApiKeyService {
  static const _storage = FlutterSecureStorage();
  static const _key = 'assemblyai_api_key';
  
  /// 保存 API Key
  static Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: _key, value: apiKey);
  }
  
  /// 獲取 API Key
  static Future<String?> getApiKey() async {
    return await _storage.read(key: _key);
  }
  
  /// 刪除 API Key
  static Future<void> deleteApiKey() async {
    await _storage.delete(key: _key);
  }
  
  /// 驗證 API Key
  static Future<bool> validateApiKey(String apiKey) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.assemblyai.com/v2/account'),
        headers: {'Authorization': apiKey},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
```

---

## 4. 數據模型設計

### 4.1 數據庫 Schema (drift)

```dart
// ==================== 轉錄記錄表 ====================
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

// ==================== 轉錄片段表 ====================
class TranscriptionSegments extends Table {
  TextColumn get id => text()();
  TextColumn get transcriptionId => text().references(Transcriptions, #id)();
  TextColumn get speakerLabel => text()();     // "Speaker A" 或用戶自定義 "張三"
  IntColumn get startTimeMs => integer()();
  IntColumn get endTimeMs => integer()();
  TextColumn get text => text()();
  IntColumn get orderIndex => integer()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// ==================== 說話人名稱映射表 ====================
// 用於存儲單次轉錄中的說話人名稱（A → 張三）
class SpeakerMappings extends Table {
  TextColumn get id => text()();
  TextColumn get transcriptionId => text().references(Transcriptions, #id)();
  TextColumn get originalLabel => text()();    // "A", "B", "C"
  TextColumn get customName => text()();       // "張三", "李四"
  
  @override
  Set<Column> get primaryKey => {id};
}

// ==================== 應用設置表 ====================
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  
  @override
  Set<Column> get primaryKey => {key};
}
```

### 4.2 FTS5 全文搜索

```sql
-- 創建 FTS5 虛擬表
CREATE VIRTUAL TABLE segments_fts USING fts5(
  text,
  content='transcription_segments',
  content_rowid='rowid'
);

-- 搜索示例
SELECT t.*, s.text, s.speaker_label
FROM transcriptions t
JOIN transcription_segments s ON s.transcription_id = t.id
WHERE s.rowid IN (
  SELECT rowid FROM segments_fts WHERE segments_fts MATCH '關鍵詞'
)
ORDER BY t.created_at DESC;
```

### 4.3 實體類

```dart
/// 轉錄記錄實體
@freezed
class Transcription with _$Transcription {
  const factory Transcription({
    required String id,
    String? title,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Duration duration,
    required String languageCode,
    required int speakerCount,
    @Default([]) List<Segment> segments,
    @Default({}) Map<String, String> speakerMappings,  // A → 張三
  }) = _Transcription;
  
  const Transcription._();
  
  /// 顯示標題
  String get displayTitle {
    if (title != null && title!.isNotEmpty) return title!;
    if (segments.isNotEmpty) {
      final firstText = segments.first.text;
      return firstText.length > 30 
          ? '${firstText.substring(0, 30)}...' 
          : firstText;
    }
    return '未命名轉錄';
  }
}

/// 轉錄片段實體
@freezed
class Segment with _$Segment {
  const factory Segment({
    required String id,
    required String speakerLabel,
    required int startTimeMs,
    required int endTimeMs,
    required String text,
    required int orderIndex,
  }) = _Segment;
  
  const Segment._();
  
  /// 格式化時間戳
  String get formattedTime {
    final seconds = startTimeMs ~/ 1000;
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
```

---

## 5. UI/UX 設計

### 5.1 頁面結構

```
lib/presentation/
├── pages/
│   ├── home/                    # 主頁 (轉錄列表)
│   │   ├── home_page.dart
│   │   └── widgets/
│   │       ├── transcription_list.dart
│   │       ├── transcription_card.dart
│   │       └── search_bar.dart
│   │
│   ├── transcription/           # 轉錄頁面 (實時)
│   │   ├── transcription_page.dart
│   │   └── widgets/
│   │       ├── live_transcript_view.dart
│   │       ├── segment_bubble.dart
│   │       ├── recording_timer.dart
│   │       └── control_bar.dart
│   │
│   ├── detail/                  # 轉錄詳情頁 (查看/編輯)
│   │   ├── detail_page.dart
│   │   └── widgets/
│   │       ├── editable_segment.dart
│   │       └── speaker_rename_dialog.dart
│   │
│   ├── settings/                # 設置頁
│   │   ├── settings_page.dart
│   │   └── widgets/
│   │       ├── api_key_input.dart
│   │       └── language_selector.dart
│   │
│   └── onboarding/              # 首次使用引導
│       └── api_key_setup_page.dart
```

### 5.2 頁面流程圖

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              App 啟動                                       │
└─────────────────────────────────┬───────────────────────────────────────────┘
                                  │
                      ┌───────────┴───────────┐
                      │                       │
               有 API Key?                沒有 API Key?
                      │                       │
                      ▼                       ▼
┌─────────────────────────────┐   ┌─────────────────────────────────────────┐
│         主頁 (HomePage)     │   │       API Key 設置頁                     │
│  ┌───────────────────────┐  │   │  ┌───────────────────────────────────┐  │
│  │  Macaron      [⚙️]    │  │   │  │  歡迎使用 Macaron                  │  │
│  ├───────────────────────┤  │   │  │                                   │  │
│  │  🔍 搜索...            │  │   │  │  請輸入您的 AssemblyAI API Key    │  │
│  ├───────────────────────┤  │   │  │  ┌─────────────────────────────┐  │  │
│  │                       │  │   │  │  │ sk-xxxxxxxxxxxxxxxx         │  │  │
│  │  [轉錄卡片 1]          │  │   │  │  └─────────────────────────────┘  │  │
│  │  [轉錄卡片 2]          │  │   │  │                                   │  │
│  │  ...                  │  │   │  │  [獲取 API Key]  [驗證並開始]     │  │
│  │                       │  │   │  └───────────────────────────────────┘  │
│  │       [🎙️]            │  │   └─────────────────────────────────────────┘
│  └───────────────────────┘  │
└──────────────┬──────────────┘
               │
          點擊 🎙️
               │
               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         語言選擇 (Bottom Sheet)                              │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │  選擇轉錄語言                                                          │  │
│  │                                                                       │  │
│  │  ○ 自動檢測                                                            │  │
│  │  ● English                                                            │  │
│  │  ○ 中文                                                                │  │
│  │  ○ 日本語                                                              │  │
│  │  ○ ...                                                                │  │
│  │                                                                       │  │
│  │  [取消]                                        [開始轉錄]              │  │
│  └───────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────┘
               │
         選擇後開始
               │
               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         轉錄頁面 (TranscriptionPage)                         │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │  ← 返回           實時轉錄              ⏱️ 00:05:32                    │  │
│  ├───────────────────────────────────────────────────────────────────────┤  │
│  │                                                                       │  │
│  │  ┌─────────────────────────────────────────────────────────────────┐  │  │
│  │  │  👤 Speaker A                                          0:12    │  │  │
│  │  │  ┌─────────────────────────────────────────────────────────┐   │  │  │
│  │  │  │  你好，我是小王，今天我們來討論一下項目進度。              │   │  │  │
│  │  │  └─────────────────────────────────────────────────────────┘   │  │  │
│  │  └─────────────────────────────────────────────────────────────────┘  │  │
│  │                                                                       │  │
│  │  ┌─────────────────────────────────────────────────────────────────┐  │  │
│  │  │  👤 Speaker B                                          0:35    │  │  │
│  │  │  ┌─────────────────────────────────────────────────────────┐   │  │  │
│  │  │  │  好的，我這邊的部分已經完成了 80%...                      │   │  │  │
│  │  │  └─────────────────────────────────────────────────────────┘   │  │  │
│  │  └─────────────────────────────────────────────────────────────────┘  │  │
│  │                                                                       │  │
│  │  ┌─────────────────────────────────────────────────────────────────┐  │  │
│  │  │  💬 正在輸入...                                                 │  │  │
│  │  │  ┌─────────────────────────────────────────────────────────┐   │  │  │
│  │  │  │  那我們接下來_                                           │   │  │  │
│  │  │  └─────────────────────────────────────────────────────────┘   │  │  │
│  │  └─────────────────────────────────────────────────────────────────┘  │  │
│  │                                                                       │  │
│  ├───────────────────────────────────────────────────────────────────────┤  │
│  │                                                                       │  │
│  │                            [ ⏹️ 停止 ]                                │  │
│  │                                                                       │  │
│  └───────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────┘
               │
          點擊停止
               │
               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         轉錄完成頁面                                         │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │  ← 返回           轉錄完成                             💾 保存        │  │
│  ├───────────────────────────────────────────────────────────────────────┤  │
│  │                                                                       │  │
│  │  標題: [週一團隊會議___________________________]                       │  │
│  │                                                                       │  │
│  │  ┌─────────────────────────────────────────────────────────────────┐  │  │
│  │  │  👤 Speaker A  [✏️ 重命名]                             0:12    │  │  │
│  │  │  ┌─────────────────────────────────────────────────────────┐   │  │  │
│  │  │  │  你好，我是小王，今天我們來討論一下項目進度。              │   │  │  │
│  │  │  └─────────────────────────────────────────────────────────┘   │  │  │
│  │  └─────────────────────────────────────────────────────────────────┘  │  │
│  │                                                                       │  │
│  │  ┌─────────────────────────────────────────────────────────────────┐  │  │
│  │  │  👤 Speaker B  [✏️ 重命名]                             0:35    │  │  │
│  │  │  ┌─────────────────────────────────────────────────────────┐   │  │  │
│  │  │  │  好的，我這邊的部分已經完成了 80%...                      │   │  │  │
│  │  │  └─────────────────────────────────────────────────────────┘   │  │  │
│  │  └─────────────────────────────────────────────────────────────────┘  │  │
│  │                                                                       │  │
│  │  (點擊文字可編輯)                                                     │  │
│  │                                                                       │  │
│  ├───────────────────────────────────────────────────────────────────────┤  │
│  │                                                                       │  │
│  │        [🎙️ 新轉錄]        [🗑️ 放棄]        [💾 保存]                │  │
│  │                                                                       │  │
│  └───────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 5.3 轉錄卡片設計

```
┌───────────────────────────────────────────────────────────────┐
│  📝 週一團隊會議                                               │
│                                                               │
│  🕐 2025/12/02 14:30  ·  ⏱️ 45分鐘  ·  👥 3人  ·  🌐 中文    │
│                                                               │
│  [小王] "我們需要討論一下項目進度，目前..."                      │
└───────────────────────────────────────────────────────────────┘
```

### 5.4 全局狀態

```dart
/// 轉錄會話狀態
@freezed
class TranscriptionSessionState with _$TranscriptionSessionState {
  const factory TranscriptionSessionState({
    @Default(SessionStatus.idle) SessionStatus status,
    @Default([]) List<Segment> segments,
    String? partialText,
    String? selectedLanguage,
    DateTime? startTime,
    @Default(Duration.zero) Duration duration,
    @Default(false) bool hasUnsavedChanges,
  }) = _TranscriptionSessionState;
}

enum SessionStatus {
  idle,       // 空閒
  connecting, // 正在連接
  recording,  // 錄音/轉錄中
  stopping,   // 正在停止
  stopped,    // 已停止（可編輯）
  saving,     // 正在保存
  error,      // 錯誤
}
```

---

## 6. 開發計劃

### 6.1 里程碑規劃

| 階段 | 目標 | 預估時間 |
|------|------|----------|
| **Phase 1** | 項目搭建 + 基礎 UI | 3 天 |
| **Phase 2** | AssemblyAI 整合 + 實時轉錄 | 4 天 |
| **Phase 3** | 數據持久化 + 搜索 | 3 天 |
| **Phase 4** | 編輯功能 + UI 完善 | 3 天 |
| **Phase 5** | 測試 + 發布準備 | 2 天 |

**總計：約 2-3 週**

### 6.2 Phase 1 詳細任務

- [ ] Flutter 項目初始化
- [ ] 依賴配置 (pubspec.yaml)
- [ ] 項目結構搭建
- [ ] 主題配置
- [ ] 路由配置
- [ ] 主頁 UI
- [ ] 設置頁 UI

### 6.3 Phase 2 詳細任務

- [ ] AssemblyAI 服務實現
- [ ] 音頻錄製服務
- [ ] 轉錄管理器
- [ ] 實時轉錄 UI
- [ ] 語言選擇功能
- [ ] API Key 輸入/驗證

### 6.4 Phase 3 詳細任務

- [ ] drift 數據庫配置
- [ ] DAO 實現
- [ ] Repository 實現
- [ ] FTS5 全文搜索
- [ ] 保存/讀取轉錄

### 6.5 Phase 4 詳細任務

- [ ] 轉錄詳情頁
- [ ] 文字編輯功能
- [ ] 說話人重命名
- [ ] 刪除功能
- [ ] UI 動畫和細節

### 6.6 Phase 5 詳細任務

- [ ] 錯誤處理優化
- [ ] 網絡斷線處理
- [ ] UI 測試
- [ ] 性能測試
- [ ] 發布準備

---

## 附錄

### A. AssemblyAI 定價

| 計費方式 | 價格 |
|----------|------|
| 實時轉錄 | $0.00011/秒 ≈ $0.40/小時 |
| 說話人識別 | 包含在實時轉錄中 |

**免費額度**：新用戶有 $50 免費額度

### B. 依賴列表

```yaml
dependencies:
  flutter:
    sdk: flutter
  
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
  
  # 工具
  uuid: ^4.2.1
  intl: ^0.18.1
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  
  # 音頻錄製
  record: ^5.0.4
```

### C. 參考資源

- [AssemblyAI Real-time API 文檔](https://www.assemblyai.com/docs/speech-to-text/real-time)
- [AssemblyAI Flutter SDK (如果有)](https://github.com/AssemblyAI/assemblyai-flutter)
- [drift 文檔](https://drift.simonbinder.eu/)

---

> **文檔維護者**：Development Team  
> **最後更新**：2025-12-02
