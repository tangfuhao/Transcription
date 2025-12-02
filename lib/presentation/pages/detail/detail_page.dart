import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../services/audio_player_service.dart';
import '../../../services/audio_recorder_service.dart';
import '../../providers/providers.dart';

/// 轉錄詳情頁
class DetailPage extends ConsumerStatefulWidget {
  final String transcriptionId;

  const DetailPage({
    super.key,
    required this.transcriptionId,
  });

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  final Map<String, String> _speakerMappings = {};
  bool _isEditing = false;
  bool _hasChanges = false;
  
  /// 當前播放的 segment 索引
  int? _currentPlayingIndex;

  @override
  void initState() {
    super.initState();
    // 初始化音頻播放器
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    // 等待轉錄記錄加載完成後加載音頻
    final transcription = await ref.read(transcriptionProvider(widget.transcriptionId).future);
    if (transcription?.audioFilePath != null) {
      // 將相對路徑轉換為絕對路徑
      final absolutePath = await AudioRecorderService.getAbsolutePath(transcription!.audioFilePath!);
      final file = File(absolutePath);
      if (await file.exists()) {
        await ref.read(audioPlayerProvider.notifier).loadAudio(absolutePath);
      }
    }
  }

  void _showSpeakerRenameDialog(String originalLabel) {
    final controller = TextEditingController(
      text: _speakerMappings[originalLabel] ?? '',
    );
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.renameSpeaker(originalLabel)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.name,
            hintText: l10n.enterSpeakerName,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (controller.text.isNotEmpty) {
                  _speakerMappings[originalLabel] = controller.text;
                } else {
                  _speakerMappings.remove(originalLabel);
                }
                _hasChanges = true;
              });
              Navigator.pop(context);
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  void _deleteTranscription() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.confirmDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // 停止播放
      await ref.read(audioPlayerProvider.notifier).unload();
      
      final db = ref.read(databaseProvider);
      await db.deleteTranscription(widget.transcriptionId);
      ref.invalidate(transcriptionsProvider);
      if (mounted) {
        context.pop();
      }
    }
  }

  String _getSpeakerDisplayName(String originalLabel, AppLocalizations l10n) {
    return _speakerMappings[originalLabel] ?? l10n.speakerLabel(originalLabel);
  }

  Color _getSpeakerColor(String label) {
    final index = label.codeUnitAt(0) - 'A'.codeUnitAt(0);
    return AppTheme.getSpeakerColor(index);
  }

  /// 播放指定的 segment
  Future<void> _playSegment(int index, int startTimeMs) async {
    setState(() {
      _currentPlayingIndex = index;
    });
    await ref.read(audioPlayerProvider.notifier).seekToMsAndPlay(startTimeMs);
  }

  @override
  Widget build(BuildContext context) {
    final transcriptionAsync =
        ref.watch(transcriptionProvider(widget.transcriptionId));
    final segmentsAsync = ref.watch(segmentsProvider(widget.transcriptionId));
    final playbackState = ref.watch(audioPlayerProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: transcriptionAsync.when(
          data: (t) => Text(t?.title ?? l10n.transcriptionDetail),
          loading: () => Text(l10n.loading),
          error: (_, __) => Text(l10n.error),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteTranscription,
          ),
          if (_hasChanges)
            TextButton.icon(
              onPressed: () {
                // TODO: 保存變更
                setState(() => _hasChanges = false);
              },
              icon: const Icon(Icons.save),
              label: Text(l10n.save),
            ),
        ],
      ),
      body: transcriptionAsync.when(
        data: (transcription) {
          if (transcription == null) {
            return Center(child: Text(l10n.transcriptionNotFound));
          }

          final hasAudio = transcription.audioFilePath != null;

          return Column(
            children: [
              // 轉錄內容列表
              Expanded(
                child: segmentsAsync.when(
                  data: (segments) {
                    if (segments.isEmpty) {
                      return Center(child: Text(l10n.noTranscriptionContent));
                    }

                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        hasAudio ? 100 : 16, // 為播放器預留空間
                      ),
                      itemCount: segments.length,
                      itemBuilder: (context, index) {
                        final segment = segments[index];
                        final speakerColor = _getSpeakerColor(segment.speakerLabel);
                        final isPlaying = _currentPlayingIndex == index;

                        return _SegmentItem(
                          segment: segment,
                          speakerColor: speakerColor,
                          speakerDisplayName: _getSpeakerDisplayName(segment.speakerLabel, l10n),
                          isEditing: _isEditing,
                          isPlaying: isPlaying,
                          hasAudio: hasAudio,
                          onSpeakerTap: () => _showSpeakerRenameDialog(segment.speakerLabel),
                          onPlayTap: hasAudio
                              ? () => _playSegment(index, segment.startTimeMs)
                              : null,
                          onTextTap: () => setState(() => _isEditing = true),
                          onTextChanged: (value) {
                            setState(() => _hasChanges = true);
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(child: Text(l10n.loadFailed(error.toString()))),
                ),
              ),

              // 音頻播放器控制條
              if (hasAudio)
                playbackState.when(
                  data: (state) => _AudioPlayerBar(
                    state: state,
                    onPlayPause: () => ref.read(audioPlayerProvider.notifier).togglePlayPause(),
                    onSeek: (position) => ref.read(audioPlayerProvider.notifier).seekTo(position),
                    onStop: () {
                      ref.read(audioPlayerProvider.notifier).stop();
                      setState(() => _currentPlayingIndex = null);
                    },
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(l10n.loadFailed(error.toString()))),
      ),
    );
  }

}

/// Segment 項目組件
class _SegmentItem extends StatelessWidget {
  final dynamic segment;
  final Color speakerColor;
  final String speakerDisplayName;
  final bool isEditing;
  final bool isPlaying;
  final bool hasAudio;
  final VoidCallback onSpeakerTap;
  final VoidCallback? onPlayTap;
  final VoidCallback onTextTap;
  final ValueChanged<String> onTextChanged;

  const _SegmentItem({
    required this.segment,
    required this.speakerColor,
    required this.speakerDisplayName,
    required this.isEditing,
    required this.isPlaying,
    required this.hasAudio,
    required this.onSpeakerTap,
    required this.onPlayTap,
    required this.onTextTap,
    required this.onTextChanged,
  });

  String _formatTime(int milliseconds) {
    final totalSeconds = milliseconds ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 說話人標籤和時間
          Row(
            children: [
              // 說話人標籤（可點擊重命名）
              GestureDetector(
                onTap: onSpeakerTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: speakerColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: speakerColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person,
                        size: 14,
                        color: speakerColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        speakerDisplayName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: speakerColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.edit,
                        size: 12,
                        color: speakerColor.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 時間戳
              Text(
                _formatTime(segment.startTimeMs),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const Spacer(),
              // 播放按鈕
              if (hasAudio)
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context);
                    return IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause_circle_filled : Icons.play_circle_outline,
                        color: isPlaying ? Theme.of(context).primaryColor : Colors.grey.shade600,
                      ),
                      iconSize: 28,
                      onPressed: onPlayTap,
                      tooltip: isPlaying ? l10n.pause : l10n.playThisSegment,
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),
          // 文字內容
          GestureDetector(
            onTap: hasAudio ? onPlayTap : onTextTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isPlaying
                    ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isPlaying
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.5)
                      : Colors.grey.shade200,
                  width: isPlaying ? 2 : 1,
                ),
              ),
              child: isEditing
                  ? TextField(
                      controller: TextEditingController(text: segment.content),
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                      onChanged: onTextChanged,
                    )
                  : Text(
                      segment.content,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 音頻播放器控制條
class _AudioPlayerBar extends StatelessWidget {
  final AudioPlaybackState state;
  final VoidCallback onPlayPause;
  final ValueChanged<Duration> onSeek;
  final VoidCallback onStop;

  const _AudioPlayerBar({
    required this.state,
    required this.onPlayPause,
    required this.onSeek,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 進度條
              Row(
                children: [
                  Text(
                    state.formattedPosition,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      ),
                      child: Slider(
                        value: state.progress.clamp(0.0, 1.0),
                        onChanged: (value) {
                          if (state.duration != null) {
                            final position = Duration(
                              milliseconds: (value * state.duration!.inMilliseconds).toInt(),
                            );
                            onSeek(position);
                          }
                        },
                      ),
                    ),
                  ),
                  Text(
                    state.formattedDuration,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // 控制按鈕
              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 停止按鈕
                      IconButton(
                        icon: const Icon(Icons.stop),
                        onPressed: onStop,
                        tooltip: l10n.stop,
                      ),
                      const SizedBox(width: 16),
                      // 播放/暫停按鈕
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            state.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          iconSize: 32,
                          onPressed: state.isLoading ? null : onPlayPause,
                          tooltip: state.isPlaying ? l10n.pause : l10n.play,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 佔位（保持對稱）
                      const SizedBox(width: 48),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
