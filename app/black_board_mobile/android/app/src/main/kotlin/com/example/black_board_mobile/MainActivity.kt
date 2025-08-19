package com.example.black_board_mobile

import android.Manifest
import android.content.pm.PackageManager
import android.media.*
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.github.jaredmdobson.concentus.OpusDecoder
import io.github.jaredmdobson.concentus.OpusEncoder
import androidx.lifecycle.lifecycleScope
import io.flutter.Log
import kotlinx.coroutines.launch
import kotlinx.coroutines.*
import kotlin.math.sqrt
import android.media.audiofx.AcousticEchoCanceler
import android.media.audiofx.AutomaticGainControl
import android.media.audiofx.NoiseSuppressor

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL_NAME = "com.example.black_board_mobile/method"
    private val EVENT_CHANNEL_NAME = "com.example.black_board_mobile/event"

    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null

    // بخش ارسال (ضبط و انکود)
    private var audioRecord: AudioRecord? = null

    private var noiseSuppressor: NoiseSuppressor? = null
    private var acousticEchoCanceler: AcousticEchoCanceler? = null
    private var automaticGainControl: AutomaticGainControl? = null
    private var opusEncoder: OpusEncoder? = null
    private var recordingJob: Job? = null

    // بخش دریافت (دیکود و پخش)
    private var audioTrack: AudioTrack? = null
    private var opusDecoder: OpusDecoder? = null

    // تنظیمات مشترک صدا
    private val sampleRate = 16000
    private val channelConfigRecord = AudioFormat.CHANNEL_IN_MONO
    private val channelConfigPlay = AudioFormat.CHANNEL_OUT_MONO
    private val audioFormat = AudioFormat.ENCODING_PCM_16BIT

    private val vadThreshold = 800.0
    private val frameSize = 320 // 20ms of audio at 16kHz
    private val recordBufferSize =
        AudioRecord.getMinBufferSize(sampleRate, channelConfigRecord, audioFormat)
    private val playBufferSize =
        AudioTrack.getMinBufferSize(sampleRate, channelConfigPlay, audioFormat) * 4


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_NAME)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startStreaming" -> {
                    if (checkMicPermission()) {
                        // شروع فرآیندهای ضبط و پخش
                        startAudioEngine()
                        result.success("Audio engine started.")
                    } else {
                        requestMicPermission()
                        result.error("PERMISSION_DENIED", "Microphone permission needed.", null)
                    }
                }

                "stopStreaming" -> {
                    // توقف تمام فرآیندها
                    stopAudioEngine()
                    result.success("Audio engine stopped.")
                }

                "sendDataToKotlin" -> {
                    // دریافت داده Opus از فلاتر و ارسال برای پخش
                    val opusData = call.argument<ByteArray>("data")
                    if (opusData != null) {
                        handleReceivedOpusData(opusData)
                    }
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }

        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL_NAME)
        eventChannel?.setStreamHandler(AudioStreamHandler())
    }

    private inner class AudioStreamHandler : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            // این متد زمانی اجرا می‌شود که فلاتر آماده دریافت داده است
            // ما فرآیند ضبط را در متد startAudioEngine مدیریت می‌کنیم
            // اما به eventSink برای ارسال داده نیاز داریم
            startRecording(events)
        }

        override fun onCancel(arguments: Any?) {
            stopRecording()
        }
    }

    private fun startAudioEngine() {
        // ۱. مقداردهی اولیه دیکودر و پلیر (برای دریافت)
        opusDecoder = OpusDecoder(sampleRate, 1)
        audioTrack = AudioTrack.Builder()
            .setAudioAttributes(
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                    .build()
            )
            .setAudioFormat(
                AudioFormat.Builder()
                    .setEncoding(audioFormat)
                    .setSampleRate(sampleRate)
                    .setChannelMask(channelConfigPlay)
                    .build()
            )
            .setBufferSizeInBytes(playBufferSize)
            .setTransferMode(AudioTrack.MODE_STREAM)
            .build()
        audioTrack?.play()
    }

    private fun isSpeech(pcmData: ShortArray): Boolean {
        // محاسبه انرژی فریم صوتی (RMS)
        var sumOfSquares = 0.0
        for (sample in pcmData) {
            // برای جلوگیری از سرریز شدن، به Double تبدیل می‌کنیم
            val sampleAsDouble = sample.toDouble()
            sumOfSquares += sampleAsDouble * sampleAsDouble
        }
        val rms = sqrt(sumOfSquares / pcmData.size)

        // برای دیباگ و تنظیم آستانه، مقدار rms را چاپ می‌کنیم
        // println("VAD RMS: $rms")

        // اگر انرژی از آستانه بالاتر بود، گفتار است
        return rms > vadThreshold
    }

    private fun stopAudioEngine() {
        // توقف پلیر
        audioTrack?.let {
            try {
                if (it.playState == AudioTrack.PLAYSTATE_PLAYING) {
                    it.stop()
                }
                it.release()
            } catch (e: IllegalStateException) {
                Log.e("AudioTrack", "Failed to stop/release AudioTrack", e)
            }
        }
        audioTrack = null
        opusDecoder = null
        Log.d("AudioEngine", "Playback resources stopped and released.")
    }

    private fun startRecording(eventSink: EventChannel.EventSink?) {
        if (eventSink == null) return
        stopRecording()

        opusEncoder = OpusEncoder(
            sampleRate,
            1,
            io.github.jaredmdobson.concentus.OpusApplication.OPUS_APPLICATION_VOIP
        )
        opusEncoder?.useDTX = true
        opusEncoder?.useVBR = true
        opusEncoder?.bitrate = 16000
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.RECORD_AUDIO
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return
        }
        audioRecord = AudioRecord(
            MediaRecorder.AudioSource.MIC,
            sampleRate,
            channelConfigRecord,
            audioFormat,
            recordBufferSize
        )
        val audioSessionId = audioRecord?.audioSessionId ?: -1
        if (audioSessionId != -1) {
            if (NoiseSuppressor.isAvailable()) {
                noiseSuppressor = NoiseSuppressor.create(audioSessionId)
                noiseSuppressor?.enabled = true
                Log.d("AudioFX", "NoiseSuppressor enabled.")
            } else {
                Log.d("AudioFX", "NoiseSuppressor not available.")
            }

            if (AcousticEchoCanceler.isAvailable()) {
                acousticEchoCanceler = AcousticEchoCanceler.create(audioSessionId)
                acousticEchoCanceler?.enabled = true
                Log.d("AudioFX", "AcousticEchoCanceler enabled.")
            } else {
                Log.d("AudioFX", "AcousticEchoCanceler not available.")
            }

            if (AutomaticGainControl.isAvailable()) {
                automaticGainControl = AutomaticGainControl.create(audioSessionId)
                automaticGainControl?.enabled = true
                Log.d("AudioFX", "AutomaticGainControl enabled.")
            } else {
                Log.d("AudioFX", "AutomaticGainControl not available.")
            }
        }
        audioRecord?.startRecording()

        recordingJob = lifecycleScope.launch(Dispatchers.IO) {
            val pcmBuffer = ShortArray(frameSize)
            val opusBuffer = ByteArray(1024)

            while (isActive) {
                try {
                    val bytesRead = audioRecord?.read(pcmBuffer, 0, frameSize) ?: 0
                    if (bytesRead > 0) {
                        if (isSpeech(pcmBuffer)) {
                            val encodedBytes = opusEncoder?.encode(
                                pcmBuffer,
                                0,
                                frameSize,
                                opusBuffer,
                                0,
                                opusBuffer.size
                            ) ?: 0
                            if (encodedBytes > 0) {
                                withContext(Dispatchers.Main) {
                                    if (isActive) {
                                        eventSink.success(opusBuffer.copyOfRange(0, encodedBytes))
                                    }
                                }
                            }
                        }
                    } else if (bytesRead < 0) {
                        Log.e("AudioRecord", "Error reading audio data: $bytesRead")
                        break
                    }
                } catch (e: Exception) {
                    Log.e("RecordingJob", "Exception in recording loop", e)
                    break
                }
            }
            Log.d("RecordingJob", "Recording loop finished.")
        }
    }

    private fun stopRecording() {
        recordingJob?.cancel()
        recordingJob = null
        noiseSuppressor?.release()
        acousticEchoCanceler?.release()
        automaticGainControl?.release()
        noiseSuppressor = null
        acousticEchoCanceler = null
        automaticGainControl = null
        audioRecord?.let {
            try {
                if (it.recordingState == AudioRecord.RECORDSTATE_RECORDING) {
                    it.stop()
                }
                it.release()
            } catch (e: IllegalStateException) {
                Log.e("AudioRecord", "Failed to stop/release AudioRecord", e)
            }
        }
        audioRecord = null
        opusEncoder = null
        Log.d("AudioEngine", "Recording resources stopped and released.")
    }

    private fun handleReceivedOpusData(opusData: ByteArray) {
        val pcmBuffer = ShortArray(frameSize)
        val decodedSamples =
            opusDecoder?.decode(opusData, 0, opusData.size, pcmBuffer, 0, frameSize, false) ?: 0
        if (decodedSamples > 0) {
            audioTrack?.write(pcmBuffer, 0, decodedSamples)
        }
    }

    private fun checkMicPermission(): Boolean {
        return ActivityCompat.checkSelfPermission(
            this,
            Manifest.permission.RECORD_AUDIO
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestMicPermission() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.RECORD_AUDIO),
            101
        )
    }

    override fun onDestroy() {
        stopAudioEngine()
        stopRecording()
        methodChannel?.setMethodCallHandler(null)
        eventChannel?.setStreamHandler(null)
        super.onDestroy()
    }
}