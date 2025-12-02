import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';

/// 正在輸入的文字氣泡組件
///
/// 使用動畫平滑地顯示/隱藏正在輸入的內容。
/// - 出現/消失時有淡入淡出和尺寸動畫
/// - 文字長度變化時有平滑過渡
class PartialTextBubble extends StatelessWidget {
  final String? text;

  const PartialTextBubble({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    final hasText = text != null && text!.isNotEmpty;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1.0,
            child: child,
          ),
        );
      },
      child: hasText
          ? _PartialTextContent(
              key: const ValueKey('partial_content'),
              text: text!,
            )
          : const SizedBox.shrink(key: ValueKey('empty')),
    );
  }
}

/// 正在輸入的內容
class _PartialTextContent extends StatelessWidget {
  final String text;

  const _PartialTextContent({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 「正在輸入...」標籤
          _TypingIndicator(),
          const SizedBox(height: 8),
          // 文字氣泡 - 使用 AnimatedSize 讓文字長度變化平滑
          AnimatedSize(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            alignment: Alignment.topLeft,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 正在輸入指示器
class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 動態旋轉的加載指示器
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.14159,
                child: child,
              );
            },
            child: Icon(
              Icons.sync,
              size: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            l10n.typing,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

