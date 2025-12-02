import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// 音頻錄製服務
/// 
/// 使用 Platform Channel 調用原生錄音 API
/// 支持同時保存音頻到本地 WAV 文件
class AudioRecorderService {
  static const _methodChannel = MethodChannel('com.macaron.transcription/audio');
  static const _eventChannel = EventChannel('com.macaron.transcription/audio_stream');

  StreamSubscription? _audioSubscription;
  final _audioStreamController = StreamController<Uint8List>.broadcast();

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  /// 當前錄音的音頻文件絕對路徑（內部使用）
  String? _currentAudioFilePath;
  
  /// 當前錄音的音頻文件相對路徑（用於存儲到數據庫）
  String? _currentAudioRelativePath;
  String? get currentAudioFilePath => _currentAudioRelativePath;

  /// 音頻文件寫入器
  IOSink? _audioFileSink;
  
  /// 音頻數據緩衝區（用於計算文件大小）
  int _audioDataSize = 0;

  /// 音頻參數（PCM 16kHz, mono, 16-bit）
  static const int sampleRate = 16000;
  static const int channels = 1;
  static const int bitsPerSample = 16;

  /// 音頻數據流 (PCM 16kHz, mono, 16-bit)
  Stream<Uint8List> get audioStream => _audioStreamController.stream;

  /// 開始錄音
  /// 
  /// [saveToFile] 是否保存音頻到文件（默認為 true）
  Future<void> startRecording({bool saveToFile = true}) async {
    if (_isRecording) return;

    try {
      // 如果需要保存文件，創建音頻文件
      if (saveToFile) {
        await _createAudioFile();
      }

      // 訂閱原生音頻流
      _audioSubscription = _eventChannel
          .receiveBroadcastStream()
          .listen(
            (data) {
              if (data is Uint8List) {
                _audioStreamController.add(data);
                // 同時寫入文件
                _writeAudioData(data);
              }
            },
            onError: (error) {
              _audioStreamController.addError(error);
            },
          );

      // 調用原生開始錄音
      await _methodChannel.invokeMethod('startRecording');
      _isRecording = true;
    } catch (e) {
      await _closeAudioFile();
      _audioSubscription?.cancel();
      _audioSubscription = null;
      rethrow;
    }
  }

  /// 停止錄音
  /// 
  /// 返回音頻文件的相對路徑（如果有保存），用於存儲到數據庫
  Future<String?> stopRecording() async {
    if (!_isRecording) return null;

    try {
      await _methodChannel.invokeMethod('stopRecording');
    } finally {
      _isRecording = false;
      await _audioSubscription?.cancel();
      _audioSubscription = null;
      
      // 完成音頻文件寫入
      await _finalizeAudioFile();
    }
    
    return _currentAudioRelativePath;
  }

  /// 創建音頻文件
  Future<void> _createAudioFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final audioDir = Directory(p.join(directory.path, 'audio'));
    
    // 確保音頻目錄存在
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    
    // 使用時間戳作為文件名
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'recording_$timestamp.wav';
    
    // 存儲相對路徑（用於數據庫）和絕對路徑（用於文件操作）
    _currentAudioRelativePath = 'audio/$fileName';
    _currentAudioFilePath = p.join(audioDir.path, fileName);
    
    // 創建文件並預留 WAV 頭部空間
    final file = File(_currentAudioFilePath!);
    _audioFileSink = file.openWrite();
    
    // 先寫入佔位的 WAV 頭部（44 字節），稍後會更新
    _audioFileSink!.add(_createWavHeader(0));
    _audioDataSize = 0;
  }

  /// 寫入音頻數據
  void _writeAudioData(Uint8List data) {
    if (_audioFileSink != null) {
      _audioFileSink!.add(data);
      _audioDataSize += data.length;
    }
  }

  /// 完成音頻文件（更新 WAV 頭部）
  Future<void> _finalizeAudioFile() async {
    if (_audioFileSink != null && _currentAudioFilePath != null) {
      await _audioFileSink!.close();
      _audioFileSink = null;
      
      // 更新 WAV 文件頭部的大小信息
      if (_audioDataSize > 0) {
        await _updateWavHeader(_currentAudioFilePath!, _audioDataSize);
      } else {
        // 沒有音頻數據，刪除空文件
        final file = File(_currentAudioFilePath!);
        if (await file.exists()) {
          await file.delete();
        }
        _currentAudioFilePath = null;
        _currentAudioRelativePath = null;
      }
    }
  }

  /// 關閉音頻文件（異常情況）
  Future<void> _closeAudioFile() async {
    if (_audioFileSink != null) {
      await _audioFileSink!.close();
      _audioFileSink = null;
    }
    
    // 刪除不完整的文件
    if (_currentAudioFilePath != null) {
      final file = File(_currentAudioFilePath!);
      if (await file.exists()) {
        await file.delete();
      }
      _currentAudioFilePath = null;
      _currentAudioRelativePath = null;
    }
  }

  /// 創建 WAV 文件頭部
  /// 
  /// PCM 格式：16kHz, mono, 16-bit
  Uint8List _createWavHeader(int dataSize) {
    final header = ByteData(44);
    
    // RIFF 標識
    header.setUint8(0, 0x52); // 'R'
    header.setUint8(1, 0x49); // 'I'
    header.setUint8(2, 0x46); // 'F'
    header.setUint8(3, 0x46); // 'F'
    
    // 文件大小（不包括 RIFF 標識和這個字段本身）
    header.setUint32(4, 36 + dataSize, Endian.little);
    
    // WAVE 標識
    header.setUint8(8, 0x57);  // 'W'
    header.setUint8(9, 0x41);  // 'A'
    header.setUint8(10, 0x56); // 'V'
    header.setUint8(11, 0x45); // 'E'
    
    // fmt 子塊
    header.setUint8(12, 0x66); // 'f'
    header.setUint8(13, 0x6D); // 'm'
    header.setUint8(14, 0x74); // 't'
    header.setUint8(15, 0x20); // ' '
    
    // fmt 子塊大小
    header.setUint32(16, 16, Endian.little);
    
    // 音頻格式（1 = PCM）
    header.setUint16(20, 1, Endian.little);
    
    // 聲道數
    header.setUint16(22, channels, Endian.little);
    
    // 採樣率
    header.setUint32(24, sampleRate, Endian.little);
    
    // 字節率 = 採樣率 * 聲道數 * 位深度 / 8
    final byteRate = sampleRate * channels * bitsPerSample ~/ 8;
    header.setUint32(28, byteRate, Endian.little);
    
    // 塊對齊 = 聲道數 * 位深度 / 8
    final blockAlign = channels * bitsPerSample ~/ 8;
    header.setUint16(32, blockAlign, Endian.little);
    
    // 位深度
    header.setUint16(34, bitsPerSample, Endian.little);
    
    // data 子塊
    header.setUint8(36, 0x64); // 'd'
    header.setUint8(37, 0x61); // 'a'
    header.setUint8(38, 0x74); // 't'
    header.setUint8(39, 0x61); // 'a'
    
    // 數據大小
    header.setUint32(40, dataSize, Endian.little);
    
    return header.buffer.asUint8List();
  }

  /// 更新 WAV 文件頭部的大小信息
  Future<void> _updateWavHeader(String filePath, int dataSize) async {
    final file = File(filePath);
    final raf = await file.open(mode: FileMode.writeOnlyAppend);
    
    try {
      // 更新文件大小（位置 4）
      await raf.setPosition(4);
      final fileSizeBytes = ByteData(4)..setUint32(0, 36 + dataSize, Endian.little);
      await raf.writeFrom(fileSizeBytes.buffer.asUint8List());
      
      // 更新數據大小（位置 40）
      await raf.setPosition(40);
      final dataSizeBytes = ByteData(4)..setUint32(0, dataSize, Endian.little);
      await raf.writeFrom(dataSizeBytes.buffer.asUint8List());
    } finally {
      await raf.close();
    }
  }

  /// 從相對路徑獲取絕對路徑
  /// 
  /// [relativePath] 相對於 Documents 目錄的路徑，如 'audio/recording_xxx.wav'
  static Future<String> getAbsolutePath(String relativePath) async {
    final directory = await getApplicationDocumentsDirectory();
    return p.join(directory.path, relativePath);
  }

  /// 刪除音頻文件
  /// 
  /// [relativePath] 相對於 Documents 目錄的路徑
  static Future<void> deleteAudioFile(String? relativePath) async {
    if (relativePath == null) return;
    
    final absolutePath = await getAbsolutePath(relativePath);
    final file = File(absolutePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// 檢查麥克風權限
  Future<bool> checkPermission() async {
    try {
      final result = await _methodChannel.invokeMethod<bool>('checkPermission');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// 請求麥克風權限
  Future<bool> requestPermission() async {
    try {
      final result = await _methodChannel.invokeMethod<bool>('requestPermission');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// 釋放資源
  void dispose() {
    stopRecording();
    _audioStreamController.close();
  }
}
