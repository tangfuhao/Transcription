import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/providers.dart';
import 'widgets/search_overlay.dart';
import 'widgets/transcription_card.dart';

/// 主頁
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  
  /// 是否處於搜索模式
  bool _isSearchMode = false;

  @override
  void initState() {
    super.initState();
    // 監聽搜索框焦點變化
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// 搜索框焦點變化處理
  void _onSearchFocusChanged() {
    setState(() {
      _isSearchMode = _searchFocusNode.hasFocus;
    });
  }

  /// 退出搜索模式
  void _exitSearchMode() {
    _searchFocusNode.unfocus();
    _searchController.clear();
    setState(() {
      _isSearchMode = false;
    });
  }

  /// 處理搜索結果點擊
  void _handleSearchResultTap(String transcriptionId) {
    _exitSearchMode();
    context.push('/detail/$transcriptionId');
  }

  /// 處理開始轉錄按鈕點擊
  ///
  /// 如果已設置默認語言（包括多語言自動檢測），直接跳轉到轉錄頁面
  /// 否則顯示語言選擇器
  void _handleStartTranscription() {
    // 使用 notifier provider 確保獲取最新狀態
    final defaultLanguageAsync = ref.read(defaultLanguageNotifierProvider);

    defaultLanguageAsync.when(
      data: (defaultLanguage) {
        if (defaultLanguage != null) {
          // 有默認語言（包括多語言自動檢測），直接跳轉
          context.push('/transcription', extra: defaultLanguage.code);
        } else {
          // 未設置默認語言，顯示選擇器
          _showLanguageSelector();
        }
      },
      loading: () {
        // 載入中，顯示選擇器（保險起見）
        _showLanguageSelector();
      },
      error: (_, __) {
        // 出錯，顯示選擇器
        _showLanguageSelector();
      },
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _LanguageSelectorSheet(
        onLanguageSelected: (language) {
          Navigator.pop(context);
          context.push(
            '/transcription',
            extra: language.code,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transcriptionsAsync = ref.watch(transcriptionsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 底層：正常內容
          Column(
            children: [
              // 搜索欄
              _buildSearchBar(),

              // 列表
              Expanded(
                child: _isSearchMode
                    ? const SizedBox.shrink() // 搜索模式下隱藏列表
                    : _buildTranscriptionList(transcriptionsAsync),
              ),
            ],
          ),

          // 搜索覆蓋層
          if (_isSearchMode)
            Positioned(
              top: 72, // 搜索框高度 + padding
              left: 0,
              right: 0,
              bottom: 0,
              child: SearchOverlay(
                query: _searchController.text,
                onDismiss: _exitSearchMode,
                onResultTap: _handleSearchResultTap,
              ),
            ),
        ],
      ),
      // 搜索模式下隱藏 FAB
      floatingActionButton: _isSearchMode
          ? null
          : FloatingActionButton.extended(
              onPressed: _handleStartTranscription,
              icon: const Icon(Icons.mic),
              label: Text(l10n.startTranscription),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// 構建搜索欄
  Widget _buildSearchBar() {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          hintText: l10n.searchTranscriptions,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _isSearchMode || _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      _searchController.clear();
                      setState(() {});
                    } else {
                      _exitSearchMode();
                    }
                  },
                )
              : null,
        ),
        onChanged: (_) {
          // 觸發重新構建以更新搜索結果
          setState(() {});
        },
        onTap: () {
          // 點擊搜索框時進入搜索模式
          if (!_isSearchMode) {
            setState(() {
              _isSearchMode = true;
            });
          }
        },
      ),
    );
  }

  /// 構建轉錄列表
  Widget _buildTranscriptionList(
    AsyncValue<List<Transcription>> transcriptionsAsync,
  ) {
    final l10n = AppLocalizations.of(context);
    return transcriptionsAsync.when(
      data: (transcriptions) {
        if (transcriptions.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: transcriptions.length,
          itemBuilder: (context, index) {
            final transcription = transcriptions[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TranscriptionCard(
                transcription: transcription,
                onTap: () => context.push('/detail/${transcription.id}'),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(l10n.loadFailed(error.toString())),
      ),
    );
  }

  /// 構建空狀態
  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mic_none_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noTranscriptions,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tapToStartTranscription,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

/// 語言選擇器底部彈窗
class _LanguageSelectorSheet extends StatefulWidget {
  final void Function(SupportedLanguage language) onLanguageSelected;

  const _LanguageSelectorSheet({required this.onLanguageSelected});

  @override
  State<_LanguageSelectorSheet> createState() => _LanguageSelectorSheetState();
}

class _LanguageSelectorSheetState extends State<_LanguageSelectorSheet> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SupportedLanguage> get _filteredLanguages {
    if (_searchQuery.isEmpty) {
      return SupportedLanguage.values;
    }
    final query = _searchQuery.toLowerCase();
    return SupportedLanguage.values.where((lang) {
      return lang.zhName.toLowerCase().contains(query) ||
          lang.enName.toLowerCase().contains(query) ||
          lang.code.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // 頂部把手
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // 標題
          Text(
            l10n.selectTranscriptionLanguage,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.supportedLanguagesCount(SupportedLanguage.values.length - 1),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),

          // 搜索欄
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchLanguage,
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          const SizedBox(height: 8),

          // 語言列表
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _filteredLanguages.length,
              itemBuilder: (context, index) {
                final language = _filteredLanguages[index];
                final isMulti = language.isMulti;

                // 根據系統語言選擇顯示名稱
                final isZhLocale = Localizations.localeOf(context).languageCode == 'zh';
                final displayName = isZhLocale ? language.zhName : language.enName;

                if (isMulti) {
                  // 多語言自動檢測選項 - 特殊顯示
                  final primaryColor = Theme.of(context).colorScheme.primary;
                  return Card(
                    elevation: 0,
                    color: primaryColor.withOpacity(0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: primaryColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Text(
                            language.flag,
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(
                            displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          trailing: Icon(
                            Icons.auto_awesome,
                            color: primaryColor,
                          ),
                          onTap: () => widget.onLanguageSelected(language),
                        ),
                        // 支持語言提示
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFBA90C6).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFBA90C6).withOpacity(0.4),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Color(0xFF8B5A9C),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.multiLanguageSupportInfo,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // 普通語言選項
                return Card(
                  elevation: 0,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: Text(
                      language.flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(displayName),
                    trailing: Text(
                      language.code,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontFamily: 'monospace',
                      ),
                    ),
                    onTap: () => widget.onLanguageSelected(language),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
