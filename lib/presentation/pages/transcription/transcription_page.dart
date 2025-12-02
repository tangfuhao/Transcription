import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

import '../../../data/database/app_database.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../services/transcription_manager.dart';
import '../../providers/providers.dart';
import 'widgets/transcript_list_view.dart';

/// 轉錄頁面
///
/// 使用細粒度的 ValueListenableBuilder 進行狀態訂閱：
/// - duration: 獨立更新，不影響其他 UI
/// - segments: 使用 AnimatedList 動畫
/// - partialText: 獨立更新，平滑動畫過渡
/// - status: 控制整體狀態顯示
class TranscriptionPage extends ConsumerStatefulWidget {
  final String? languageCode;

  const TranscriptionPage({
    super.key,
    this.languageCode,
  });

  @override
  ConsumerState<TranscriptionPage> createState() => _TranscriptionPageState();
}

class _TranscriptionPageState extends ConsumerState<TranscriptionPage> {
  late TranscriptionManager _manager;
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _manager = TranscriptionManager();

    // 自動開始錄音
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startRecording();
    });
  }

  @override
  void dispose() {
    _manager.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      await _manager.start(languageCode: widget.languageCode);
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.startRecordingFailed(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    await _manager.stop();
  }

  Future<void> _saveTranscription() async {
    final snapshot = _manager.getSnapshot();
    if (snapshot.segments.isEmpty) return;

    final db = ref.read(databaseProvider);
    final id = const Uuid().v4();
    final now = DateTime.now();

    // 計算說話人數量
    final speakers = snapshot.segments.map((s) => s.speakerLabel).toSet();

    // 保存轉錄記錄
    await db.insertTranscription(TranscriptionsCompanion(
      id: drift.Value(id),
      title: drift.Value(
          _titleController.text.isEmpty ? null : _titleController.text),
      createdAt: drift.Value(now.millisecondsSinceEpoch ~/ 1000),
      updatedAt: drift.Value(now.millisecondsSinceEpoch ~/ 1000),
      durationMs: drift.Value(snapshot.duration.inMilliseconds),
      languageCode: drift.Value(snapshot.languageCode ?? 'auto'),
      speakerCount: drift.Value(speakers.length),
      audioFilePath: drift.Value(snapshot.audioFilePath),
    ));

    // 保存片段
    final segmentCompanions = snapshot.segments
        .map((s) => TranscriptionSegmentsCompanion(
              id: drift.Value(s.id),
              transcriptionId: drift.Value(id),
              speakerLabel: drift.Value(s.speakerLabel),
              startTimeMs: drift.Value(s.startTimeMs),
              endTimeMs: drift.Value(s.endTimeMs),
              content: drift.Value(s.text),
              orderIndex: drift.Value(s.orderIndex),
            ))
        .toList();

    await db.insertSegments(segmentCompanions);

    // 刷新列表
    ref.invalidate(transcriptionsProvider);

    if (mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.saved)),
      );
      context.go('/');
    }
  }

  Future<bool> _onWillPop() async {
    final status = _manager.statusNotifier.value;

    if (status == SessionStatus.idle) {
      return true;
    }

    if (status == SessionStatus.recording) {
      final l10n = AppLocalizations.of(context);
      final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.recording),
          content: Text(l10n.recordingInProgressMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'cancel'),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'stop'),
              child: Text(l10n.stopRecording),
            ),
          ],
        ),
      );

      if (result == 'stop') {
        await _stopRecording();
      }
      return false;
    }

    if (_manager.hasUnsavedChangesNotifier.value) {
      final l10n = AppLocalizations.of(context);
      final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.unsavedContent),
          content: Text(l10n.unsavedContentMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'discard'),
              child: Text(l10n.discard),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'cancel'),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'save'),
              child: Text(l10n.save),
            ),
          ],
        ),
      );

      switch (result) {
        case 'save':
          await _saveTranscription();
          return true;
        case 'discard':
          return true;
        default:
          return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: _buildTitle(),
          actions: [
            _buildSaveButton(),
          ],
        ),
        body: Column(
          children: [
            // 錄音狀態頭部
            _buildStatusHeader(),

            // 標題輸入（停止後顯示）
            _buildTitleInput(),

            const Divider(height: 1),

            // 轉錄內容列表
            Expanded(
              child: _buildTranscriptList(),
            ),

            // 控制按鈕
            _buildControlBar(),
          ],
        ),
      ),
    );
  }

  /// 標題 - 監聯 status
  Widget _buildTitle() {
    return ValueListenableBuilder<SessionStatus>(
      valueListenable: _manager.statusNotifier,
      builder: (context, status, _) {
        final l10n = AppLocalizations.of(context);
        return Text(_getTitle(status, l10n));
      },
    );
  }

  String _getTitle(SessionStatus status, AppLocalizations l10n) {
    return switch (status) {
      SessionStatus.idle => l10n.preparing,
      SessionStatus.connecting => l10n.connecting,
      SessionStatus.recording => l10n.realTimeTranscription,
      SessionStatus.stopping => l10n.stopping,
      SessionStatus.stopped => l10n.transcriptionComplete,
      SessionStatus.error => l10n.errorOccurred,
    };
  }

  /// 保存按鈕 - 監聽 status 和 segments
  Widget _buildSaveButton() {
    return ValueListenableBuilder<SessionStatus>(
      valueListenable: _manager.statusNotifier,
      builder: (context, status, _) {
        if (status != SessionStatus.stopped) {
          return const SizedBox.shrink();
        }

        return ValueListenableBuilder<List>(
          valueListenable: _manager.segmentsNotifier,
          builder: (context, segments, _) {
            if (segments.isEmpty) {
              return const SizedBox.shrink();
            }

            final l10n = AppLocalizations.of(context);
            return TextButton.icon(
              onPressed: _saveTranscription,
              icon: const Icon(Icons.save),
              label: Text(l10n.save),
            );
          },
        );
      },
    );
  }

  /// 狀態頭部 - 獨立監聽 duration 和 status
  Widget _buildStatusHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          // 時長顯示 - 獨立監聽，每秒更新不影響其他 UI
          ValueListenableBuilder<Duration>(
            valueListenable: _manager.durationNotifier,
            builder: (context, duration, _) {
              return Text(
                _formatDuration(duration),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          // 狀態指示 - 監聽 status 和 error
          _buildStatusIndicator(),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// 狀態指示器
  Widget _buildStatusIndicator() {
    return ValueListenableBuilder<SessionStatus>(
      valueListenable: _manager.statusNotifier,
      builder: (context, status, _) {
        final l10n = AppLocalizations.of(context);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (status == SessionStatus.recording) ...[
              _RecordingIndicator(),
              const SizedBox(width: 8),
              Text(l10n.recordingStatus, style: const TextStyle(color: Colors.red)),
            ] else if (status == SessionStatus.connecting) ...[
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 8),
              Text(l10n.connecting),
            ] else if (status == SessionStatus.stopped) ...[
              Icon(Icons.check_circle, color: Colors.green.shade400, size: 16),
              const SizedBox(width: 8),
              Text(l10n.stopped, style: TextStyle(color: Colors.green.shade400)),
            ] else if (status == SessionStatus.error) ...[
              const Icon(Icons.error, color: Colors.red, size: 16),
              const SizedBox(width: 8),
              ValueListenableBuilder<String?>(
                valueListenable: _manager.errorNotifier,
                builder: (context, error, _) {
                  return Flexible(
                    child: Text(
                      error ?? l10n.errorOccurred,
                      style: const TextStyle(color: Colors.red),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ],
          ],
        );
      },
    );
  }

  /// 標題輸入框 - 只在停止狀態顯示
  Widget _buildTitleInput() {
    return ValueListenableBuilder<SessionStatus>(
      valueListenable: _manager.statusNotifier,
      builder: (context, status, _) {
        if (status != SessionStatus.stopped) {
          return const SizedBox.shrink();
        }

        final l10n = AppLocalizations.of(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: l10n.titleOptional,
              hintText: l10n.enterTranscriptionTitle,
              prefixIcon: const Icon(Icons.title),
            ),
          ),
        );
      },
    );
  }

  /// 轉錄列表 - 使用 TranscriptListView 組件
  Widget _buildTranscriptList() {
    return TranscriptListView(
      segmentsNotifier: _manager.segmentsNotifier,
      partialTextNotifier: _manager.partialTextNotifier,
      statusNotifier: _manager.statusNotifier,
    );
  }

  /// 控制按鈕欄
  Widget _buildControlBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: ValueListenableBuilder<SessionStatus>(
          valueListenable: _manager.statusNotifier,
          builder: (context, status, _) {
            final l10n = AppLocalizations.of(context);
            switch (status) {
              case SessionStatus.recording:
                return Center(
                  child: FloatingActionButton.large(
                    onPressed: _stopRecording,
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.stop, size: 36),
                  ),
                );

              case SessionStatus.stopped:
                return ValueListenableBuilder<List>(
                  valueListenable: _manager.segmentsNotifier,
                  builder: (context, segments, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _startRecording,
                          icon: const Icon(Icons.mic),
                          label: Text(l10n.continueRecording),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            _manager.reset();
                            context.pop();
                          },
                          icon: const Icon(Icons.delete_outline),
                          label: Text(l10n.discard),
                        ),
                        ElevatedButton.icon(
                          onPressed:
                              segments.isNotEmpty ? _saveTranscription : null,
                          icon: const Icon(Icons.save),
                          label: Text(l10n.save),
                        ),
                      ],
                    );
                  },
                );

              case SessionStatus.error:
                return Center(
                  child: ElevatedButton.icon(
                    onPressed: _startRecording,
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                  ),
                );

              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }
}

/// 錄音指示器動畫
class _RecordingIndicator extends StatefulWidget {
  @override
  State<_RecordingIndicator> createState() => _RecordingIndicatorState();
}

class _RecordingIndicatorState extends State<_RecordingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(_animation.value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
