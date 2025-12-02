import 'package:equatable/equatable.dart';

/// 轉錄記錄實體
class TranscriptionEntity extends Equatable {
  final String id;
  final String? title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Duration duration;
  final String languageCode;
  final int speakerCount;
  final List<SegmentEntity> segments;
  final Map<String, String> speakerMappings;

  const TranscriptionEntity({
    required this.id,
    this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.duration,
    required this.languageCode,
    required this.speakerCount,
    this.segments = const [],
    this.speakerMappings = const {},
  });

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

  /// 格式化時長
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// 獲取說話人顯示名稱
  String getSpeakerDisplayName(String originalLabel) {
    return speakerMappings[originalLabel] ?? 'Speaker $originalLabel';
  }

  TranscriptionEntity copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    Duration? duration,
    String? languageCode,
    int? speakerCount,
    List<SegmentEntity>? segments,
    Map<String, String>? speakerMappings,
  }) {
    return TranscriptionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      duration: duration ?? this.duration,
      languageCode: languageCode ?? this.languageCode,
      speakerCount: speakerCount ?? this.speakerCount,
      segments: segments ?? this.segments,
      speakerMappings: speakerMappings ?? this.speakerMappings,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        createdAt,
        updatedAt,
        duration,
        languageCode,
        speakerCount,
        segments,
        speakerMappings,
      ];
}

/// 轉錄片段實體
class SegmentEntity extends Equatable {
  final String id;
  final String speakerLabel;
  final int startTimeMs;
  final int endTimeMs;
  final String text;
  final int orderIndex;

  const SegmentEntity({
    required this.id,
    required this.speakerLabel,
    required this.startTimeMs,
    required this.endTimeMs,
    required this.text,
    required this.orderIndex,
  });

  /// 格式化時間戳
  String get formattedTime {
    final totalSeconds = startTimeMs ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// 時長 (毫秒)
  int get durationMs => endTimeMs - startTimeMs;

  SegmentEntity copyWith({
    String? id,
    String? speakerLabel,
    int? startTimeMs,
    int? endTimeMs,
    String? text,
    int? orderIndex,
  }) {
    return SegmentEntity(
      id: id ?? this.id,
      speakerLabel: speakerLabel ?? this.speakerLabel,
      startTimeMs: startTimeMs ?? this.startTimeMs,
      endTimeMs: endTimeMs ?? this.endTimeMs,
      text: text ?? this.text,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  List<Object?> get props =>
      [id, speakerLabel, startTimeMs, endTimeMs, text, orderIndex];
}

