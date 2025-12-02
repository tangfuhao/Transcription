import 'package:flutter/material.dart';

import '../../../../data/database/app_database.dart';
import '../../../../core/constants.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// 轉錄卡片組件
class TranscriptionCard extends StatelessWidget {
  final Transcription transcription;
  final VoidCallback onTap;

  const TranscriptionCard({
    super.key,
    required this.transcription,
    required this.onTap,
  });

  String _displayTitle(AppLocalizations l10n) {
    if (transcription.title != null && transcription.title!.isNotEmpty) {
      return transcription.title!;
    }
    return l10n.unnamedTranscription;
  }

  String _formattedDuration(AppLocalizations l10n) {
    final totalSeconds = transcription.durationMs ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    if (minutes > 0) {
      return l10n.durationMinutesSeconds(minutes, seconds);
    }
    return l10n.durationSeconds(seconds);
  }

  String get _formattedDate {
    final date =
        DateTime.fromMillisecondsSinceEpoch(transcription.createdAt * 1000);
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String get _languageDisplay {
    final language = SupportedLanguage.values.firstWhere(
      (l) => l.code == transcription.languageCode,
      orElse: () => SupportedLanguage.multi,
    );
    return language.displayName;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 標題
              Row(
                children: [
                  const Icon(Icons.article_outlined, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _displayTitle(l10n),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 元數據
              Wrap(
                spacing: 16,
                runSpacing: 4,
                children: [
                  _buildMetaItem(Icons.access_time, _formattedDate),
                  _buildMetaItem(Icons.timer_outlined, _formattedDuration(l10n)),
                  _buildMetaItem(
                    Icons.people_outline,
                    l10n.speakerCount(transcription.speakerCount),
                  ),
                  _buildMetaItem(Icons.language, _languageDisplay),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

