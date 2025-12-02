/// 應用配置
///
/// API Key 透過編譯時環境變數注入，不會存在於源碼中。
/// 
/// 編譯指令範例：
/// ```bash
/// # Debug 運行
/// flutter run --dart-define=DEEPGRAM_API_KEY=your_api_key_here
/// 
/// # Release 編譯
/// flutter build apk --dart-define=DEEPGRAM_API_KEY=your_api_key_here
/// flutter build ios --dart-define=DEEPGRAM_API_KEY=your_api_key_here
/// ```
/// 
/// 獲取 Deepgram API Key：
/// 1. 訪問 https://console.deepgram.com/
/// 2. 註冊/登錄帳號
/// 3. 創建 API Key
/// 免費額度：$200（足夠約 500 小時轉錄）
class AppConfig {
  AppConfig._();

  /// Deepgram API Key（從編譯時環境變數讀取）
  static const String transcriptionApiKey = String.fromEnvironment(
    'DEEPGRAM_API_KEY',
    defaultValue: '',
  );

  /// 檢查 API Key 是否已配置
  static bool get isApiKeyConfigured => transcriptionApiKey.isNotEmpty;
}
