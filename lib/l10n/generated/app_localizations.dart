import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// 应用标题
  ///
  /// In zh, this message translates to:
  /// **'Macaron - AI 转录'**
  String get appTitle;

  /// 应用名称
  ///
  /// In zh, this message translates to:
  /// **'Macaron'**
  String get appName;

  /// 开始转录按钮
  ///
  /// In zh, this message translates to:
  /// **'开始转录'**
  String get startTranscription;

  /// 搜索框提示文字
  ///
  /// In zh, this message translates to:
  /// **'搜索转录记录...'**
  String get searchTranscriptions;

  /// 加载失败错误信息
  ///
  /// In zh, this message translates to:
  /// **'加载失败: {error}'**
  String loadFailed(String error);

  /// 空状态标题
  ///
  /// In zh, this message translates to:
  /// **'还没有转录记录'**
  String get noTranscriptions;

  /// 空状态提示
  ///
  /// In zh, this message translates to:
  /// **'点击下方按钮开始转录'**
  String get tapToStartTranscription;

  /// 语言选择器标题
  ///
  /// In zh, this message translates to:
  /// **'选择转录语言'**
  String get selectTranscriptionLanguage;

  /// 支持的语言数量
  ///
  /// In zh, this message translates to:
  /// **'支持 {count} 种语言'**
  String supportedLanguagesCount(int count);

  /// 搜索语言提示文字
  ///
  /// In zh, this message translates to:
  /// **'搜索语言...'**
  String get searchLanguage;

  /// 多语言自动检测支持的语言列表
  ///
  /// In zh, this message translates to:
  /// **'仅支持: English, Spanish, French, German, Hindi, Russian, Portuguese, Japanese, Italian, Dutch'**
  String get multiLanguageSupportInfo;

  /// 设置页标题
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settings;

  /// 转录设置分区标题
  ///
  /// In zh, this message translates to:
  /// **'转录设置'**
  String get transcriptionSettings;

  /// 默认语言设置项
  ///
  /// In zh, this message translates to:
  /// **'默认语言'**
  String get defaultLanguage;

  /// 不设置默认语言选项
  ///
  /// In zh, this message translates to:
  /// **'不设置默认值（每次选择）'**
  String get noDefaultLanguage;

  /// 加载中状态
  ///
  /// In zh, this message translates to:
  /// **'加载中...'**
  String get loading;

  /// 简单的加载失败提示
  ///
  /// In zh, this message translates to:
  /// **'加载失败'**
  String get loadFailedSimple;

  /// 关于分区标题
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get about;

  /// 版本信息
  ///
  /// In zh, this message translates to:
  /// **'版本'**
  String get version;

  /// 隐私政策链接
  ///
  /// In zh, this message translates to:
  /// **'隐私政策'**
  String get privacyPolicy;

  /// 服务条款链接
  ///
  /// In zh, this message translates to:
  /// **'服务条款'**
  String get termsOfService;

  /// 默认转录语言设置标题
  ///
  /// In zh, this message translates to:
  /// **'默认转录语言'**
  String get defaultTranscriptionLanguage;

  /// 默认语言设置说明
  ///
  /// In zh, this message translates to:
  /// **'设置后每次开始转录将自动使用'**
  String get autoUseAfterSetting;

  /// 不设置默认值选项标题
  ///
  /// In zh, this message translates to:
  /// **'不设置默认值'**
  String get noDefaultValue;

  /// 不设置默认值选项说明
  ///
  /// In zh, this message translates to:
  /// **'每次开始转录时选择语言'**
  String get selectLanguageEachTime;

  /// 启动录音失败错误信息
  ///
  /// In zh, this message translates to:
  /// **'启动录音失败: {error}'**
  String startRecordingFailed(String error);

  /// 保存成功提示
  ///
  /// In zh, this message translates to:
  /// **'已保存'**
  String get saved;

  /// 录音中对话框标题
  ///
  /// In zh, this message translates to:
  /// **'正在录音'**
  String get recording;

  /// 录音中对话框内容
  ///
  /// In zh, this message translates to:
  /// **'录音进行中，要如何处理？'**
  String get recordingInProgressMessage;

  /// 取消按钮
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// 停止录音按钮
  ///
  /// In zh, this message translates to:
  /// **'停止录音'**
  String get stopRecording;

  /// 未保存内容对话框标题
  ///
  /// In zh, this message translates to:
  /// **'未保存的内容'**
  String get unsavedContent;

  /// 未保存内容对话框内容
  ///
  /// In zh, this message translates to:
  /// **'有未保存的转录内容，要保存吗？'**
  String get unsavedContentMessage;

  /// 放弃按钮
  ///
  /// In zh, this message translates to:
  /// **'放弃'**
  String get discard;

  /// 保存按钮
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// 准备中状态
  ///
  /// In zh, this message translates to:
  /// **'准备中'**
  String get preparing;

  /// 连接中状态
  ///
  /// In zh, this message translates to:
  /// **'连接中...'**
  String get connecting;

  /// 实时转录状态
  ///
  /// In zh, this message translates to:
  /// **'实时转录'**
  String get realTimeTranscription;

  /// 停止中状态
  ///
  /// In zh, this message translates to:
  /// **'停止中...'**
  String get stopping;

  /// 转录完成状态
  ///
  /// In zh, this message translates to:
  /// **'转录完成'**
  String get transcriptionComplete;

  /// 发生错误状态
  ///
  /// In zh, this message translates to:
  /// **'发生错误'**
  String get errorOccurred;

  /// 录音中状态指示
  ///
  /// In zh, this message translates to:
  /// **'录音中'**
  String get recordingStatus;

  /// 已停止状态
  ///
  /// In zh, this message translates to:
  /// **'已停止'**
  String get stopped;

  /// 标题输入框标签
  ///
  /// In zh, this message translates to:
  /// **'标题（可选）'**
  String get titleOptional;

  /// 标题输入框提示
  ///
  /// In zh, this message translates to:
  /// **'输入转录标题'**
  String get enterTranscriptionTitle;

  /// 继续录音按钮
  ///
  /// In zh, this message translates to:
  /// **'继续'**
  String get continueRecording;

  /// 重试按钮
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get retry;

  /// 重命名说话人对话框标题
  ///
  /// In zh, this message translates to:
  /// **'重命名 Speaker {label}'**
  String renameSpeaker(String label);

  /// 名称输入框标签
  ///
  /// In zh, this message translates to:
  /// **'名称'**
  String get name;

  /// 说话人名称输入框提示
  ///
  /// In zh, this message translates to:
  /// **'输入说话人名称'**
  String get enterSpeakerName;

  /// 确定按钮
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get confirm;

  /// 确认删除对话框标题
  ///
  /// In zh, this message translates to:
  /// **'确认删除'**
  String get confirmDelete;

  /// 确认删除对话框内容
  ///
  /// In zh, this message translates to:
  /// **'确定要删除这个转录记录吗？此操作无法恢复。'**
  String get confirmDeleteMessage;

  /// 删除按钮
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// 说话人标签
  ///
  /// In zh, this message translates to:
  /// **'Speaker {label}'**
  String speakerLabel(String label);

  /// 转录详情页标题
  ///
  /// In zh, this message translates to:
  /// **'转录详情'**
  String get transcriptionDetail;

  /// 错误状态
  ///
  /// In zh, this message translates to:
  /// **'错误'**
  String get error;

  /// 找不到转录记录提示
  ///
  /// In zh, this message translates to:
  /// **'找不到转录记录'**
  String get transcriptionNotFound;

  /// 没有转录内容提示
  ///
  /// In zh, this message translates to:
  /// **'没有转录内容'**
  String get noTranscriptionContent;

  /// 暂停按钮提示
  ///
  /// In zh, this message translates to:
  /// **'暂停'**
  String get pause;

  /// 播放此段按钮提示
  ///
  /// In zh, this message translates to:
  /// **'播放此段'**
  String get playThisSegment;

  /// 停止按钮提示
  ///
  /// In zh, this message translates to:
  /// **'停止'**
  String get stop;

  /// 播放按钮提示
  ///
  /// In zh, this message translates to:
  /// **'播放'**
  String get play;

  /// 搜索空状态提示
  ///
  /// In zh, this message translates to:
  /// **'输入关键字搜索转录内容'**
  String get enterKeywordToSearch;

  /// 退出搜索提示
  ///
  /// In zh, this message translates to:
  /// **'点击空白处退出搜索'**
  String get tapEmptyToExit;

  /// 搜索出错提示
  ///
  /// In zh, this message translates to:
  /// **'搜索出错'**
  String get searchError;

  /// 搜索无结果提示
  ///
  /// In zh, this message translates to:
  /// **'找不到「{query}」'**
  String notFound(String query);

  /// 尝试其他关键字提示
  ///
  /// In zh, this message translates to:
  /// **'尝试其他关键字'**
  String get tryOtherKeywords;

  /// 搜索结果数量
  ///
  /// In zh, this message translates to:
  /// **'找到 {count} 个结果'**
  String foundResults(int count);

  /// 未命名的转录记录
  ///
  /// In zh, this message translates to:
  /// **'未命名转录'**
  String get unnamedTranscription;

  /// 时长格式（分秒）
  ///
  /// In zh, this message translates to:
  /// **'{minutes} 分 {seconds} 秒'**
  String durationMinutesSeconds(int minutes, int seconds);

  /// 时长格式（仅秒）
  ///
  /// In zh, this message translates to:
  /// **'{seconds} 秒'**
  String durationSeconds(int seconds);

  /// 说话人数量
  ///
  /// In zh, this message translates to:
  /// **'{count} 人'**
  String speakerCount(int count);

  /// 错误重试提示
  ///
  /// In zh, this message translates to:
  /// **'发生错误，请重试'**
  String get errorPleaseRetry;

  /// 开始说话提示
  ///
  /// In zh, this message translates to:
  /// **'开始说话...'**
  String get startSpeaking;

  /// 准备就绪状态
  ///
  /// In zh, this message translates to:
  /// **'准备就绪'**
  String get ready;

  /// 正在输入指示器
  ///
  /// In zh, this message translates to:
  /// **'正在输入...'**
  String get typing;

  /// 音频文件不存在错误
  ///
  /// In zh, this message translates to:
  /// **'音频文件不存在: {path}'**
  String audioFileNotFound(String path);

  /// 加载音频失败错误
  ///
  /// In zh, this message translates to:
  /// **'加载音频失败: {error}'**
  String loadAudioFailed(String error);

  /// 没有加载音频文件错误
  ///
  /// In zh, this message translates to:
  /// **'没有加载音频文件'**
  String get noAudioLoaded;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
