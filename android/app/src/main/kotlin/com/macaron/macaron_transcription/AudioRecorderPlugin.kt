package com.macaron.macaron_transcription

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.nio.ByteBuffer
import java.nio.ByteOrder
import kotlin.concurrent.thread

/**
 * 音頻錄製插件 - 使用 AudioRecord 獲取實時 PCM 音頻流
 */
class AudioRecorderPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, 
    EventChannel.StreamHandler, ActivityAware, PluginRegistry.RequestPermissionsResultListener {

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private var activity: Activity? = null
    
    private var audioRecord: AudioRecord? = null
    private var isRecording = false
    private var recordingThread: Thread? = null
    
    // 音頻參數
    private val sampleRate = 16000
    private val channelConfig = AudioFormat.CHANNEL_IN_MONO
    private val audioFormat = AudioFormat.ENCODING_PCM_16BIT
    
    private var pendingPermissionResult: MethodChannel.Result? = null
    
    companion object {
        private const val PERMISSION_REQUEST_CODE = 1001
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, "com.macaron.transcription/audio")
        methodChannel.setMethodCallHandler(this)
        
        eventChannel = EventChannel(binding.binaryMessenger, "com.macaron.transcription/audio_stream")
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    // MARK: - ActivityAware
    
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    // MARK: - MethodChannel.MethodCallHandler
    
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startRecording" -> startRecording(result)
            "stopRecording" -> stopRecording(result)
            "checkPermission" -> checkPermission(result)
            "requestPermission" -> requestPermission(result)
            else -> result.notImplemented()
        }
    }

    // MARK: - EventChannel.StreamHandler
    
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    // MARK: - 權限處理
    
    private fun checkPermission(result: MethodChannel.Result) {
        val activity = this.activity
        if (activity == null) {
            result.success(false)
            return
        }
        
        val granted = ContextCompat.checkSelfPermission(
            activity,
            Manifest.permission.RECORD_AUDIO
        ) == PackageManager.PERMISSION_GRANTED
        
        result.success(granted)
    }

    private fun requestPermission(result: MethodChannel.Result) {
        val activity = this.activity
        if (activity == null) {
            result.success(false)
            return
        }
        
        if (ContextCompat.checkSelfPermission(activity, Manifest.permission.RECORD_AUDIO) 
            == PackageManager.PERMISSION_GRANTED) {
            result.success(true)
            return
        }
        
        pendingPermissionResult = result
        ActivityCompat.requestPermissions(
            activity,
            arrayOf(Manifest.permission.RECORD_AUDIO),
            PERMISSION_REQUEST_CODE
        )
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        if (requestCode == PERMISSION_REQUEST_CODE) {
            val granted = grantResults.isNotEmpty() && 
                grantResults[0] == PackageManager.PERMISSION_GRANTED
            pendingPermissionResult?.success(granted)
            pendingPermissionResult = null
            return true
        }
        return false
    }

    // MARK: - 錄音控制
    
    private fun startRecording(result: MethodChannel.Result) {
        if (isRecording) {
            result.error("ALREADY_RECORDING", "Already recording", null)
            return
        }

        val activity = this.activity
        if (activity == null) {
            result.error("NO_ACTIVITY", "Activity not available", null)
            return
        }

        // 檢查權限
        if (ContextCompat.checkSelfPermission(activity, Manifest.permission.RECORD_AUDIO) 
            != PackageManager.PERMISSION_GRANTED) {
            result.error("PERMISSION_DENIED", "Microphone permission not granted", null)
            return
        }

        try {
            val bufferSize = AudioRecord.getMinBufferSize(sampleRate, channelConfig, audioFormat)
            
            audioRecord = AudioRecord(
                MediaRecorder.AudioSource.MIC,
                sampleRate,
                channelConfig,
                audioFormat,
                bufferSize * 2
            )

            if (audioRecord?.state != AudioRecord.STATE_INITIALIZED) {
                result.error("INIT_ERROR", "Failed to initialize AudioRecord", null)
                return
            }

            audioRecord?.startRecording()
            isRecording = true

            // 開始錄音線程
            recordingThread = thread {
                val buffer = ShortArray(bufferSize / 2)
                
                while (isRecording) {
                    val readCount = audioRecord?.read(buffer, 0, buffer.size) ?: 0
                    
                    if (readCount > 0) {
                        // 轉換為 ByteArray
                        val byteBuffer = ByteBuffer.allocate(readCount * 2)
                        byteBuffer.order(ByteOrder.LITTLE_ENDIAN)
                        for (i in 0 until readCount) {
                            byteBuffer.putShort(buffer[i])
                        }
                        
                        // 發送到 Flutter
                        val bytes = byteBuffer.array()
                        activity.runOnUiThread {
                            eventSink?.success(bytes)
                        }
                    }
                }
            }

            result.success(null)
        } catch (e: Exception) {
            result.error("START_ERROR", e.message, null)
        }
    }

    private fun stopRecording(result: MethodChannel.Result) {
        isRecording = false
        
        try {
            recordingThread?.join(1000)
            recordingThread = null
            
            audioRecord?.stop()
            audioRecord?.release()
            audioRecord = null
            
            result.success(null)
        } catch (e: Exception) {
            result.error("STOP_ERROR", e.message, null)
        }
    }
}


