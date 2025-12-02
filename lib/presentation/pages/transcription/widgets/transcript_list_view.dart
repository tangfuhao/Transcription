import 'package:flutter/material.dart';

import '../../../../data/models/transcription_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../services/transcription_manager.dart';
import 'segment_bubble.dart';
import 'partial_text_bubble.dart';

/// 轉錄列表視圖
///
/// 核心特性：
/// - 使用 AnimatedList 實現片段添加動畫
/// - PartialTextBubble 獨立監聽，不影響列表重建
/// - 智能滾動：只在新增片段時自動滾動到底部
class TranscriptListView extends StatefulWidget {
  final ValueNotifier<List<SegmentEntity>> segmentsNotifier;
  final ValueNotifier<String?> partialTextNotifier;
  final ValueNotifier<SessionStatus> statusNotifier;

  const TranscriptListView({
    super.key,
    required this.segmentsNotifier,
    required this.partialTextNotifier,
    required this.statusNotifier,
  });

  @override
  State<TranscriptListView> createState() => _TranscriptListViewState();
}

class _TranscriptListViewState extends State<TranscriptListView> {
  final _listKey = GlobalKey<AnimatedListState>();
  final _scrollController = ScrollController();

  int _lastKnownLength = 0;
  bool _shouldAutoScroll = true;
  
  /// 用於追蹤滾動目標，避免重複滾動
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _lastKnownLength = widget.segmentsNotifier.value.length;
    widget.segmentsNotifier.addListener(_onSegmentsChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.segmentsNotifier.removeListener(_onSegmentsChanged);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// 監聽用戶滾動行為
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    // 如果用戶滾動到距離底部 100 像素以內，恢復自動滾動
    if (maxScroll - currentScroll < 100) {
      _shouldAutoScroll = true;
    } else if (!_isScrolling) {
      // 用戶主動向上滾動時，暫停自動滾動
      _shouldAutoScroll = false;
    }
  }

  /// 當片段列表變化時
  void _onSegmentsChanged() {
    final newLength = widget.segmentsNotifier.value.length;

    if (newLength > _lastKnownLength) {
      // 有新片段加入，觸發 AnimatedList 插入動畫
      for (int i = _lastKnownLength; i < newLength; i++) {
        _listKey.currentState?.insertItem(
          i,
          duration: const Duration(milliseconds: 300),
        );
      }

      // 只在應該自動滾動時才滾動
      if (_shouldAutoScroll) {
        _scrollToBottom();
      }
    }

    _lastKnownLength = newLength;
  }

  /// 平滑滾動到底部
  /// 
  /// 優化策略：
  /// 1. 等待插入動畫完成後再滾動
  /// 2. 使用漸進式滾動，先到當前最大值，再微調
  /// 3. 避免彈性過度滾動
  void _scrollToBottom() {
    if (_isScrolling) return;
    _isScrolling = true;

    // 延遲滾動，等待 AnimatedList 插入動畫完成
    // 動畫時長 300ms，我們在動畫進行到一半時開始滾動
    Future.delayed(const Duration(milliseconds: 150), () {
      if (!_scrollController.hasClients) {
        _isScrolling = false;
        return;
      }

      final currentMax = _scrollController.position.maxScrollExtent;
      final currentOffset = _scrollController.offset;

      // 如果已經在底部附近，不需要滾動
      if (currentMax - currentOffset < 50) {
        _isScrolling = false;
        return;
      }

      // 執行滾動
      _scrollController
          .animateTo(
            currentMax,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          )
          .then((_) {
        // 滾動完成後，再次檢查是否需要微調
        // （因為動畫期間 maxScrollExtent 可能會變化）
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            final finalMax = _scrollController.position.maxScrollExtent;
            final finalOffset = _scrollController.offset;
            
            // 如果還有差距，直接跳轉（不用動畫，避免回彈感）
            if (finalMax - finalOffset > 10) {
              _scrollController.jumpTo(finalMax);
            }
          }
          _isScrolling = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SessionStatus>(
      valueListenable: widget.statusNotifier,
      builder: (context, status, _) {
        return ValueListenableBuilder<List<SegmentEntity>>(
          valueListenable: widget.segmentsNotifier,
          builder: (context, segments, _) {
            // 空狀態
            if (segments.isEmpty) {
              return _buildEmptyState(status);
            }

            return Column(
              children: [
                // 已確認的片段列表
                Expanded(
                  child: AnimatedList(
                    key: _listKey,
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    initialItemCount: segments.length,
                    // 使用 ClampingScrollPhysics 避免彈性回彈效果
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index, animation) {
                      if (index >= segments.length) {
                        return const SizedBox.shrink();
                      }

                      return _buildAnimatedSegment(
                        segments[index],
                        animation,
                      );
                    },
                  ),
                ),
                // 正在輸入的文字（獨立監聯）
                ValueListenableBuilder<String?>(
                  valueListenable: widget.partialTextNotifier,
                  builder: (context, partialText, _) {
                    return PartialTextBubble(text: partialText);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// 構建帶動畫的片段
  Widget _buildAnimatedSegment(
      SegmentEntity segment, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOut)),
      ),
      child: FadeTransition(
        opacity: animation,
        child: SegmentBubble(segment: segment),
      ),
    );
  }

  /// 構建空狀態
  Widget _buildEmptyState(SessionStatus status) {
    return ValueListenableBuilder<String?>(
      valueListenable: widget.partialTextNotifier,
      builder: (context, partialText, _) {
        // 如果有正在輸入的文字，只顯示 partial text
        if (partialText != null && partialText.isNotEmpty) {
          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            physics: const ClampingScrollPhysics(),
            child: PartialTextBubble(text: partialText),
          );
        }

        // 完全空狀態
        final l10n = AppLocalizations.of(context);
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                status == SessionStatus.error ? Icons.error_outline : Icons.mic,
                size: 64,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                _getEmptyStateText(status, l10n),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getEmptyStateText(SessionStatus status, AppLocalizations l10n) {
    switch (status) {
      case SessionStatus.error:
        return l10n.errorPleaseRetry;
      case SessionStatus.connecting:
        return l10n.connecting;
      case SessionStatus.recording:
        return l10n.startSpeaking;
      case SessionStatus.stopping:
        return l10n.stopping;
      case SessionStatus.idle:
      case SessionStatus.stopped:
        return l10n.ready;
    }
  }
}
