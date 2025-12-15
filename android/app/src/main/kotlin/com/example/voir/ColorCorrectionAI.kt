package com.example.voir

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Log
import org.pytorch.IValue
import org.pytorch.LiteModuleLoader
import org.pytorch.Module
import org.pytorch.Tensor
import java.io.File
import java.io.FileOutputStream

/**
 * ColorCorrectionAI - Handles PyTorch model inference for color vision calibration
 * 
 * This class loads a PyTorch Lite model (.ptl) and processes camera frames
 * to apply AI-based color correction for people with color vision deficiency.
 */
class ColorCorrectionAI(private val context: Context) {
    
    companion object {
        private const val TAG = "ColorCorrectionAI"
        private const val MODEL_NAME = "model/model_mobile.ptl"
        private const val INPUT_SIZE = 224 // Model input size (224x224)
    }
    
    private var module: Module? = null
    private var isModelLoaded = false
    
    // Normalization constants (ImageNet standard)
    private val meanRGB = floatArrayOf(0.485f, 0.456f, 0.406f)
    private val stdRGB = floatArrayOf(0.229f, 0.224f, 0.225f)
    
    init {
        loadModel()
    }
    
    /**
     * Load the PyTorch Lite model from assets
     */
    private fun loadModel() {
        try {
            val modelPath = assetFilePath(MODEL_NAME)
            module = LiteModuleLoader.load(modelPath)
            isModelLoaded = true
            Log.d(TAG, "Model loaded successfully from: $modelPath")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to load model: ${e.message}")
            e.printStackTrace()
            isModelLoaded = false
        }
    }
    
    /**
     * Check if the model is ready for inference
     */
    fun isReady(): Boolean = isModelLoaded && module != null
    
    /**
     * Process a single frame from camera
     * @param inputBitmap The input bitmap from camera
     * @return Processed bitmap with AI color correction, or null if failed
     */
    fun processFrame(inputBitmap: Bitmap): Bitmap? {
        if (!isReady()) {
            Log.w(TAG, "Model not ready for inference")
            return null
        }
        
        return try {
            // 1. Resize input to model size
            val resizedBitmap = Bitmap.createScaledBitmap(
                inputBitmap, 
                INPUT_SIZE, 
                INPUT_SIZE, 
                true
            )
            
            // 2. Convert Bitmap to Tensor (Pre-processing)
            val inputTensor = bitmapToTensor(resizedBitmap)
            
            // 3. Run inference
            val outputTensor = module!!.forward(IValue.from(inputTensor)).toTensor()
            
            // 4. Convert output Tensor back to Bitmap (Post-processing)
            val outputBitmap = tensorToBitmap(outputTensor, INPUT_SIZE, INPUT_SIZE)
            
            // 5. Resize back to original size if needed
            if (inputBitmap.width != INPUT_SIZE || inputBitmap.height != INPUT_SIZE) {
                Bitmap.createScaledBitmap(
                    outputBitmap,
                    inputBitmap.width,
                    inputBitmap.height,
                    true
                )
            } else {
                outputBitmap
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error processing frame: ${e.message}")
            e.printStackTrace()
            null
        }
    }
    
    /**
     * Process raw byte array from Flutter camera
     * @param bytes JPEG or PNG encoded image bytes
     * @return Processed image as byte array, or null if failed
     */
    fun processBytes(bytes: ByteArray): ByteArray? {
        return try {
            // Decode bytes to Bitmap
            val inputBitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
                ?: return null
            
            // Process the bitmap
            val outputBitmap = processFrame(inputBitmap) ?: return null
            
            // Encode back to bytes (JPEG for smaller size)
            val outputStream = java.io.ByteArrayOutputStream()
            outputBitmap.compress(Bitmap.CompressFormat.JPEG, 90, outputStream)
            outputStream.toByteArray()
        } catch (e: Exception) {
            Log.e(TAG, "Error processing bytes: ${e.message}")
            null
        }
    }
    
    /**
     * Convert Bitmap to normalized Float Tensor
     */
    private fun bitmapToTensor(bitmap: Bitmap): Tensor {
        val width = bitmap.width
        val height = bitmap.height
        val pixels = IntArray(width * height)
        bitmap.getPixels(pixels, 0, width, 0, 0, width, height)
        
        // Create DIRECT float buffer for CHW format (Channels, Height, Width)
        // PyTorch requires direct byte buffer
        val floatArray = FloatArray(3 * width * height)
        
        // Convert pixels to normalized float values
        for (i in pixels.indices) {
            val pixel = pixels[i]
            
            // Extract RGB values (0-255)
            val r = ((pixel shr 16) and 0xFF) / 255.0f
            val g = ((pixel shr 8) and 0xFF) / 255.0f
            val b = (pixel and 0xFF) / 255.0f
            
            // Normalize using ImageNet mean and std
            floatArray[i] = (r - meanRGB[0]) / stdRGB[0]                    // R channel
            floatArray[i + width * height] = (g - meanRGB[1]) / stdRGB[1]  // G channel
            floatArray[i + 2 * width * height] = (b - meanRGB[2]) / stdRGB[2] // B channel
        }
        
        // Create tensor with shape [1, 3, height, width] (NCHW format)
        return Tensor.fromBlob(floatArray, longArrayOf(1, 3, height.toLong(), width.toLong()))
    }
    
    /**
     * Convert output Tensor back to Bitmap
     */
    private fun tensorToBitmap(tensor: Tensor, width: Int, height: Int): Bitmap {
        val floatArray = tensor.dataAsFloatArray
        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        val pixels = IntArray(width * height)
        
        for (i in 0 until width * height) {
            // Get values from CHW format and denormalize
            var r = floatArray[i] * stdRGB[0] + meanRGB[0]
            var g = floatArray[i + width * height] * stdRGB[1] + meanRGB[1]
            var b = floatArray[i + 2 * width * height] * stdRGB[2] + meanRGB[2]
            
            // Clamp to valid range and convert to 0-255
            r = (r * 255).coerceIn(0f, 255f)
            g = (g * 255).coerceIn(0f, 255f)
            b = (b * 255).coerceIn(0f, 255f)
            
            // Pack into ARGB pixel
            pixels[i] = (0xFF shl 24) or 
                       (r.toInt() shl 16) or 
                       (g.toInt() shl 8) or 
                       b.toInt()
        }
        
        bitmap.setPixels(pixels, 0, width, 0, 0, width, height)
        return bitmap
    }
    
    /**
     * Copy asset file to internal storage and return path
     */
    private fun assetFilePath(assetName: String): String {
        val file = File(context.filesDir, assetName)
        
        // Create parent directories if they don't exist
        file.parentFile?.mkdirs()
        
        // Check if already copied
        if (file.exists() && file.length() > 0) {
            Log.d(TAG, "Model file already exists at: ${file.absolutePath}")
            return file.absolutePath
        }
        
        // Copy from assets
        try {
            context.assets.open(assetName).use { inputStream ->
                FileOutputStream(file).use { outputStream ->
                    val buffer = ByteArray(4 * 1024)
                    var read: Int
                    while (inputStream.read(buffer).also { read = it } != -1) {
                        outputStream.write(buffer, 0, read)
                    }
                    outputStream.flush()
                }
            }
            Log.d(TAG, "Model file copied to: ${file.absolutePath}")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to copy asset file: ${e.message}")
            throw e
        }
        
        return file.absolutePath
    }
    
    /**
     * Release resources
     */
    fun release() {
        module?.destroy()
        module = null
        isModelLoaded = false
    }
}
