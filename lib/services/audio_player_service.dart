import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

/// 音頻播放服務
///
/// 提供音頻播放功能，支持：
/// - 播放/暫停/停止
/// - 跳轉到指定時間點
/// - 播放進度監聽
class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  /// 當前加載的音頻文件路徑
  String? _currentFilePath;
  String? get currentFilePath => _currentFilePath;

  /// 播放狀態流
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// 當前位置流
  Stream<Duration> get positionStream => _player.positionStream;

  /// 緩衝位置流
  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;

  /// 總時長流
  Stream<Duration?> get durationStream => _player.durationStream;

  /// 當前播放狀態
  PlayerState? get playerState => _player.playerState;

  /// 當前位置
  Duration get position => _player.position;

  /// 總時長
  Duration? get duration => _player.duration;

  /// 是否正在播放
  bool get isPlaying => _player.playing;

  /// 是否已加載音頻
  bool get hasAudio => _currentFilePath != null;

  /// 加載音頻文件
  ///
  /// [filePath] 音頻文件的本地路徑
  /// 返回音頻總時長
  Future<Duration?> loadAudio(String filePath) async {
    // 檢查文件是否存在
    final file = File(filePath);
    if (!await file.exists()) {
      throw AudioPlayerException('音頻文件不存在: $filePath');
    }

    try {
      // 如果已經加載了相同的文件，不重複加載
      if (_currentFilePath == filePath && _player.duration != null) {
        return _player.duration;
      }

      // 加載新文件
      final duration = await _player.setFilePath(filePath);
      _currentFilePath = filePath;
      return duration;
    } catch (e) {
      _currentFilePath = null;
      throw AudioPlayerException('加載音頻失敗: $e');
    }
  }

  /// 播放
  Future<void> play() async {
    if (_currentFilePath == null) {
      throw AudioPlayerException('沒有加載音頻文件');
    }
    await _player.play();
  }

  /// 暫停
  Future<void> pause() async {
    await _player.pause();
  }

  /// 停止
  Future<void> stop() async {
    await _player.stop();
    await _player.seek(Duration.zero);
  }

  /// 跳轉到指定時間點
  ///
  /// [position] 目標位置
  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
  }

  /// 跳轉到指定毫秒
  ///
  /// [milliseconds] 目標位置（毫秒）
  Future<void> seekToMs(int milliseconds) async {
    await _player.seek(Duration(milliseconds: milliseconds));
  }

  /// 設置播放速度
  ///
  /// [speed] 播放速度（1.0 = 正常速度）
  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  /// 設置音量
  ///
  /// [volume] 音量（0.0 - 1.0）
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  /// 卸載當前音頻
  Future<void> unload() async {
    await _player.stop();
    _currentFilePath = null;
  }

  /// 釋放資源
  Future<void> dispose() async {
    await _player.dispose();
    _currentFilePath = null;
  }
}

/// 音頻播放異常
class AudioPlayerException implements Exception {
  final String message;

  AudioPlayerException(this.message);

  @override
  String toString() => 'AudioPlayerException: $message';
}

/// 音頻播放狀態
class AudioPlaybackState {
  final bool isPlaying;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final Duration position;
  final Duration? duration;
  final String? filePath;

  const AudioPlaybackState({
    this.isPlaying = false,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.position = Duration.zero,
    this.duration,
    this.filePath,
  });

  AudioPlaybackState copyWith({
    bool? isPlaying,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    Duration? position,
    Duration? duration,
    String? filePath,
  }) {
    return AudioPlaybackState(
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? false,
      errorMessage: errorMessage,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      filePath: filePath ?? this.filePath,
    );
  }

  /// 格式化當前位置
  String get formattedPosition => _formatDuration(position);

  /// 格式化總時長
  String get formattedDuration => _formatDuration(duration ?? Duration.zero);

  /// 播放進度百分比 (0.0 - 1.0)
  double get progress {
    if (duration == null || duration!.inMilliseconds == 0) return 0.0;
    return position.inMilliseconds / duration!.inMilliseconds;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// 音頻播放器 Notifier
///
/// 管理音頻播放狀態，提供響應式更新
class AudioPlayerNotifier extends AutoDisposeAsyncNotifier<AudioPlaybackState> {
  late final AudioPlayerService _playerService;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _durationSubscription;

  @override
  Future<AudioPlaybackState> build() async {
    _playerService = AudioPlayerService();

    // 監聽播放器狀態
    _playerStateSubscription = _playerService.playerStateStream.listen((playerState) {
      final currentState = state.valueOrNull ?? const AudioPlaybackState();
      state = AsyncData(currentState.copyWith(
        isPlaying: playerState.playing,
        isLoading: playerState.processingState == ProcessingState.loading ||
            playerState.processingState == ProcessingState.buffering,
      ));
    });

    // 監聽播放位置
    _positionSubscription = _playerService.positionStream.listen((position) {
      final currentState = state.valueOrNull ?? const AudioPlaybackState();
      state = AsyncData(currentState.copyWith(position: position));
    });

    // 監聽總時長
    _durationSubscription = _playerService.durationStream.listen((duration) {
      final currentState = state.valueOrNull ?? const AudioPlaybackState();
      state = AsyncData(currentState.copyWith(duration: duration));
    });

    // 清理
    ref.onDispose(() {
      _positionSubscription?.cancel();
      _playerStateSubscription?.cancel();
      _durationSubscription?.cancel();
      _playerService.dispose();
    });

    return const AudioPlaybackState();
  }

  /// 加載音頻文件
  Future<void> loadAudio(String filePath) async {
    try {
      state = AsyncData((state.valueOrNull ?? const AudioPlaybackState()).copyWith(
        isLoading: true,
        hasError: false,
        filePath: filePath,
      ));

      final duration = await _playerService.loadAudio(filePath);

      state = AsyncData((state.valueOrNull ?? const AudioPlaybackState()).copyWith(
        isLoading: false,
        duration: duration,
        filePath: filePath,
      ));
    } catch (e) {
      state = AsyncData((state.valueOrNull ?? const AudioPlaybackState()).copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  /// 播放
  Future<void> play() async {
    try {
      await _playerService.play();
    } catch (e) {
      state = AsyncData((state.valueOrNull ?? const AudioPlaybackState()).copyWith(
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  /// 暫停
  Future<void> pause() async {
    await _playerService.pause();
  }

  /// 播放/暫停切換
  Future<void> togglePlayPause() async {
    if (_playerService.isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  /// 停止
  Future<void> stop() async {
    await _playerService.stop();
  }

  /// 跳轉到指定時間點
  Future<void> seekTo(Duration position) async {
    await _playerService.seekTo(position);
  }

  /// 跳轉到指定毫秒
  Future<void> seekToMs(int milliseconds) async {
    await _playerService.seekToMs(milliseconds);
  }

  /// 跳轉並播放
  Future<void> seekToAndPlay(Duration position) async {
    await _playerService.seekTo(position);
    await _playerService.play();
  }

  /// 跳轉到指定毫秒並播放
  Future<void> seekToMsAndPlay(int milliseconds) async {
    await _playerService.seekToMs(milliseconds);
    await _playerService.play();
  }

  /// 設置播放速度
  Future<void> setSpeed(double speed) async {
    await _playerService.setSpeed(speed);
  }

  /// 卸載音頻
  Future<void> unload() async {
    await _playerService.unload();
    state = const AsyncData(AudioPlaybackState());
  }
}

/// 音頻播放器 Provider
final audioPlayerProvider =
    AutoDisposeAsyncNotifierProvider<AudioPlayerNotifier, AudioPlaybackState>(
  AudioPlayerNotifier.new,
);

