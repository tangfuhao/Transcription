import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import 'transcription_service.dart';

/// 實時轉錄服務實現
///
/// 基於 Deepgram Streaming API
/// 文檔: https://developers.deepgram.com/reference/speech-to-text/listen-streaming
class RealtimeTranscriptionService implements TranscriptionService {
  /// Deepgram Streaming API 端點
  static const String _wsBaseUrl = 'wss://api.deepgram.com/v1/listen';

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _keepAliveTimer;

  final _transcriptController = StreamController<TranscriptEvent>.broadcast();

  @override
  Stream<TranscriptEvent> get transcriptStream => _transcriptController.stream;

  bool _isConnected = false;

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> startSession({
    required String apiKey,
    String? languageCode,
    int sampleRate = 16000,
    bool interimResults = true,
  }) async {
    if (_isConnected) {
      await endSession();
    }

    try {
      _transcriptController.add(const SessionConnectingEvent());

      // 判斷是否使用多語言自動檢測模式
      final isMultiLanguage = languageCode == null ||
          languageCode.isEmpty ||
          languageCode == 'multi' ||
          languageCode == 'auto';

      // 構建 WebSocket 連接參數
      // 參考: https://developers.deepgram.com/reference/speech-to-text/listen-streaming
      //
      // 模型選擇策略：
      // - 多語言自動檢測 → nova-3（支持特定語言的自動檢測）
      // - 手動指定語言 → nova-2（針對特定語言優化，準確率更高）
      //
      // endpointing 設置：
      // - 多語言模式: 100ms（官方推薦，用於代碼切換）
      // - 單語言模式: 300ms（標準設置）
      final queryParams = <String, String>{
        'model': isMultiLanguage ? 'nova-3' : 'nova-2',
        'sample_rate': sampleRate.toString(),
        'channels': '1', // 單聲道
        'encoding': 'linear16', // PCM 16-bit
        'punctuate': 'true', // 自動添加標點
        'interim_results': interimResults.toString(), // 即時結果
        'endpointing': isMultiLanguage ? '100' : '300', // 多語言用100ms，單語言用300ms
        'vad_events': 'true', // 語音活動檢測事件
        'smart_format': 'true', // 智能格式化（數字、日期等）
      };

      // 語言設置
      // 參考: https://developers.deepgram.com/docs/models-languages-overview
      if (isMultiLanguage) {
        // 多語言自動檢測模式（Nova-3）
        // 'multi' 會自動檢測並轉錄多種語言
        queryParams['language'] = 'multi';
      } else {
        // 手動指定語言模式（Nova-2）
        // 準確率更高，延遲更低
        queryParams['language'] = languageCode;
        // Nova-2 支持說話人分離
        queryParams['diarize'] = 'true';
      }

      final uri = Uri.parse(_wsBaseUrl).replace(queryParameters: queryParams);

      // 使用 IOWebSocketChannel 以支持自定義 headers
      _channel = IOWebSocketChannel.connect(
        uri,
        headers: {
          'Authorization': 'Token $apiKey',
        },
      );

      // 等待 WebSocket 連接完成
      await _channel!.ready;

      _subscription = _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDone,
      );

      _isConnected = true;

      // 啟動 KeepAlive 定時器（每 8 秒發送一次）
      _startKeepAliveTimer();
    } catch (e) {
      _isConnected = false;
      final error = TranscriptionServiceError(
        e.toString(),
        code: _getErrorCodeFromException(e),
      );
      _transcriptController.add(ErrorEvent(
        message: error.message,
        code: error.code,
      ));
      throw error;
    }
  }

  /// 啟動 KeepAlive 定時器
  void _startKeepAliveTimer() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (_isConnected && _channel != null) {
        try {
          // 發送 KeepAlive 消息保持連接
          final keepAlive = jsonEncode({'type': 'KeepAlive'});
          _channel!.sink.add(keepAlive);
        } catch (e) {
          // 忽略發送失敗
        }
      }
    });
  }

  /// 從異常獲取錯誤碼
  String _getErrorCodeFromException(dynamic e) {
    final message = e.toString().toLowerCase();
    if (message.contains('socketexception') ||
        message.contains('host lookup') ||
        message.contains('connection refused') ||
        message.contains('network') ||
        message.contains('failed host')) {
      return 'network_error';
    }
    if (message.contains('handshake') || message.contains('certificate')) {
      return 'ssl_error';
    }
    if (message.contains('401') || message.contains('unauthorized')) {
      return 'authentication_failed';
    }
    return 'connection_failed';
  }

  @override
  void sendAudio(Uint8List audioData) {
    if (!_isConnected || _channel == null) return;

    try {
      // Deepgram: 直接發送原始 binary 音頻數據
      _channel!.sink.add(audioData);
    } catch (e) {
      _transcriptController.add(ErrorEvent(
        message: e.toString(),
        code: 'send_failed',
      ));
    }
  }

  @override
  Future<void> endSession() async {
    if (!_isConnected) return;

    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;

    try {
      // Deepgram: 發送 CloseStream 消息
      if (_channel != null) {
        final closeMessage = jsonEncode({'type': 'CloseStream'});
        _channel!.sink.add(closeMessage);
      }

      // 等待一小段時間讓服務器處理
      await Future.delayed(const Duration(milliseconds: 200));

      await _channel?.sink.close();
    } finally {
      _isConnected = false;
      await _subscription?.cancel();
      _subscription = null;
      _channel = null;
    }
  }

  void _handleMessage(dynamic message) {
    try {
      // 消息可能是 String 或 binary
      if (message is! String) {
        return;
      }

      final data = jsonDecode(message) as Map<String, dynamic>;
      final messageType = data['type'] as String?;

      switch (messageType) {
        case 'Results':
          // 轉錄結果
          _handleResultsMessage(data);
          break;

        case 'Metadata':
          // 元數據（連接信息）
          final requestId = data['request_id'] as String? ?? '';
          _transcriptController.add(SessionStartedEvent(
            sessionId: requestId,
            expiresAt: null,
          ));
          break;

        case 'SpeechStarted':
          // 語音開始（VAD 事件）
          break;

        case 'UtteranceEnd':
          // 語句結束（VAD 事件）
          break;

        case 'Error':
          // 錯誤消息
          final errorMessage = data['message'] as String? ??
              data['description'] as String? ??
              'Unknown error';
          _transcriptController.add(ErrorEvent(
            message: errorMessage,
            code: _mapErrorCode(errorMessage),
          ));
          break;

        default:
          // 未知消息類型，忽略
          break;
      }
    } catch (e) {
      _transcriptController.add(ErrorEvent(
        message: 'Failed to parse message: $e',
        code: 'parse_error',
      ));
    }
  }

  /// 處理 Results 類型的消息
  void _handleResultsMessage(Map<String, dynamic> data) {
    final channel = data['channel'] as Map<String, dynamic>?;
    if (channel == null) return;

    final alternatives = channel['alternatives'] as List?;
    if (alternatives == null || alternatives.isEmpty) return;

    final firstAlt = alternatives[0] as Map<String, dynamic>;
    final transcript = firstAlt['transcript'] as String? ?? '';

    if (transcript.isEmpty) return;

    final isFinal = data['is_final'] as bool? ?? false;
    final speechFinal = data['speech_final'] as bool? ?? false;

    // 檢測語言
    String? detectedLanguage;
    final languages = firstAlt['languages'] as List?;
    if (languages != null && languages.isNotEmpty) {
      detectedLanguage = languages[0] as String?;
    }

    // 解析詞級別信息
    final wordsData = firstAlt['words'] as List?;
    List<WordInfo>? words;
    if (wordsData != null) {
      words = wordsData.map((w) {
        final wordMap = w as Map<String, dynamic>;
        return WordInfo(
          text: wordMap['punctuated_word'] as String? ??
              wordMap['word'] as String? ??
              '',
          start: ((wordMap['start'] as num?) ?? 0) * 1000,
          end: ((wordMap['end'] as num?) ?? 0) * 1000,
          confidence: (wordMap['confidence'] as num?)?.toDouble(),
          speaker: (wordMap['speaker'] as num?)?.toInt(),
        );
      }).toList();
    }

    // 發送事件
    if (isFinal || speechFinal) {
      _transcriptController.add(FinalTranscriptEvent(
        text: transcript,
        words: words ?? [],
        detectedLanguage: detectedLanguage,
        confidence: (firstAlt['confidence'] as num?)?.toDouble(),
      ));
    } else {
      _transcriptController.add(PartialTranscriptEvent(
        text: transcript,
        detectedLanguage: detectedLanguage,
      ));
    }
  }

  /// 將錯誤訊息映射為錯誤碼
  String _mapErrorCode(String error) {
    final lowerError = error.toLowerCase();
    if (lowerError.contains('authentication') ||
        lowerError.contains('api key') ||
        lowerError.contains('unauthorized') ||
        lowerError.contains('invalid credentials')) {
      return 'authentication_failed';
    }
    if (lowerError.contains('quota') ||
        lowerError.contains('limit') ||
        lowerError.contains('insufficient')) {
      return 'quota_exceeded';
    }
    if (lowerError.contains('expired')) {
      return 'session_expired';
    }
    if (lowerError.contains('language') ||
        lowerError.contains('not supported')) {
      return 'language_not_supported';
    }
    return 'unknown_error';
  }

  void _handleError(dynamic error) {
    _transcriptController.add(ErrorEvent(
      message: error.toString(),
      code: 'websocket_error',
    ));
    _isConnected = false;
  }

  void _handleDone() {
    _isConnected = false;
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;
    // 發送會話結束事件
    _transcriptController.add(const SessionEndedEvent());
  }

  @override
  void dispose() {
    _keepAliveTimer?.cancel();
    endSession();
    _transcriptController.close();
  }
}
