import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
// import 'dart:typed_data'; // Uncomment when using real AI model
import 'home_page.dart';
import 'graph_page.dart';
import 'test_page.dart';
import 'profile_page.dart';
// import '../services/ai_calibration_service.dart'; // Uncomment when using real AI model

class CalibrationPage extends StatefulWidget {
  const CalibrationPage({super.key});

  @override
  State<CalibrationPage> createState() => _CalibrationPageState();
}

class _CalibrationPageState extends State<CalibrationPage>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  // Split slider position (0.0 to 1.0, default 0.5 = center)
  double _splitPosition = 0.5;

  // Animation controller for AI status pulse effect
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // ============================================================
  // AI MODEL INTEGRATION (Commented out for prototype)
  // Uncomment these when you have a working model
  // ============================================================
  // bool _isAIProcessing = false;
  // bool _isAIModelReady = false;
  // Uint8List? _aiProcessedImage;
  // Timer? _processingTimer;
  // bool _isCapturing = false;
  // final AICalibrationService _aiService = AICalibrationService.instance;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializePulseAnimation();
    // _initializeAIService(); // Uncomment when using real AI model
  }

  void _initializePulseAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  // ============================================================
  // AI SERVICE METHODS (Commented out for prototype)
  // Uncomment these when you have a working model
  // ============================================================
  /*
  Future<void> _initializeAIService() async {
    final isReady = await _aiService.initialize();
    if (mounted) {
      setState(() {
        _isAIModelReady = isReady;
        _isAIProcessing = isReady;
      });
    }

    if (isReady) {
      _startAIProcessing();
    }
  }

  void _startAIProcessing() {
    // Process frames every 500ms (2 FPS for AI) to avoid overloading
    _processingTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _processCurrentFrame();
    });
  }

  Future<void> _processCurrentFrame() async {
    if (_isCapturing) return;

    if (!_isCameraInitialized ||
        !_isAIModelReady ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return;
    }

    _isCapturing = true;

    try {
      final XFile imageFile = await _cameraController!.takePicture();
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final processedBytes = await _aiService.processFrame(imageBytes);

      if (mounted && processedBytes != null) {
        setState(() {
          _aiProcessedImage = processedBytes;
        });
      }
    } catch (e) {
      debugPrint('AI Processing error: $e');
    } finally {
      _isCapturing = false;
    }
  }
  */

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _hasError = true;
          _errorMessage = 'No cameras available';
        });
        return;
      }

      // Use back camera by default
      final backCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset
            .medium, // Use medium for better AI processing performance
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to initialize camera: $e';
      });
    }
  }

  @override
  void dispose() {
    // _processingTimer?.cancel(); // Uncomment when using real AI model
    _cameraController?.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(isTablet),

            // Main camera view with split comparison
            Expanded(child: _buildCameraView(isTablet)),

            // AI Status indicator
            _buildAIStatusIndicator(isTablet),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavigationBar(context, isTablet),
    );
  }

  Widget _buildHeader(bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 40.0 : 16.0,
        vertical: isTablet ? 24.0 : 16.0,
      ),
      child: Text(
        'AI Calibration',
        style: TextStyle(
          color: Colors.white,
          fontSize: isTablet ? 32 : 24,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
          letterSpacing: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCameraView(bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 40.0 : 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: _hasError
            ? _buildErrorView()
            : !_isCameraInitialized
            ? _buildLoadingView()
            : _buildSplitCameraView(),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            SizedBox(height: 16),
            Text(
              'Initializing Camera...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam_off, color: Colors.white54, size: 64),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                  _isCameraInitialized = false;
                });
                _initializeCamera();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplitCameraView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _splitPosition += details.delta.dx / width;
              _splitPosition = _splitPosition.clamp(0.1, 0.9);
            });
          },
          child: Stack(
            children: [
              // Full camera preview (for the "After" / AI Calibrated side)
              Positioned.fill(child: _buildCameraPreview(isCalibrated: true)),

              // Left side clip (Before / Color Vision View)
              ClipRect(
                clipper: LeftClipper(_splitPosition),
                child: _buildCameraPreview(isCalibrated: false),
              ),

              // Labels
              _buildLabels(width, height),

              // Split line / divider
              _buildSplitDivider(width, height),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCameraPreview({required bool isCalibrated}) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container(color: Colors.black);
    }

    // ============================================================
    // AI MODEL PREVIEW (Commented out for prototype)
    // Uncomment this block when using real AI model to show processed image
    // ============================================================
    /*
    // For the AI Calibrated side (right), show AI processed image if available
    if (isCalibrated && _aiProcessedImage != null && _isAIModelReady) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(
            _aiProcessedImage!,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.02),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      );
    }
    */

    // Base camera preview widget - realtime camera for both sides
    Widget cameraWidget = CameraPreview(_cameraController!);

    // Apply Protanopia color filter for the "Before" view (left side)
    // This simulates how people with red-blindness see colors
    if (!isCalibrated) {
      cameraWidget = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.567, 0.433, 0.000, 0, 0, // R - Red channel transformation
          0.558, 0.442, 0.000, 0, 0, // G - Green channel transformation
          0.000, 0.242, 0.758, 0, 0, // B - Blue channel transformation
          0, 0, 0, 1, 0, // Alpha - No change
        ]),
        child: cameraWidget,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera preview (with or without color filter)
        cameraWidget,

        // AI calibrated overlay effect (subtle enhancement indicator)
        if (isCalibrated)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.02),
                  Colors.transparent,
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLabels(double width, double height) {
    return Stack(
      children: [
        // Before label (left side)
        Positioned(
          top: 16,
          left: 16,
          child: _buildLabel('Before', 'Color Vision View'),
        ),

        // After label (right side)
        Positioned(
          top: 16,
          right: 16,
          child: _buildLabel('After', 'AI Calibrated'),
        ),
      ],
    );
  }

  Widget _buildLabel(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitDivider(double width, double height) {
    final dividerX = width * _splitPosition;

    return Positioned(
      left: dividerX - 20,
      top: 0,
      bottom: 0,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            _splitPosition += details.delta.dx / width;
            _splitPosition = _splitPosition.clamp(0.1, 0.9);
          });
        },
        child: Container(
          width: 40,
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 4,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Grip marks
                  Container(
                    width: 24,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildGripLine(),
                        const SizedBox(height: 4),
                        _buildGripLine(),
                        const SizedBox(height: 4),
                        _buildGripLine(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGripLine() {
    return Container(
      width: 12,
      height: 2,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildAIStatusIndicator(bool isTablet) {
    // Always show as active for prototype demo
    final Color statusColor = Colors.greenAccent;
    final String statusText = 'AI Active';

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 40.0 : 16.0,
        vertical: isTablet ? 16.0 : 12.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pulsing AI indicator
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor.withOpacity(_pulseAnimation.value),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(
                        0.5 * _pulseAnimation.value,
                      ),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: isTablet ? 14 : 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '•',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'model_mobile.ptl',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: isTablet ? 12 : 10,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto',
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context, bool isTablet) {
    return Container(
      margin: EdgeInsets.all(isTablet ? 24 : 20),
      padding: EdgeInsets.symmetric(
        vertical: isTablet ? 16 : 12,
        horizontal: isTablet ? 24 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Home
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            iconSize: 40,
            icon: const Icon(Icons.home, color: Colors.black),
          ),
          // Graph
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const GraphPage()),
              );
            },
            iconSize: 40,
            icon: const Icon(Icons.show_chart_outlined, color: Colors.black),
          ),
          // Eye - Active (center, prominent)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 16,
                  spreadRadius: 3,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: const Icon(
              Icons.remove_red_eye,
              color: Colors.white,
              size: 56,
            ),
          ),
          // Edit
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const TestPage()),
              );
            },
            iconSize: 40,
            icon: const Icon(Icons.edit, color: Colors.black),
          ),
          // Person
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
            iconSize: 40,
            icon: const Icon(Icons.person, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

/// Custom clipper for the left side of the split view
class LeftClipper extends CustomClipper<Rect> {
  final double splitPosition;

  LeftClipper(this.splitPosition);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * splitPosition, size.height);
  }

  @override
  bool shouldReclip(LeftClipper oldClipper) {
    return oldClipper.splitPosition != splitPosition;
  }
}
