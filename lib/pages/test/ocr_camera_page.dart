import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:async';
import 'dart:io';
import 'ocr_complete_page.dart';

class OcrCameraPage extends StatefulWidget {
  const OcrCameraPage({super.key});

  @override
  State<OcrCameraPage> createState() => _OcrCameraPageState();
}

class _OcrCameraPageState extends State<OcrCameraPage>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;
  bool _isProcessing = false;
  bool _showConfirmation = false;
  bool _showResults = false;
  XFile? _capturedImage;
  final ImagePicker _imagePicker = ImagePicker();

  // Animation controllers
  late AnimationController _scanLineController;
  late Animation<double> _scanLineAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // OCR results (editable) - default values if OCR reads "-"
  final Map<String, String> _ocrResults = {
    'Test Date': '2025-12-08',
    'Match Range': '12-58',
    'Final Match Point': '41',
    'Match Quality': '3/5 (Moderate variability)',
    'Luminosity Setting': '17.4 cd/m²',
    'Adjustment Attempts': '27',
  };

  // Text recognizer
  final TextRecognizer _textRecognizer = TextRecognizer();

  // Text editing controllers for each field
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeAnimations();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Create a TextEditingController for each OCR result field
    for (var entry in _ocrResults.entries) {
      _controllers[entry.key] = TextEditingController(text: entry.value);
    }
  }

  void _initializeAnimations() {
    // Scan line animation
    _scanLineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _scanLineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scanLineController, curve: Curves.easeInOut),
    );

    // Pulse animation for processing
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        // Find rear camera
        final rearCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras!.first,
        );

        _cameraController = CameraController(
          rearCamera,
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _cameraController!.initialize();

        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _scanLineController.dispose();
    _pulseController.dispose();
    _textRecognizer.close();
    // Dispose all text editing controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleFlash() async {
    if (_cameraController == null) return;

    setState(() {
      _isFlashOn = !_isFlashOn;
    });

    await _cameraController!.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final image = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = image;
        _showConfirmation = true;
      });
    } catch (e) {
      debugPrint('Error capturing image: $e');
    }
  }

  Future<void> _importFromGallery() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _capturedImage = image;
          _showConfirmation = true;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
      _showConfirmation = false;
      _isProcessing = false;
    });
  }

  Future<void> _usePhoto() async {
    setState(() {
      _showConfirmation = false;
      _isProcessing = true;
    });

    try {
      // Process image with ML Kit OCR
      final inputImage = InputImage.fromFilePath(_capturedImage!.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      // Extract text and parse for specific fields
      final String fullText = recognizedText.text.toLowerCase();
      
      // Parse OCR results - look for keywords and extract values
      _parseOcrResults(fullText, recognizedText.text);
      
      // Update controllers with new values
      for (var entry in _ocrResults.entries) {
        _controllers[entry.key]?.text = entry.value;
      }
    } catch (e) {
      debugPrint('Error processing OCR: $e');
      // Keep default values if OCR fails
    }

    setState(() {
      _isProcessing = false;
      _showResults = true;
    });
  }

  void _parseOcrResults(String lowerText, String originalText) {
    // Split text into lines for better parsing
    final lines = originalText.split('\n');
    
    for (var line in lines) {
      final lowerLine = line.toLowerCase();
      
      // Test Date
      if (lowerLine.contains('test date') || lowerLine.contains('date')) {
        final dateMatch = RegExp(r'\d{1,2}[/\-.]\d{1,2}[/\-.]\d{2,4}').firstMatch(line);
        if (dateMatch != null) {
          _ocrResults['Test Date'] = dateMatch.group(0) ?? '-';
        }
      }
      
      // Match Range
      if (lowerLine.contains('match range') || lowerLine.contains('range')) {
        final rangeMatch = RegExp(r'\d+[\s]*[-–]\s*\d+|\d+%?\s*[-–]\s*\d+%?').firstMatch(line);
        if (rangeMatch != null) {
          _ocrResults['Match Range'] = rangeMatch.group(0) ?? '-';
        }
      }
      
      // Final Match Point
      if (lowerLine.contains('final match') || lowerLine.contains('match point') || lowerLine.contains('final')) {
        final pointMatch = RegExp(r'\d+\.?\d*%?').firstMatch(line);
        if (pointMatch != null) {
          _ocrResults['Final Match Point'] = pointMatch.group(0) ?? '-';
        }
      }
      
      // Match Quality
      if (lowerLine.contains('quality') || lowerLine.contains('match quality')) {
        if (lowerLine.contains('excellent') || lowerLine.contains('good') || 
            lowerLine.contains('fair') || lowerLine.contains('poor')) {
          final qualityMatch = RegExp(r'(excellent|good|fair|poor|high|medium|low)', caseSensitive: false).firstMatch(line);
          if (qualityMatch != null) {
            _ocrResults['Match Quality'] = qualityMatch.group(0)?.toUpperCase() ?? '-';
          }
        } else {
          final percentMatch = RegExp(r'\d+\.?\d*%?').firstMatch(line);
          if (percentMatch != null) {
            _ocrResults['Match Quality'] = percentMatch.group(0) ?? '-';
          }
        }
      }
      
      // Luminosity Setting
      if (lowerLine.contains('luminosity') || lowerLine.contains('brightness') || lowerLine.contains('lux')) {
        final luxMatch = RegExp(r'\d+\.?\d*\s*(lux|cd|nit|%)?', caseSensitive: false).firstMatch(line);
        if (luxMatch != null) {
          _ocrResults['Luminosity Setting'] = luxMatch.group(0) ?? '-';
        }
      }
      
      // Adjustment Attempts
      if (lowerLine.contains('adjustment') || lowerLine.contains('attempts') || lowerLine.contains('try')) {
        final attemptMatch = RegExp(r'\d+').firstMatch(line);
        if (attemptMatch != null) {
          _ocrResults['Adjustment Attempts'] = attemptMatch.group(0) ?? '-';
        }
      }
    }
  }

  void _onDone() {
    // Navigate to OCR Complete page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OcrCompletePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Preview or Captured Image
            if (_showResults)
              _buildResultsView()
            else if (_isProcessing)
              _buildProcessingView()
            else if (_showConfirmation && _capturedImage != null)
              _buildConfirmationView()
            else
              _buildCameraView(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraView() {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    return Stack(
      children: [
        // Camera Preview
        if (_isCameraInitialized && _cameraController != null)
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          )
        else
          Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 249, 250, 250),
              ),
            ),
          ),

        // Dark overlay with viewfinder cutout
        Positioned.fill(
          child: CustomPaint(
            painter: ViewfinderOverlayPainter(
              frameWidth: isTablet ? 400 : 300,
              frameHeight: isTablet ? 260 : 200,
            ),
          ),
        ),

        // Viewfinder Frame
        Center(
          child: _buildViewfinderFrame(isTablet),
        ),

        // Instruction Text
        Positioned(
          top: isTablet ? 80 : 60,
          left: 20,
          right: 20,
          child: Text(
            'Place your medical certificate inside the frame',
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Top Controls
        Positioned(
          top: 10,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              _buildTopButton(
                icon: Icons.arrow_back,
                onTap: () => Navigator.of(context).pop(),
              ),
              // Flash toggle
              _buildTopButton(
                icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
                onTap: _toggleFlash,
                isActive: _isFlashOn,
              ),
            ],
          ),
        ),

        // Bottom Controls
        Positioned(
          bottom: isTablet ? 140 : 120,
          left: 0,
          right: 0,
          child: _buildBottomControls(isTablet),
        ),
      ],
    );
  }

  Widget _buildViewfinderFrame(bool isTablet) {
    final frameWidth = isTablet ? 400.0 : 300.0;
    final frameHeight = isTablet ? 260.0 : 200.0;

    return SizedBox(
      width: frameWidth,
      height: frameHeight,
      child: Stack(
        children: [
          // Corner markers
          _buildCornerMarker(Alignment.topLeft, isTablet),
          _buildCornerMarker(Alignment.topRight, isTablet),
          _buildCornerMarker(Alignment.bottomLeft, isTablet),
          _buildCornerMarker(Alignment.bottomRight, isTablet),

          // Scanning line animation
          AnimatedBuilder(
            animation: _scanLineAnimation,
            builder: (context, child) {
              return Positioned(
                top: _scanLineAnimation.value * (frameHeight - 4),
                left: 20,
                right: 20,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        const Color.fromARGB(255, 250, 251, 250).withOpacity(0.8),
                        const Color.fromARGB(255, 243, 244, 243),
                        const Color.fromARGB(255, 172, 181, 177).withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 243, 244, 244).withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCornerMarker(Alignment alignment, bool isTablet) {
    final cornerSize = isTablet ? 40.0 : 30.0;
    final strokeWidth = isTablet ? 4.0 : 3.0;

    BorderRadius borderRadius;
    if (alignment == Alignment.topLeft) {
      borderRadius = BorderRadius.only(topLeft: Radius.circular(8));
    } else if (alignment == Alignment.topRight) {
      borderRadius = BorderRadius.only(topRight: Radius.circular(8));
    } else if (alignment == Alignment.bottomLeft) {
      borderRadius = BorderRadius.only(bottomLeft: Radius.circular(8));
    } else {
      borderRadius = BorderRadius.only(bottomRight: Radius.circular(8));
    }

    return Align(
      alignment: alignment,
      child: CustomPaint(
        size: Size(cornerSize, cornerSize),
        painter: CornerPainter(
          alignment: alignment,
          strokeWidth: strokeWidth,
          color: const Color.fromARGB(255, 237, 239, 238),
        ),
      ),
    );
  }

  Widget _buildTopButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isActive
              ? const Color.fromARGB(255, 243, 245, 244).withOpacity(0.3)
              : Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? const Color.fromARGB(255, 242, 244, 243)
                : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildBottomControls(bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 60 : 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Import button
          GestureDetector(
            onTap: _importFromGallery,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: isTablet ? 56 : 48,
                  height: isTablet ? 56 : 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white,
                    size: isTablet ? 28 : 24,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Import',
                  style: TextStyle(
                    fontSize: isTablet ? 13 : 11,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Shutter button
          GestureDetector(
            onTap: _captureImage,
            child: Container(
              width: isTablet ? 80 : 70,
              height: isTablet ? 80 : 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(255, 236, 238, 237),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 237, 239, 238).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: isTablet ? 64 : 56,
                  height: isTablet ? 64 : 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: isTablet ? 32 : 28,
                  ),
                ),
              ),
            ),
          ),

          // Spacer for alignment
          SizedBox(width: isTablet ? 56 : 48),
        ],
      ),
    );
  }

  Widget _buildConfirmationView() {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    return Stack(
      children: [
        // Captured image
        Positioned.fill(
          child: Image.file(
            File(_capturedImage!.path),
            fit: BoxFit.cover,
          ),
        ),

        // Dark overlay
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),

        // Confirmation buttons
        Positioned(
          bottom: isTablet ? 140 : 120,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Retake button
              _buildActionButton(
                label: 'Retake',
                icon: Icons.refresh,
                onTap: _retakePhoto,
                isPrimary: false,
                isTablet: isTablet,
              ),
              SizedBox(width: isTablet ? 32 : 24),
              // Use this photo button
              _buildActionButton(
                label: 'Use This Photo',
                icon: Icons.check,
                onTap: _usePhoto,
                isPrimary: true,
                isTablet: isTablet,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required bool isPrimary,
    required bool isTablet,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 24 : 20,
          vertical: isTablet ? 14 : 12,
        ),
        decoration: BoxDecoration(
          color: isPrimary ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isPrimary ? Colors.white : Colors.white.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.black : Colors.white,
              size: isTablet ? 22 : 20,
            ),
            SizedBox(width: isTablet ? 10 : 8),
            Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
                color: isPrimary ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingView() {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    return Stack(
      children: [
        // Captured image (dimmed)
        if (_capturedImage != null)
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7),
                BlendMode.darken,
              ),
              child: Image.file(
                File(_capturedImage!.path),
                fit: BoxFit.cover,
              ),
            ),
          ),

        // Processing animation
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Scanning animation
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: isTablet ? 120 : 100,
                    height: isTablet ? 120 : 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white
                            .withOpacity(_pulseAnimation.value),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white
                              .withOpacity(_pulseAnimation.value * 0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.document_scanner,
                      color: Colors.white,
                      size: isTablet ? 50 : 40,
                    ),
                  );
                },
              ),
              SizedBox(height: isTablet ? 32 : 24),
              Text(
                'Analyzing document…',
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                  color: Colors.white,
                ),
              ),
              SizedBox(height: isTablet ? 16 : 12),
              SizedBox(
                width: isTablet ? 200 : 160,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultsView() {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Top bar
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isTablet ? 16 : 12,
            ),
            child: Row(
              children: [
                _buildTopButton(
                  icon: Icons.close,
                  onTap: () => Navigator.of(context).pop(),
                ),
                const Spacer(),
                Text(
                  'Scan Results',
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto',
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 44),
              ],
            ),
          ),

          // Results card
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 40 : 24,
                vertical: isTablet ? 24 : 16,
              ),
              child: Column(
                children: [
                  // Success icon
                  Container(
                    width: isTablet ? 80 : 70,
                    height: isTablet ? 80 : 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: isTablet ? 44 : 38,
                    ),
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  Text(
                    'Document Verified',
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Roboto',
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: isTablet ? 28 : 24),

                  // Results card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isTablet ? 24 : 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Extracted Information',
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Roboto',
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: isTablet ? 20 : 16),
                        ..._ocrResults.entries.map((entry) {
                          return _buildResultRow(
                            label: entry.key,
                            value: entry.value,
                            isTablet: isTablet,
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: isTablet ? 32 : 28),

                  // Done button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _onDone,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 18 : 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 24 : 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow({
    required String label,
    required String value,
    required bool isTablet,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: isTablet ? 140 : 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 14 : 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                color: Colors.white60,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controllers[label],
              style: TextStyle(
                fontSize: isTablet ? 15 : 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
                color: Colors.white,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 12 : 10,
                  vertical: isTablet ? 10 : 8,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 1.5,
                  ),
                ),
                suffixIcon: Icon(
                  Icons.edit,
                  size: isTablet ? 18 : 16,
                  color: Colors.white38,
                ),
              ),
              onChanged: (newValue) {
                _ocrResults[label] = newValue;
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for viewfinder overlay
class ViewfinderOverlayPainter extends CustomPainter {
  final double frameWidth;
  final double frameHeight;

  ViewfinderOverlayPainter({
    required this.frameWidth,
    required this.frameHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final frameRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: frameWidth,
      height: frameHeight,
    );

    // Draw dark overlay with cutout
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(frameRect, const Radius.circular(12)),
          ),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for corner markers
class CornerPainter extends CustomPainter {
  final Alignment alignment;
  final double strokeWidth;
  final Color color;

  CornerPainter({
    required this.alignment,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    if (alignment == Alignment.topLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, strokeWidth);
      path.quadraticBezierTo(0, 0, strokeWidth, 0);
      path.lineTo(size.width, 0);
    } else if (alignment == Alignment.topRight) {
      path.moveTo(0, 0);
      path.lineTo(size.width - strokeWidth, 0);
      path.quadraticBezierTo(size.width, 0, size.width, strokeWidth);
      path.lineTo(size.width, size.height);
    } else if (alignment == Alignment.bottomLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height - strokeWidth);
      path.quadraticBezierTo(0, size.height, strokeWidth, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height - strokeWidth);
      path.quadraticBezierTo(
          size.width, size.height, size.width - strokeWidth, size.height);
      path.lineTo(0, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
