import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../data/models/transcription_model.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// 轉錄片段氣泡組件
///
/// 顯示單個已確認的轉錄片段，包含說話人標籤和時間戳。
class SegmentBubble extends StatelessWidget {
  final SegmentEntity segment;
  final VoidCallback? onTap;

  const SegmentBubble({
    super.key,
    required this.segment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final speakerIndex =
        segment.speakerLabel.codeUnitAt(0) - 'A'.codeUnitAt(0);
    final color = AppTheme.getSpeakerColor(speakerIndex.clamp(0, 5));

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 說話人標籤和時間
          Row(
            children: [
              _SpeakerBadge(
                label: segment.speakerLabel,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                segment.formattedTime,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 文字氣泡
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Text(
                segment.text,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 說話人標籤組件
class _SpeakerBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _SpeakerBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            l10n.speakerLabel(label),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

