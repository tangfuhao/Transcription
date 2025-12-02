import 'dart:async';
import 'dart:typed_data';

/// 轉錄服務抽象介面
///
/// 定義轉錄服務的標準介面，可以由不同的實現類來提供具體功能。
/// 當前實現基於 Deepgram Streaming API
abstract class TranscriptionService {
  /// 轉錄事件流
  Stream<TranscriptEvent> get transcriptStream;

  /// 是否已連接
  bool get isConnected;

  /// 開始轉錄會話
  ///
  /// [apiKey] - Deepgram API Key
  /// [languageCode] - 語言代碼，null 或 'auto' 表示自動檢測
  /// [sampleRate] - 音頻採樣率，默認 16000 Hz
  /// [interimResults] - 是否返回即時結果，默認 true
  Future<void> startSession({
    required String apiKey,
    String? languageCode,
    int sampleRate,
    bool interimResults,
  });

  /// 發送音頻數據 (raw PCM binary)
  void sendAudio(Uint8List audioData);

  /// 結束會話
  Future<void> endSession();

  /// 釋放資源
  void dispose();
}

/// 轉錄服務錯誤
class TranscriptionServiceError implements Exception {
  final String message;
  final String? code;

  const TranscriptionServiceError(this.message, {this.code});

  @override
  String toString() => 'TranscriptionServiceError: $message';

  /// 獲取用戶友好的錯誤訊息
  String get userFriendlyMessage {
    switch (code) {
      case 'invalid_api_key':
      case 'authentication_failed':
        return '認證失敗，請檢查 API Key';
      case 'quota_exceeded':
        return '服務使用量已達上限，請稍後再試';
      case 'network_error':
        return '網絡連接失敗，請檢查網絡設置';
      case 'session_expired':
        return '會話已過期，請重新開始';
      case 'websocket_error':
        return 'WebSocket 連接錯誤';
      case 'language_not_supported':
        return '不支持的語言，請選擇其他語言';
      default:
        return '轉錄服務出現問題，請稍後再試';
    }
  }
}

/// 轉錄事件基類
sealed class TranscriptEvent {
  const TranscriptEvent();
}

/// 正在連接
class SessionConnectingEvent extends TranscriptEvent {
  const SessionConnectingEvent();
}

/// 會話開始
class SessionStartedEvent extends TranscriptEvent {
  final String sessionId;
  final DateTime? expiresAt;

  const SessionStartedEvent({
    required this.sessionId,
    this.expiresAt,
  });
}

/// 即時轉錄結果（partial，可能會變化）
class PartialTranscriptEvent extends TranscriptEvent {
  final String text;
  final String? detectedLanguage;

  const PartialTranscriptEvent({
    required this.text,
    this.detectedLanguage,
  });
}

/// 最終轉錄結果（final，不會變化）
class FinalTranscriptEvent extends TranscriptEvent {
  final String text;
  final List<WordInfo> words;
  final String? detectedLanguage;
  final double? confidence;

  const FinalTranscriptEvent({
    required this.text,
    required this.words,
    this.detectedLanguage,
    this.confidence,
  });
}

/// 會話結束
class SessionEndedEvent extends TranscriptEvent {
  final double? audioDurationSeconds;
  final double? sessionDurationSeconds;

  const SessionEndedEvent({
    this.audioDurationSeconds,
    this.sessionDurationSeconds,
  });
}

/// 錯誤事件
class ErrorEvent extends TranscriptEvent {
  final String message;
  final String? code;

  const ErrorEvent({
    required this.message,
    this.code,
  });
}

/// 詞信息
class WordInfo {
  final String text;
  final double start; // 毫秒
  final double end;   // 毫秒
  final double? confidence;
  final int? speaker; // Deepgram 用數字表示說話人 (0, 1, 2...)

  const WordInfo({
    required this.text,
    required this.start,
    required this.end,
    this.confidence,
    this.speaker,
  });

  /// 獲取說話人標籤（轉換為字母形式）
  String get speakerLabel {
    if (speaker == null) return 'A';
    return String.fromCharCode('A'.codeUnitAt(0) + speaker!);
  }
}
