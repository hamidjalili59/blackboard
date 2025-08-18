import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class AudioService {
  // نام کانال‌ها باید دقیقاً با نام‌های تعریف شده در MainActivity.kt یکی باشد
  static const _methodChannel = MethodChannel('com.example.black_board_mobile/method');
  static const _eventChannel = EventChannel('com.example.black_board_mobile/event');

  // StreamController برای انتشار داده‌های صوتی ضبط شده به بقیه برنامه
  final _audioStreamController = StreamController<Uint8List>.broadcast();
  StreamSubscription? _nativeStreamSubscription;

  // Stream عمومی برای اینکه ویجت‌ها به آن گوش دهند
  Stream<Uint8List> get outgoingAudioStream => _audioStreamController.stream;

  bool _isEngineRunning = false;

  // شروع موتور صوتی در کاتلین و گوش دادن به داده‌های ارسالی
  Future<void> start() async {
    if (_isEngineRunning) return;
    try {
      // ۱. درخواست شروع موتور صوتی از کاتلین
      await _methodChannel.invokeMethod('startStreaming');

      // ۲. لغو اشتراک قبلی برای جلوگیری از نشت حافظه
      _nativeStreamSubscription?.cancel();

      // ۳. گوش دادن به EventChannel که داده‌های Opus را از کاتلین می‌فرستد
      _nativeStreamSubscription = _eventChannel.receiveBroadcastStream().listen(
        (dynamic data) {
          if (data is Uint8List) {
            // ۴. ارسال داده‌های دریافتی به استریم داخلی خودمان
            _audioStreamController.add(data);
          }
        },
        onError: (error) {
          print('AudioService native stream error: $error');
          _audioStreamController.addError(error);
        },
      );
      _isEngineRunning = true;
      print('AudioService started successfully.');
    } on PlatformException catch (e) {
      print('Failed to start AudioService: ${e.message}');
      throw Exception('Failed to start audio engine: ${e.message}');
    }
  }

  // توقف موتور صوتی
  Future<void> stop() async {
    if (!_isEngineRunning) return;
    try {
      await _methodChannel.invokeMethod('stopStreaming');
      await _nativeStreamSubscription?.cancel();
      _nativeStreamSubscription = null;
      _isEngineRunning = false;
      print('AudioService stopped.');
    } on PlatformException catch (e) {
      print('Failed to stop AudioService: ${e.message}');
    }
  }

  // ارسال یک بسته صوتی دریافتی از سرور به کاتلین برای پخش
  Future<void> playAudioChunk(Uint8List data) async {
    if (!_isEngineRunning) {
      print("Warning: Audio engine is not running, cannot play chunk.");
      return;
    }
    try {
      await _methodChannel.invokeMethod('sendDataToKotlin', {'data': data});
    } on PlatformException catch (e) {
      print('Failed to send audio chunk to Kotlin: ${e.message}');
    }
  }

  // برای آزادسازی منابع در صورت عدم نیاز
  void dispose() {
    stop();
    _audioStreamController.close();
  }
}
