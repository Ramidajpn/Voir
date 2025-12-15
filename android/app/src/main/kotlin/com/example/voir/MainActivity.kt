package com.example.voir

import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * MainActivity - Handles Flutter-Native communication for AI color correction
 * 
 * This activity sets up a Platform Channel to allow Flutter to invoke
 * the PyTorch model for real-time color calibration.
 */
class MainActivity : FlutterActivity() {
    
    companion object {
        private const val TAG = "MainActivity"
        private const val CHANNEL = "com.example.voir/ai_calibration"
    }
    
    private var colorCorrectionAI: ColorCorrectionAI? = null
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Initialize the AI engine
        colorCorrectionAI = ColorCorrectionAI(this)
        
        // Set up Method Channel for Flutter communication
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isModelReady" -> {
                    // Check if the AI model is loaded and ready
                    val isReady = colorCorrectionAI?.isReady() ?: false
                    Log.d(TAG, "isModelReady called, result: $isReady")
                    result.success(isReady)
                }
                
                "processFrame" -> {
                    // Process a single camera frame
                    val bytes = call.argument<ByteArray>("imageBytes")
                    if (bytes == null) {
                        result.error("INVALID_ARGUMENT", "imageBytes is required", null)
                        return@setMethodCallHandler
                    }
                    
                    // Run inference on background thread to avoid blocking UI
                    Thread {
                        try {
                            val processedBytes = colorCorrectionAI?.processBytes(bytes)
                            runOnUiThread {
                                if (processedBytes != null) {
                                    result.success(processedBytes)
                                } else {
                                    result.error("PROCESSING_ERROR", "Failed to process frame", null)
                                }
                            }
                        } catch (e: Exception) {
                            runOnUiThread {
                                result.error("EXCEPTION", e.message, null)
                            }
                        }
                    }.start()
                }
                
                "getModelInfo" -> {
                    // Return model information
                    val info = mapOf(
                        "modelName" to "model_mobile.ptl",
                        "inputSize" to 224,
                        "isReady" to (colorCorrectionAI?.isReady() ?: false)
                    )
                    result.success(info)
                }
                
                else -> {
                    result.notImplemented()
                }
            }
        }
        
        Log.d(TAG, "Flutter engine configured with AI calibration channel")
    }
    
    override fun onDestroy() {
        super.onDestroy()
        // Clean up AI resources
        colorCorrectionAI?.release()
        colorCorrectionAI = null
        Log.d(TAG, "AI resources released")
    }
}

