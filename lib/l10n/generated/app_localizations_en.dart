// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Macaron - AI Transcription';

  @override
  String get appName => 'Macaron';

  @override
  String get startTranscription => 'Start Transcription';

  @override
  String get searchTranscriptions => 'Search transcriptions...';

  @override
  String loadFailed(String error) {
    return 'Load failed: $error';
  }

  @override
  String get noTranscriptions => 'No transcriptions yet';

  @override
  String get tapToStartTranscription => 'Tap the button below to start';

  @override
  String get selectTranscriptionLanguage => 'Select Language';

  @override
  String supportedLanguagesCount(int count) {
    return 'Supports $count languages';
  }

  @override
  String get searchLanguage => 'Search language...';

  @override
  String get multiLanguageSupportInfo =>
      'Only supports: English, Spanish, French, German, Hindi, Russian, Portuguese, Japanese, Italian, Dutch';

  @override
  String get settings => 'Settings';

  @override
  String get transcriptionSettings => 'Transcription Settings';

  @override
  String get defaultLanguage => 'Default Language';

  @override
  String get noDefaultLanguage => 'No default (select each time)';

  @override
  String get loading => 'Loading...';

  @override
  String get loadFailedSimple => 'Load failed';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get defaultTranscriptionLanguage => 'Default Transcription Language';

  @override
  String get autoUseAfterSetting =>
      'Will be used automatically for each transcription';

  @override
  String get noDefaultValue => 'No default';

  @override
  String get selectLanguageEachTime => 'Select language each time';

  @override
  String startRecordingFailed(String error) {
    return 'Failed to start recording: $error';
  }

  @override
  String get saved => 'Saved';

  @override
  String get recording => 'Recording';

  @override
  String get recordingInProgressMessage =>
      'Recording in progress. What would you like to do?';

  @override
  String get cancel => 'Cancel';

  @override
  String get stopRecording => 'Stop Recording';

  @override
  String get unsavedContent => 'Unsaved Content';

  @override
  String get unsavedContentMessage =>
      'You have unsaved transcription. Save it?';

  @override
  String get discard => 'Discard';

  @override
  String get save => 'Save';

  @override
  String get preparing => 'Preparing';

  @override
  String get connecting => 'Connecting...';

  @override
  String get realTimeTranscription => 'Live Transcription';

  @override
  String get stopping => 'Stopping...';

  @override
  String get transcriptionComplete => 'Transcription Complete';

  @override
  String get errorOccurred => 'Error Occurred';

  @override
  String get recordingStatus => 'Recording';

  @override
  String get stopped => 'Stopped';

  @override
  String get titleOptional => 'Title (optional)';

  @override
  String get enterTranscriptionTitle => 'Enter transcription title';

  @override
  String get continueRecording => 'Continue';

  @override
  String get retry => 'Retry';

  @override
  String renameSpeaker(String label) {
    return 'Rename Speaker $label';
  }

  @override
  String get name => 'Name';

  @override
  String get enterSpeakerName => 'Enter speaker name';

  @override
  String get confirm => 'Confirm';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get confirmDeleteMessage =>
      'Are you sure you want to delete this transcription? This action cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String speakerLabel(String label) {
    return 'Speaker $label';
  }

  @override
  String get transcriptionDetail => 'Transcription Detail';

  @override
  String get error => 'Error';

  @override
  String get transcriptionNotFound => 'Transcription not found';

  @override
  String get noTranscriptionContent => 'No transcription content';

  @override
  String get pause => 'Pause';

  @override
  String get playThisSegment => 'Play this segment';

  @override
  String get stop => 'Stop';

  @override
  String get play => 'Play';

  @override
  String get enterKeywordToSearch => 'Enter keyword to search transcriptions';

  @override
  String get tapEmptyToExit => 'Tap empty area to exit search';

  @override
  String get searchError => 'Search error';

  @override
  String notFound(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get tryOtherKeywords => 'Try other keywords';

  @override
  String foundResults(int count) {
    return 'Found $count results';
  }

  @override
  String get unnamedTranscription => 'Unnamed transcription';

  @override
  String durationMinutesSeconds(int minutes, int seconds) {
    return '$minutes min $seconds sec';
  }

  @override
  String durationSeconds(int seconds) {
    return '$seconds sec';
  }

  @override
  String speakerCount(int count) {
    return '$count speakers';
  }

  @override
  String get errorPleaseRetry => 'Error occurred, please retry';

  @override
  String get startSpeaking => 'Start speaking...';

  @override
  String get ready => 'Ready';

  @override
  String get typing => 'Typing...';

  @override
  String audioFileNotFound(String path) {
    return 'Audio file not found: $path';
  }

  @override
  String loadAudioFailed(String error) {
    return 'Failed to load audio: $error';
  }

  @override
  String get noAudioLoaded => 'No audio file loaded';
}
