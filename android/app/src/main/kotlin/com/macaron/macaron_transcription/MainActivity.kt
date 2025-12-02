package com.macaron.macaron_transcription

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // 註冊音頻錄製插件
        flutterEngine.plugins.add(AudioRecorderPlugin())
    }
}
