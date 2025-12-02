/// 應用常量
class AppConstants {
  AppConstants._();

  /// 音頻參數
  static const int sampleRate = 16000;
  static const int channels = 1;
  static const int bitDepth = 16;

  /// 默認語言
  static const String defaultLanguageCode = 'en';
}

/// 設置 Key
class SettingsKeys {
  SettingsKeys._();

  static const String defaultLanguage = 'default_language';
  static const String theme = 'theme';

  /// 特殊值：表示不設置默認語言（每次都需要選擇）
  static const String noDefaultLanguage = '__NO_DEFAULT__';
}

/// 支持的語言
///
/// Deepgram Nova-3 支持的語言列表（用於自動檢測）
/// Nova-2 支持手動指定語言
/// 文檔: https://developers.deepgram.com/docs/models-languages-overview
enum SupportedLanguage {
  // ═══════════════════════════════════════════════════════════════════════════
  // 自動檢測（使用 Nova-3 模型）
  // ═══════════════════════════════════════════════════════════════════════════
  multi('multi', '多語言自動檢測', 'Multilingual (Auto Detect)'),

  // ═══════════════════════════════════════════════════════════════════════════
  // 中文
  // ═══════════════════════════════════════════════════════════════════════════
  chineseCantonese('zh-HK', '中文（粵語/香港）', 'Chinese (Cantonese, Hong Kong)'),
  chineseMandarin('zh-CN', '中文（普通話/大陸）', 'Chinese (Mandarin, Mainland)'),
  chineseTraditional('zh-TW', '中文（繁體/台灣）', 'Chinese (Traditional, Taiwan)'),

  // ═══════════════════════════════════════════════════════════════════════════
  // 英語
  // ═══════════════════════════════════════════════════════════════════════════
  english('en', '英語', 'English'),
  englishAU('en-AU', '英語（澳洲）', 'English (Australia)'),
  englishIN('en-IN', '英語（印度）', 'English (India)'),
  englishNZ('en-NZ', '英語（紐西蘭）', 'English (New Zealand)'),
  englishGB('en-GB', '英語（英國）', 'English (United Kingdom)'),

  // ═══════════════════════════════════════════════════════════════════════════
  // 東亞語言
  // ═══════════════════════════════════════════════════════════════════════════
  japanese('ja', '日語', 'Japanese'),
  korean('ko', '韓語', 'Korean'),

  // ═══════════════════════════════════════════════════════════════════════════
  // 南亞 / 東南亞語言
  // ═══════════════════════════════════════════════════════════════════════════
  hindi('hi', '印地語', 'Hindi'),
  hindiLatin('hi-Latn', '印地語（拉丁字母）', 'Hindi (Latin)'),
  indonesian('id', '印尼語', 'Indonesian'),
  malay('ms', '馬來語', 'Malay'),
  tamil('ta', '泰米爾語', 'Tamil'),
  thai('th', '泰語', 'Thai'),
  vietnamese('vi', '越南語', 'Vietnamese'),

  // ═══════════════════════════════════════════════════════════════════════════
  // 西歐語言
  // ═══════════════════════════════════════════════════════════════════════════
  french('fr', '法語', 'French'),
  frenchCA('fr-CA', '法語（加拿大）', 'French (Canada)'),
  german('de', '德語', 'German'),
  germanCH('de-CH', '德語（瑞士）', 'German (Switzerland)'),
  dutch('nl', '荷蘭語', 'Dutch'),
  dutchBE('nl-BE', '荷蘭語（比利時）', 'Dutch (Belgium)'),
  italian('it', '意大利語', 'Italian'),
  catalan('ca', '加泰羅尼亞語', 'Catalan'),

  // ═══════════════════════════════════════════════════════════════════════════
  // 伊比利亞語言
  // ═══════════════════════════════════════════════════════════════════════════
  spanish('es', '西班牙語', 'Spanish'),
  spanishLatam(
      'es-419', '西班牙語（拉丁美洲）', 'Spanish (Latin America and the Caribbean)'),
  portuguese('pt', '葡萄牙語', 'Portuguese'),
  portugueseBR('pt-BR', '葡萄牙語（巴西）', 'Portuguese (Brazil)'),
  portuguesePT('pt-PT', '葡萄牙語（葡萄牙）', 'Portuguese (Portugal)'),

  // ═══════════════════════════════════════════════════════════════════════════
  // 北歐語言
  // ═══════════════════════════════════════════════════════════════════════════
  danish('da', '丹麥語', 'Danish'),
  finnish('fi', '芬蘭語', 'Finnish'),
  norwegian('no', '挪威語', 'Norwegian'),
  swedish('sv', '瑞典語', 'Swedish'),

  // ═══════════════════════════════════════════════════════════════════════════
  // 東歐語言
  // ═══════════════════════════════════════════════════════════════════════════
  bulgarian('bg', '保加利亞語', 'Bulgarian'),
  czech('cs', '捷克語', 'Czech'),
  estonian('et', '愛沙尼亞語', 'Estonian'),
  hungarian('hu', '匈牙利語', 'Hungarian'),
  latvian('lv', '拉脫維亞語', 'Latvian'),
  lithuanian('lt', '立陶宛語', 'Lithuanian'),
  polish('pl', '波蘭語', 'Polish'),
  romanian('ro', '羅馬尼亞語', 'Romanian'),
  russian('ru', '俄語', 'Russian'),
  slovak('sk', '斯洛伐克語', 'Slovak'),
  ukrainian('uk', '烏克蘭語', 'Ukrainian'),

  // ═══════════════════════════════════════════════════════════════════════════
  // 其他歐洲語言
  // ═══════════════════════════════════════════════════════════════════════════
  greek('el', '希臘語', 'Modern Greek'),
  turkish('tr', '土耳其語', 'Turkish'),

  // ═══════════════════════════════════════════════════════════════════════════
  // 其他語言
  // ═══════════════════════════════════════════════════════════════════════════
  tamasheq('taq', '塔馬舍克語', 'Tamasheq'),
  ;

  final String code;
  final String zhName;
  final String enName;

  const SupportedLanguage(this.code, this.zhName, this.enName);

  String get displayName => enName;

  /// 是否為自動檢測模式
  bool get isMulti => this == SupportedLanguage.multi;

  /// 獲取語言的區域標誌 emoji
  String get flag {
    switch (this) {
      case SupportedLanguage.multi:
        return '🌍';
      case SupportedLanguage.chineseCantonese:
        return '🇭🇰';
      case SupportedLanguage.chineseMandarin:
        return '🇨🇳';
      case SupportedLanguage.chineseTraditional:
        return '🇨🇳';
      case SupportedLanguage.english:
        return '🇺🇸';
      case SupportedLanguage.englishAU:
        return '🇦🇺';
      case SupportedLanguage.englishIN:
        return '🇮🇳';
      case SupportedLanguage.englishNZ:
        return '🇳🇿';
      case SupportedLanguage.englishGB:
        return '🇬🇧';
      case SupportedLanguage.japanese:
        return '🇯🇵';
      case SupportedLanguage.korean:
        return '🇰🇷';
      case SupportedLanguage.hindi:
      case SupportedLanguage.hindiLatin:
        return '🇮🇳';
      case SupportedLanguage.indonesian:
        return '🇮🇩';
      case SupportedLanguage.malay:
        return '🇲🇾';
      case SupportedLanguage.tamil:
        return '🇮🇳';
      case SupportedLanguage.thai:
        return '🇹🇭';
      case SupportedLanguage.vietnamese:
        return '🇻🇳';
      case SupportedLanguage.french:
      case SupportedLanguage.frenchCA:
        return '🇫🇷';
      case SupportedLanguage.german:
      case SupportedLanguage.germanCH:
        return '🇩🇪';
      case SupportedLanguage.dutch:
        return '🇳🇱';
      case SupportedLanguage.dutchBE:
        return '🇧🇪';
      case SupportedLanguage.italian:
        return '🇮🇹';
      case SupportedLanguage.catalan:
        return '🇪🇸';
      case SupportedLanguage.spanish:
      case SupportedLanguage.spanishLatam:
        return '🇪🇸';
      case SupportedLanguage.portuguese:
        return '🇵🇹';
      case SupportedLanguage.portugueseBR:
        return '🇧🇷';
      case SupportedLanguage.portuguesePT:
        return '🇵🇹';
      case SupportedLanguage.danish:
        return '🇩🇰';
      case SupportedLanguage.finnish:
        return '🇫🇮';
      case SupportedLanguage.norwegian:
        return '🇳🇴';
      case SupportedLanguage.swedish:
        return '🇸🇪';
      case SupportedLanguage.bulgarian:
        return '🇧🇬';
      case SupportedLanguage.czech:
        return '🇨🇿';
      case SupportedLanguage.estonian:
        return '🇪🇪';
      case SupportedLanguage.hungarian:
        return '🇭🇺';
      case SupportedLanguage.latvian:
        return '🇱🇻';
      case SupportedLanguage.lithuanian:
        return '🇱🇹';
      case SupportedLanguage.polish:
        return '🇵🇱';
      case SupportedLanguage.romanian:
        return '🇷🇴';
      case SupportedLanguage.russian:
        return '🇷🇺';
      case SupportedLanguage.slovak:
        return '🇸🇰';
      case SupportedLanguage.ukrainian:
        return '🇺🇦';
      case SupportedLanguage.greek:
        return '🇬🇷';
      case SupportedLanguage.turkish:
        return '🇹🇷';
      case SupportedLanguage.tamasheq:
        return '🏜️';
    }
  }
}
