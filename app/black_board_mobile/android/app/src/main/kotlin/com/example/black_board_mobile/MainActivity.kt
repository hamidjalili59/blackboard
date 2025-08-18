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
import kotlinx.coroutines.*
import kotlin.math.sqrt

class MainActivity : FlutterActivity() {
    private val METHOD_CHANNEL_NAME = "com.hamid.opus_streamer/method"
    private val EVENT_CHANNEL_NAME = "com.hamid.opus_streamer/event"

    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null

    // بخش ارسال (ضبط و انکود)
    private var audioRecord: AudioRecord? = null
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

    private val vadThreshold = 1000.0
    private val frameSize = 320 // 20ms of audio at 16kHz
    private val recordBufferSize =
        AudioRecord.getMinBufferSize(sampleRate, channelConfigRecord, audioFormat)
    private val playBufferSize =
        AudioTrack.getMinBufferSize(sampleRate, channelConfigPlay, audioFormat)


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
                    .setUsage(AudioAttributes.USAGE_VOICE_COMMUNICATION)
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
        println("VAD RMS: $rms")

        // اگر انرژی از آستانه بالاتر بود، گفتار است
        return rms > vadThreshold
    }

    private fun stopAudioEngine() {
        // توقف پلیر
        audioTrack?.let {
            if (it.playState == AudioTrack.PLAYSTATE_PLAYING) {
                it.stop()
            }
            it.release()
        }
        audioTrack = null
        opusDecoder = null
    }

    private fun startRecording(eventSink: EventChannel.EventSink?) {
        if (eventSink == null) return
        stopRecording() // اطمینان از توقف فرآیند قبلی

        // ۲. مقداردهی اولیه انکودر و رکوردر (برای ارسال)
        opusEncoder = OpusEncoder(
            sampleRate,
            1,
            io.github.jaredmdobson.concentus.OpusApplication.OPUS_APPLICATION_VOIP
        )
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
        audioRecord?.startRecording()

        recordingJob = CoroutineScope(Dispatchers.IO).launch {
            val pcmBuffer = ShortArray(frameSize)
            val opusBuffer = ByteArray(1024)
            while (isActive) {
                val bytesRead = audioRecord?.read(pcmBuffer, 0, frameSize) ?: 0
                if (bytesRead > 0) {

                    // ===== فراخوانی تابع VAD داخلی خودمان =====
                    if (isSpeech(pcmBuffer)) {
                        // println("Speech detected!") // می‌توانید برای دیباگ از این خط استفاده کنید
                        val encodedBytes = opusEncoder?.encode(pcmBuffer, 0, frameSize, opusBuffer, 0, opusBuffer.size) ?: 0
                        if (encodedBytes > 0) {
                            withContext(Dispatchers.Main) {
                                eventSink.success(opusBuffer.copyOfRange(0, encodedBytes))
                            }
                        }
                    }
                }
            }
        }
    }

    private fun stopRecording() {
        recordingJob?.cancel()
        recordingJob = null
        audioRecord?.let {
            if (it.recordingState == AudioRecord.RECORDSTATE_RECORDING) {
                it.stop()
            }
            it.release()
        }
        audioRecord = null
        opusEncoder = null
    }

    private fun handleReceivedOpusData(opusData: ByteArray) {
        // ۳. دیکود و پخش داده دریافتی
        val pcmBuffer = ShortArray(frameSize)
        val decodedSamples =
            opusDecoder?.decode(opusData, 0, opusData.size, pcmBuffer, 0, frameSize, false) ?: 0
        if (decodedSamples > 0) {
            audioTrack?.write(pcmBuffer, 0, decodedSamples)
        }
    }

    // ... توابع دسترسی میکروفون و onDestroy ...
    private fun checkMicPermission(): Boolean { /* ... بدون تغییر ... */ return ActivityCompat.checkSelfPermission(
        this,
        Manifest.permission.RECORD_AUDIO
    ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestMicPermission() { /* ... بدون تغییر ... */ ActivityCompat.requestPermissions(
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