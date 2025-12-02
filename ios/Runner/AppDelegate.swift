import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    private var audioRecorderPlugin: AudioRecorderHandler?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // 設置音頻錄製插件
        if let controller = window?.rootViewController as? FlutterViewController {
            audioRecorderPlugin = AudioRecorderHandler(messenger: controller.binaryMessenger)
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

/// 音頻錄製處理器
class AudioRecorderHandler: NSObject, FlutterStreamHandler {
    
    private let methodChannel: FlutterMethodChannel
    private let eventChannel: FlutterEventChannel
    
    private var audioEngine: AVAudioEngine?
    private var eventSink: FlutterEventSink?
    private var isRecording = false
    
    private let sampleRate: Double = 16000
    private let channels: AVAudioChannelCount = 1
    
    init(messenger: FlutterBinaryMessenger) {
        methodChannel = FlutterMethodChannel(
            name: "com.macaron.transcription/audio",
            binaryMessenger: messenger
        )
        eventChannel = FlutterEventChannel(
            name: "com.macaron.transcription/audio_stream",
            binaryMessenger: messenger
        )
        
        super.init()
        
        methodChannel.setMethodCallHandler(handle)
        eventChannel.setStreamHandler(self)
    }
    
    // MARK: - Method Call Handler
    
    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startRecording":
            startRecording(result: result)
        case "stopRecording":
            stopRecording(result: result)
        case "checkPermission":
            checkPermission(result: result)
        case "requestPermission":
            requestPermission(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - FlutterStreamHandler
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    // MARK: - Permission
    
    private func checkPermission(result: @escaping FlutterResult) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            result(true)
        case .denied, .undetermined:
            result(false)
        @unknown default:
            result(false)
        }
    }
    
    private func requestPermission(result: @escaping FlutterResult) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                result(granted)
            }
        }
    }
    
    // MARK: - Recording
    
    private func startRecording(result: @escaping FlutterResult) {
        guard !isRecording else {
            result(FlutterError(code: "ALREADY_RECORDING", message: "Already recording", details: nil))
            return
        }
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(true)
            
            audioEngine = AVAudioEngine()
            guard let audioEngine = audioEngine else {
                result(FlutterError(code: "ENGINE_ERROR", message: "Failed to create audio engine", details: nil))
                return
            }
            
            let inputNode = audioEngine.inputNode
            let inputFormat = inputNode.outputFormat(forBus: 0)
            
            guard let outputFormat = AVAudioFormat(
                commonFormat: .pcmFormatInt16,
                sampleRate: sampleRate,
                channels: channels,
                interleaved: true
            ) else {
                result(FlutterError(code: "FORMAT_ERROR", message: "Failed to create output format", details: nil))
                return
            }
            
            guard let converter = AVAudioConverter(from: inputFormat, to: outputFormat) else {
                result(FlutterError(code: "CONVERTER_ERROR", message: "Failed to create converter", details: nil))
                return
            }
            
            let bufferSize: AVAudioFrameCount = 1024
            inputNode.installTap(onBus: 0, bufferSize: bufferSize, format: inputFormat) { [weak self] buffer, _ in
                self?.processAudioBuffer(buffer: buffer, converter: converter, outputFormat: outputFormat)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            isRecording = true
            result(nil)
            
        } catch {
            result(FlutterError(code: "START_ERROR", message: error.localizedDescription, details: nil))
        }
    }
    
    private func stopRecording(result: @escaping FlutterResult) {
        guard isRecording else {
            result(nil)
            return
        }
        
        audioEngine?.inputNode.removeTap(onBus: 0)
        audioEngine?.stop()
        audioEngine = nil
        isRecording = false
        
        try? AVAudioSession.sharedInstance().setActive(false)
        
        result(nil)
    }
    
    // MARK: - Audio Processing
    
    private func processAudioBuffer(buffer: AVAudioPCMBuffer, converter: AVAudioConverter, outputFormat: AVAudioFormat) {
        guard let eventSink = eventSink else { return }
        
        let ratio = outputFormat.sampleRate / buffer.format.sampleRate
        let outputFrameCapacity = AVAudioFrameCount(Double(buffer.frameLength) * ratio)
        
        guard let outputBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: outputFrameCapacity) else {
            return
        }
        
        var error: NSError?
        let inputBlock: AVAudioConverterInputBlock = { _, outStatus in
            outStatus.pointee = .haveData
            return buffer
        }
        
        converter.convert(to: outputBuffer, error: &error, withInputFrom: inputBlock)
        
        if error != nil { return }
        
        guard let int16Data = outputBuffer.int16ChannelData else { return }
        
        let frameLength = Int(outputBuffer.frameLength)
        let data = Data(bytes: int16Data[0], count: frameLength * 2)
        
        DispatchQueue.main.async {
            eventSink(FlutterStandardTypedData(bytes: data))
        }
    }
}
