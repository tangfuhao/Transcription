import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../core/app_config.dart';
import '../data/models/transcription_model.dart';
import 'audio_recorder_service.dart';
import 'transcription_service.dart';
import 'realtime_transcription_service.dart';

/// 轉錄管理器 - 協調錄音和轉錄服務
///
/// 使用細粒度的 ValueNotifier 進行狀態管理，
/// 每個狀態獨立更新，避免不必要的 UI 重建。
class TranscriptionManager {
  final AudioRecorderService _recorder;
  final TranscriptionService _transcriptionService;

  StreamSubscription? _audioSubscription;
  StreamSubscription? _transcriptSubscription;
  Timer? _durationTimer;

  // ===== 細粒度狀態管理 =====
  // 每個狀態獨立更新，不會互相影響

  /// 會話狀態
  final statusNotifier = ValueNotifier<SessionStatus>(SessionStatus.idle);

  /// 錄音時長（每秒更新，不影響其他狀態）
  final durationNotifier = ValueNotifier<Duration>(Duration.zero);

  /// 已確認的轉錄片段列表（每句話完成時更新）
  final segmentsNotifier = ValueNotifier<List<SegmentEntity>>([]);

  /// 正在輸入的文字（高頻更新，獨立管理）
  final partialTextNotifier = ValueNotifier<String?>(null);

  /// 錯誤訊息
  final errorNotifier = ValueNotifier<String?>(null);

  /// 語言代碼
  final languageCodeNotifier = ValueNotifier<String?>(null);

  /// 是否有未保存的變更
  final hasUnsavedChangesNotifier = ValueNotifier<bool>(false);

  /// 音頻文件路徑
  String? _audioFilePath;
  String? get audioFilePath => _audioFilePath;

  /// 開始時間
  DateTime? _startTime;
  DateTime? get startTime => _startTime;

  TranscriptionManager({
    AudioRecorderService? recorder,
    TranscriptionService? transcriptionService,
  })  : _recorder = recorder ?? AudioRecorderService(),
        _transcriptionService =
            transcriptionService ?? RealtimeTranscriptionService();

  /// 開始轉錄
  Future<void> start({String? languageCode}) async {
    if (statusNotifier.value == SessionStatus.recording) return;

    // 重置狀態
    statusNotifier.value = SessionStatus.connecting;
    languageCodeNotifier.value = languageCode;
    segmentsNotifier.value = [];
    partialTextNotifier.value = null;
    errorNotifier.value = null;
    durationNotifier.value = Duration.zero;
    _startTime = DateTime.now();
    _audioFilePath = null;

    try {
      // 1. 檢查權限
      final hasPermission = await _recorder.checkPermission();
      if (!hasPermission) {
        final granted = await _recorder.requestPermission();
        if (!granted) {
          throw TranscriptionServiceError(
            '需要麥克風權限才能錄音',
            code: 'permission_denied',
          );
        }
      }

      // 2. 檢查 API Key 是否已配置
      if (!AppConfig.isApiKeyConfigured) {
        throw TranscriptionServiceError(
          '請先配置 Deepgram API Key。編譯時需添加參數：--dart-define=DEEPGRAM_API_KEY=your_key',
          code: 'configuration_error',
        );
      }

      // 3. 連接轉錄服務 (Deepgram API)
      await _transcriptionService.startSession(
        apiKey: AppConfig.transcriptionApiKey,
        languageCode: languageCode,
        sampleRate: 16000,
        interimResults: true,
      );

      // 4. 監聽轉錄結果
      _transcriptSubscription = _transcriptionService.transcriptStream.listen(
        _handleTranscriptEvent,
        onError: _handleError,
      );

      // 5. 開始錄音
      await _recorder.startRecording();

      // 6. 將音頻流發送到轉錄服務
      _audioSubscription = _recorder.audioStream.listen((audioData) {
        _transcriptionService.sendAudio(audioData);
      });

      // 7. 開始計時（獨立更新 duration，不影響其他狀態）
      _startDurationTimer();

      statusNotifier.value = SessionStatus.recording;
    } catch (e) {
      String errorMessage = '轉錄服務出現問題，請稍後再試';

      if (e is TranscriptionServiceError) {
        errorMessage = e.userFriendlyMessage;
      }

      statusNotifier.value = SessionStatus.error;
      errorNotifier.value = errorMessage;
      await _cleanup();
      rethrow;
    }
  }

  /// 停止轉錄
  Future<void> stop() async {
    if (statusNotifier.value != SessionStatus.recording) return;

    statusNotifier.value = SessionStatus.stopping;

    try {
      // 1. 停止錄音並獲取音頻文件路徑
      _audioFilePath = await _recorder.stopRecording();

      // 2. 停止發送音頻
      await _audioSubscription?.cancel();
      _audioSubscription = null;

      // 3. 等待足夠時間讓最後的轉錄結果返回
      // 這期間 _transcriptSubscription 仍在監聽
      await Future.delayed(const Duration(milliseconds: 1000));

      // 4. 結束轉錄會話
      await _transcriptionService.endSession();

      // 5. 再等待一小段時間
      await Future.delayed(const Duration(milliseconds: 300));

      // 6. 保底：將 partialText 轉為 segment
      _convertPartialToSegmentIfNeeded();
    } finally {
      await _cleanup();
      statusNotifier.value = SessionStatus.stopped;
      hasUnsavedChangesNotifier.value = segmentsNotifier.value.isNotEmpty;
    }
  }

  /// 保底機制：將 partialText 轉換為 segment
  ///
  /// 當停止轉錄時，如果還有未確認的 partialText，
  /// 將其保存為 segment，確保不丟失任何內容。
  void _convertPartialToSegmentIfNeeded() {
    final text = partialTextNotifier.value;
    if (text == null || text.trim().isEmpty) return;

    debugPrint('將未確認的文字轉換為 segment: $text');

    final segment = SegmentEntity(
      id: const Uuid().v4(),
      speakerLabel: 'A', // 默認說話人
      startTimeMs: durationNotifier.value.inMilliseconds,
      endTimeMs: durationNotifier.value.inMilliseconds,
      text: text.trim(),
      orderIndex: segmentsNotifier.value.length,
    );

    segmentsNotifier.value = [...segmentsNotifier.value, segment];
    partialTextNotifier.value = null;
    hasUnsavedChangesNotifier.value = true;
  }

  /// 重置（放棄當前內容）
  void reset() {
    _cleanup();
    statusNotifier.value = SessionStatus.idle;
    durationNotifier.value = Duration.zero;
    segmentsNotifier.value = [];
    partialTextNotifier.value = null;
    errorNotifier.value = null;
    languageCodeNotifier.value = null;
    hasUnsavedChangesNotifier.value = false;
    _audioFilePath = null;
    _startTime = null;
  }

  /// 處理 Deepgram 轉錄事件
  void _handleTranscriptEvent(TranscriptEvent event) {
    switch (event) {
      case SessionConnectingEvent():
        // 正在連接，已在 start() 中處理
        break;

      case SessionStartedEvent(:final sessionId):
        // 會話已開始
        debugPrint('Deepgram session started: $sessionId');
        break;

      case PartialTranscriptEvent(:final text, :final detectedLanguage):
        // 即時結果 - 只更新 partialText，不影響其他狀態
        if (text.isEmpty) return;

        partialTextNotifier.value = text;

        // 如果檢測到語言，更新語言狀態
        if (detectedLanguage != null) {
          languageCodeNotifier.value = detectedLanguage;
        }
        break;

      case FinalTranscriptEvent(
          :final text,
          :final words,
          :final detectedLanguage
        ):
        // 最終結果 - 按說話人分組，添加到片段列表
        if (text.isEmpty) return;

        // 按說話人分組生成 segments
        final newSegments = _groupWordsBySpeaker(words, text);

        // 添加所有新片段
        if (newSegments.isNotEmpty) {
          segmentsNotifier.value = [...segmentsNotifier.value, ...newSegments];
        }

        // 清空正在輸入的文字
        partialTextNotifier.value = null;

        // 標記有未保存的變更
        hasUnsavedChangesNotifier.value = true;

        // 更新語言
        if (detectedLanguage != null) {
          languageCodeNotifier.value = detectedLanguage;
        }
        break;

      case SessionEndedEvent(
          :final audioDurationSeconds,
          :final sessionDurationSeconds
        ):
        // 會話已結束
        debugPrint(
            'Deepgram session ended: audio=${audioDurationSeconds}s, session=${sessionDurationSeconds}s');
        break;

      case ErrorEvent(:final message, :final code):
        // 錯誤事件
        _handleError(TranscriptionServiceError(message, code: code));
        break;
    }
  }

  /// 按說話人分組生成 segments
  ///
  /// 遍歷 words 數組，當說話人變化時創建新的 segment。
  /// 這樣可以正確處理一句話中有多個說話人的情況。
  List<SegmentEntity> _groupWordsBySpeaker(
      List<WordInfo> words, String fullText) {
    // 如果沒有 words 信息，使用整個 text 作為一個 segment
    if (words.isEmpty) {
      return [
        SegmentEntity(
          id: const Uuid().v4(),
          speakerLabel: 'A',
          startTimeMs: durationNotifier.value.inMilliseconds,
          endTimeMs: durationNotifier.value.inMilliseconds,
          text: fullText,
          orderIndex: segmentsNotifier.value.length,
        ),
      ];
    }

    final segments = <SegmentEntity>[];
    int? currentSpeaker = words.first.speaker;
    final buffer = StringBuffer();
    int startTimeMs = words.first.start.round();
    int endTimeMs = words.first.end.round();

    for (int i = 0; i < words.length; i++) {
      final word = words[i];

      // 檢測說話人是否變化
      if (word.speaker != currentSpeaker && buffer.isNotEmpty) {
        // 說話人變了，保存當前組
        segments.add(SegmentEntity(
          id: const Uuid().v4(),
          speakerLabel: _getSpeakerLabel(currentSpeaker),
          startTimeMs: startTimeMs,
          endTimeMs: endTimeMs,
          text: buffer.toString().trim(),
          orderIndex: segmentsNotifier.value.length + segments.length,
        ));

        // 開始新組
        currentSpeaker = word.speaker;
        buffer.clear();
        startTimeMs = word.start.round();
      }

      // 添加當前詞到緩衝區
      if (buffer.isNotEmpty) {
        buffer.write(' ');
      }
      buffer.write(word.text);
      endTimeMs = word.end.round();
    }

    // 保存最後一組
    if (buffer.isNotEmpty) {
      segments.add(SegmentEntity(
        id: const Uuid().v4(),
        speakerLabel: _getSpeakerLabel(currentSpeaker),
        startTimeMs: startTimeMs,
        endTimeMs: endTimeMs,
        text: buffer.toString().trim(),
        orderIndex: segmentsNotifier.value.length + segments.length,
      ));
    }

    return segments;
  }

  /// 獲取說話人標籤（數字轉字母）
  String _getSpeakerLabel(int? speaker) {
    if (speaker == null) return 'A';
    return String.fromCharCode('A'.codeUnitAt(0) + speaker);
  }

  void _handleError(dynamic error) {
    String errorMessage = '轉錄服務出現問題，請稍後再試';

    if (error is TranscriptionServiceError) {
      errorMessage = error.userFriendlyMessage;
    }

    statusNotifier.value = SessionStatus.error;
    errorNotifier.value = errorMessage;
  }

  /// 開始計時器 - 只更新 duration，不影響其他狀態
  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_startTime != null) {
        durationNotifier.value = DateTime.now().difference(_startTime!);
      }
    });
  }

  Future<void> _cleanup() async {
    _durationTimer?.cancel();
    _durationTimer = null;

    await _audioSubscription?.cancel();
    _audioSubscription = null;

    await _transcriptSubscription?.cancel();
    _transcriptSubscription = null;
  }

  /// 獲取當前狀態快照（用於保存等場景）
  TranscriptionSessionSnapshot getSnapshot() {
    return TranscriptionSessionSnapshot(
      status: statusNotifier.value,
      duration: durationNotifier.value,
      segments: List.unmodifiable(segmentsNotifier.value),
      partialText: partialTextNotifier.value,
      languageCode: languageCodeNotifier.value,
      hasUnsavedChanges: hasUnsavedChangesNotifier.value,
      errorMessage: errorNotifier.value,
      audioFilePath: _audioFilePath,
    );
  }

  /// 釋放資源
  void dispose() {
    _cleanup();
    statusNotifier.dispose();
    durationNotifier.dispose();
    segmentsNotifier.dispose();
    partialTextNotifier.dispose();
    errorNotifier.dispose();
    languageCodeNotifier.dispose();
    hasUnsavedChangesNotifier.dispose();
    _recorder.dispose();
    _transcriptionService.dispose();
  }
}

/// 會話狀態
enum SessionStatus {
  idle, // 空閒
  connecting, // 正在連接
  recording, // 錄音中
  stopping, // 正在停止
  stopped, // 已停止（可編輯）
  error, // 錯誤
}

/// 轉錄會話狀態快照（不可變，用於保存等場景）
class TranscriptionSessionSnapshot {
  final SessionStatus status;
  final Duration duration;
  final List<SegmentEntity> segments;
  final String? partialText;
  final String? languageCode;
  final bool hasUnsavedChanges;
  final String? errorMessage;
  final String? audioFilePath;

  const TranscriptionSessionSnapshot({
    required this.status,
    required this.duration,
    required this.segments,
    this.partialText,
    this.languageCode,
    this.hasUnsavedChanges = false,
    this.errorMessage,
    this.audioFilePath,
  });

  /// 格式化時長
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// TranscriptionManager Provider
final transcriptionManagerProvider =
    Provider.autoDispose<TranscriptionManager>((ref) {
  final manager = TranscriptionManager();
  ref.onDispose(() => manager.dispose());
  return manager;
});
