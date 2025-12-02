// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Macaron - AI 转录';

  @override
  String get appName => 'Macaron';

  @override
  String get startTranscription => '开始转录';

  @override
  String get searchTranscriptions => '搜索转录记录...';

  @override
  String loadFailed(String error) {
    return '加载失败: $error';
  }

  @override
  String get noTranscriptions => '还没有转录记录';

  @override
  String get tapToStartTranscription => '点击下方按钮开始转录';

  @override
  String get selectTranscriptionLanguage => '选择转录语言';

  @override
  String supportedLanguagesCount(int count) {
    return '支持 $count 种语言';
  }

  @override
  String get searchLanguage => '搜索语言...';

  @override
  String get multiLanguageSupportInfo =>
      '仅支持: English, Spanish, French, German, Hindi, Russian, Portuguese, Japanese, Italian, Dutch';

  @override
  String get settings => '设置';

  @override
  String get transcriptionSettings => '转录设置';

  @override
  String get defaultLanguage => '默认语言';

  @override
  String get noDefaultLanguage => '不设置默认值（每次选择）';

  @override
  String get loading => '加载中...';

  @override
  String get loadFailedSimple => '加载失败';

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsOfService => '服务条款';

  @override
  String get defaultTranscriptionLanguage => '默认转录语言';

  @override
  String get autoUseAfterSetting => '设置后每次开始转录将自动使用';

  @override
  String get noDefaultValue => '不设置默认值';

  @override
  String get selectLanguageEachTime => '每次开始转录时选择语言';

  @override
  String startRecordingFailed(String error) {
    return '启动录音失败: $error';
  }

  @override
  String get saved => '已保存';

  @override
  String get recording => '正在录音';

  @override
  String get recordingInProgressMessage => '录音进行中，要如何处理？';

  @override
  String get cancel => '取消';

  @override
  String get stopRecording => '停止录音';

  @override
  String get unsavedContent => '未保存的内容';

  @override
  String get unsavedContentMessage => '有未保存的转录内容，要保存吗？';

  @override
  String get discard => '放弃';

  @override
  String get save => '保存';

  @override
  String get preparing => '准备中';

  @override
  String get connecting => '连接中...';

  @override
  String get realTimeTranscription => '实时转录';

  @override
  String get stopping => '停止中...';

  @override
  String get transcriptionComplete => '转录完成';

  @override
  String get errorOccurred => '发生错误';

  @override
  String get recordingStatus => '录音中';

  @override
  String get stopped => '已停止';

  @override
  String get titleOptional => '标题（可选）';

  @override
  String get enterTranscriptionTitle => '输入转录标题';

  @override
  String get continueRecording => '继续';

  @override
  String get retry => '重试';

  @override
  String renameSpeaker(String label) {
    return '重命名 Speaker $label';
  }

  @override
  String get name => '名称';

  @override
  String get enterSpeakerName => '输入说话人名称';

  @override
  String get confirm => '确定';

  @override
  String get confirmDelete => '确认删除';

  @override
  String get confirmDeleteMessage => '确定要删除这个转录记录吗？此操作无法恢复。';

  @override
  String get delete => '删除';

  @override
  String speakerLabel(String label) {
    return 'Speaker $label';
  }

  @override
  String get transcriptionDetail => '转录详情';

  @override
  String get error => '错误';

  @override
  String get transcriptionNotFound => '找不到转录记录';

  @override
  String get noTranscriptionContent => '没有转录内容';

  @override
  String get pause => '暂停';

  @override
  String get playThisSegment => '播放此段';

  @override
  String get stop => '停止';

  @override
  String get play => '播放';

  @override
  String get enterKeywordToSearch => '输入关键字搜索转录内容';

  @override
  String get tapEmptyToExit => '点击空白处退出搜索';

  @override
  String get searchError => '搜索出错';

  @override
  String notFound(String query) {
    return '找不到「$query」';
  }

  @override
  String get tryOtherKeywords => '尝试其他关键字';

  @override
  String foundResults(int count) {
    return '找到 $count 个结果';
  }

  @override
  String get unnamedTranscription => '未命名转录';

  @override
  String durationMinutesSeconds(int minutes, int seconds) {
    return '$minutes 分 $seconds 秒';
  }

  @override
  String durationSeconds(int seconds) {
    return '$seconds 秒';
  }

  @override
  String speakerCount(int count) {
    return '$count 人';
  }

  @override
  String get errorPleaseRetry => '发生错误，请重试';

  @override
  String get startSpeaking => '开始说话...';

  @override
  String get ready => '准备就绪';

  @override
  String get typing => '正在输入...';

  @override
  String audioFileNotFound(String path) {
    return '音频文件不存在: $path';
  }

  @override
  String loadAudioFailed(String error) {
    return '加载音频失败: $error';
  }

  @override
  String get noAudioLoaded => '没有加载音频文件';
}
