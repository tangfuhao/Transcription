import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/database/app_database.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../providers/providers.dart';

/// 搜索覆蓋層組件
///
/// 當搜索框獲得焦點時顯示，覆蓋主頁面內容
class SearchOverlay extends ConsumerWidget {
  /// 搜索關鍵字
  final String query;

  /// 點擊空白區域回調
  final VoidCallback onDismiss;

  /// 點擊搜索結果回調
  final void Function(String transcriptionId) onResultTap;

  const SearchOverlay({
    super.key,
    required this.query,
    required this.onDismiss,
    required this.onResultTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onDismiss,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: query.trim().isEmpty
            ? _buildEmptyState(context)
            : _buildSearchResults(context, ref),
      ),
    );
  }

  /// 空狀態：未輸入搜索內容
  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.enterKeywordToSearch,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tapEmptyToExit,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  /// 搜索結果列表
  Widget _buildSearchResults(BuildContext context, WidgetRef ref) {
    final searchResultsAsync = ref.watch(searchWithInfoProvider(query));
    final l10n = AppLocalizations.of(context);

    return searchResultsAsync.when(
      data: (results) {
        if (results.isEmpty) {
          return _buildNoResults(context);
        }
        return _buildResultsList(context, results);
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.searchError,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 無搜索結果
  Widget _buildNoResults(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.notFound(query),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tryOtherKeywords,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  /// 搜索結果列表
  Widget _buildResultsList(BuildContext context, List<SearchResult> results) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 結果數量提示
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.foundResults(results.length),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // 結果列表
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return _SearchResultItem(
                result: result,
                query: query,
                onTap: () => onResultTap(result.segment.transcriptionId),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 搜索結果項組件
class _SearchResultItem extends StatelessWidget {
  final SearchResult result;
  final String query;
  final VoidCallback onTap;

  const _SearchResultItem({
    required this.result,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 標題和日期
              Row(
                children: [
                  Expanded(
                    child: Text(
                      result.displayTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    result.formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // 說話人標籤
              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  return Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.speakerLabel(result.segment.speakerLabel),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              // 內容（帶高亮）
              _HighlightedText(
                text: result.segment.content,
                query: query,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
                highlightStyle: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  backgroundColor: Colors.yellow.shade200,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 帶高亮的文本組件
///
/// 將搜索關鍵字在文本中高亮顯示
class _HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle style;
  final TextStyle highlightStyle;
  final int? maxLines;

  const _HighlightedText({
    required this.text,
    required this.query,
    required this.style,
    required this.highlightStyle,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      );
    }

    final spans = _buildHighlightSpans();

    return RichText(
      text: TextSpan(
        style: style,
        children: spans,
      ),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.clip,
    );
  }

  /// 構建高亮文本片段
  List<TextSpan> _buildHighlightSpans() {
    final spans = <TextSpan>[];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    int start = 0;
    int index = lowerText.indexOf(lowerQuery);

    while (index != -1) {
      // 添加匹配前的普通文本
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }

      // 添加高亮文本（保持原始大小寫）
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: highlightStyle,
      ));

      start = index + query.length;
      index = lowerText.indexOf(lowerQuery, start);
    }

    // 添加剩餘的普通文本
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return spans;
  }
}

