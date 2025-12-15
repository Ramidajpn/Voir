import 'package:flutter/services.dart';

/// AICalibrationService - Handles communication with native Android AI model
///
/// This service uses Platform Channels to invoke the PyTorch Lite model
/// for real-time color vision calibration.
class AICalibrationService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.voir/ai_calibration',
  );

  static AICalibrationService? _instance;

  /// Singleton instance
  static AICalibrationService get instance {
    _instance ??= AICalibrationService._();
    return _instance!;
  }

  AICalibrationService._();

  bool _isInitialized = false;
  bool _isModelReady = false;

  /// Check if the service is initialized
  bool get isInitialized => _isInitialized;

  /// Check if the AI model is ready for inference
  bool get isModelReady => _isModelReady;

  /// Initialize the service and check model status
  Future<bool> initialize() async {
    if (_isInitialized) return _isModelReady;

    try {
      _isModelReady =
          await _channel.invokeMethod<bool>('isModelReady') ?? false;
      _isInitialized = true;
      return _isModelReady;
    } on PlatformException catch (e) {
      print('AICalibrationService: Failed to initialize - ${e.message}');
      _isInitialized = true;
      _isModelReady = false;
      return false;
    }
  }

  /// Process a camera frame through the AI model
  ///
  /// [imageBytes] - JPEG or PNG encoded image bytes
  /// Returns processed image bytes, or null if processing failed
  Future<Uint8List?> processFrame(Uint8List imageBytes) async {
    if (!_isModelReady) {
      print('AICalibrationService: Model not ready');
      return null;
    }

    try {
      final result = await _channel.invokeMethod<Uint8List>('processFrame', {
        'imageBytes': imageBytes,
      });
      return result;
    } on PlatformException catch (e) {
      print('AICalibrationService: Processing failed - ${e.message}');
      return null;
    }
  }

  /// Get information about the loaded model
  Future<Map<String, dynamic>?> getModelInfo() async {
    try {
      final result = await _channel.invokeMethod<Map>('getModelInfo');
      return result?.cast<String, dynamic>();
    } on PlatformException catch (e) {
      print('AICalibrationService: Failed to get model info - ${e.message}');
      return null;
    }
  }
}
