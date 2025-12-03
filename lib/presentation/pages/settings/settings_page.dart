import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/providers.dart';

/// 設置頁
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  void _showDefaultLanguageDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _LanguageSettingSheet(
        onLanguageSelected: (language) async {
          Navigator.pop(context);
          await ref
              .read(defaultLanguageNotifierProvider.notifier)
              .setDefaultLanguage(language);
        },
      ),
    );
  }

  Future<void> _openPrivacyPolicy() async {
    final uri =
        Uri.parse('https://macaron-transcription-web.vercel.app/privacy');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultLanguageAsync = ref.watch(defaultLanguageNotifierProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          // 轉錄設置
          _SectionHeader(title: l10n.transcriptionSettings),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.defaultLanguage),
            subtitle: defaultLanguageAsync.when(
              data: (language) => Text(
                language?.zhName ?? l10n.noDefaultLanguage,
                style: TextStyle(
                  color: language == null ? Theme.of(context).hintColor : null,
                ),
              ),
              loading: () => Text(l10n.loading),
              error: (_, __) => Text(l10n.loadFailedSimple),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showDefaultLanguageDialog,
          ),

          const Divider(),

          // 關於
          _SectionHeader(title: l10n.about),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.version),
            subtitle: Text(_version.isEmpty ? '...' : _version),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.privacyPolicy),
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: _openPrivacyPolicy,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

/// 語言設置底部彈窗
class _LanguageSettingSheet extends ConsumerStatefulWidget {
  final void Function(SupportedLanguage? language) onLanguageSelected;

  const _LanguageSettingSheet({required this.onLanguageSelected});

  @override
  ConsumerState<_LanguageSettingSheet> createState() =>
      _LanguageSettingSheetState();
}

class _LanguageSettingSheetState extends ConsumerState<_LanguageSettingSheet> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 獲取過濾後的語言列表
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
    final currentLanguage =
        ref.watch(defaultLanguageNotifierProvider).valueOrNull;
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
            l10n.defaultTranscriptionLanguage,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.autoUseAfterSetting,
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
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
                fillColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withOpacity(0.5),
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
              // +1 是「不設置默認值」選項
              itemCount:
                  _filteredLanguages.length + (_searchQuery.isEmpty ? 1 : 0),
              itemBuilder: (context, index) {
                // 第一項：不設置默認值（僅在無搜索時顯示）
                if (_searchQuery.isEmpty && index == 0) {
                  final isSelected = currentLanguage == null;
                  return Card(
                    elevation: isSelected ? 2 : 0,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.not_interested,
                            color: Colors.grey),
                      ),
                      title: Text(
                        l10n.noDefaultValue,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        l10n.selectLanguageEachTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : null,
                      onTap: () => widget.onLanguageSelected(null),
                    ),
                  );
                }

                // 語言選項
                final languageIndex = _searchQuery.isEmpty ? index - 1 : index;
                final language = _filteredLanguages[languageIndex];
                final isSelected = currentLanguage == language;
                final isMulti = language.isMulti;

                // 根據系統語言選擇顯示名稱
                final isZhLocale =
                    Localizations.localeOf(context).languageCode == 'zh';
                final displayName =
                    isZhLocale ? language.zhName : language.enName;

                if (isMulti) {
                  // 多語言自動檢測選項 - 特殊顯示
                  final primaryColor = Theme.of(context).colorScheme.primary;
                  return Card(
                    elevation: 0,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : primaryColor.withOpacity(0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected
                            ? primaryColor
                            : primaryColor.withOpacity(0.3),
                        width: isSelected ? 2 : 1.5,
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
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: primaryColor,
                                )
                              : Icon(
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.8),
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
                  elevation: isSelected ? 2 : 0,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: Text(
                      language.flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(displayName),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : Text(
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
