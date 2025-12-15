import 'package:flutter/material.dart';
import '../home_page.dart';
import '../graph_page.dart';
import '../profile_page.dart';
import '../test_page.dart';
import '../calibration_page.dart';

class OcrCompletePage extends StatelessWidget {
  const OcrCompletePage({super.key});

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
            color: Colors.black.withOpacity(0.15),
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
          // Eye - Main feature (AI Calibration)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 16,
                  spreadRadius: 3,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: const Icon(
              Icons.remove_red_eye,
              color: Colors.black,
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Black background layer
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
          ),

          // White wave container on top
          Positioned(
            top: screenHeight * 0.12,
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: OcrCompleteWaveClipper(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.15),

                        // Header Image
                        Container(
                          width: isTablet ? 320 : 240,
                          height: isTablet ? 320 : 240,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/woman_newsight.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.check_circle_outline,
                                    size: isTablet ? 100 : 80,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: isTablet ? 40 : 32),

                        // Success Icon
                        Container(
                          width: isTablet ? 70 : 60,
                          height: isTablet ? 70 : 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: isTablet ? 40 : 34,
                          ),
                        ),

                        SizedBox(height: isTablet ? 24 : 20),

                        // Title Text
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 60 : 32,
                          ),
                          child: Text(
                            'All set!',
                            style: TextStyle(
                              fontSize: isTablet ? 36 : 28,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Roboto',
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: isTablet ? 20 : 16),

                        // Description Text
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 60 : 32,
                          ),
                          child: Text(
                            'Your visual data has been processed, and our AI has generated a color profile tailored just for you.',
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 15,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto',
                              color: Colors.black87,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: isTablet ? 16 : 12),

                        // Secondary Text
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 60 : 32,
                          ),
                          child: Text(
                            'Try putting on your Voir Lens — or explore the AI Calibration feature to see your personalized color world in action!',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                              color: Colors.black54,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: isTablet ? 48 : 40),

                        // Buttons
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 60 : 32,
                          ),
                          child: Column(
                            children: [
                              // Go to AI Calibration Button (Primary)
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigate to AI Calibration page
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => const CalibrationPage(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      vertical: isTablet ? 18 : 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.remove_red_eye,
                                        size: isTablet ? 24 : 20,
                                      ),
                                      SizedBox(width: isTablet ? 12 : 10),
                                      Text(
                                        'Go to AI Calibration',
                                        style: TextStyle(
                                          fontSize: isTablet ? 18 : 16,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: isTablet ? 16 : 14),

                              // Back Button (Secondary)
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigate back to Test Page
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => const TestPage(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      vertical: isTablet ? 16 : 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Back',
                                    style: TextStyle(
                                      fontSize: isTablet ? 16 : 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: isTablet ? 40 : 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildNavigationBar(context, isTablet),
    );
  }
}

// Custom clipper for the wave effect at the top of the white container
class OcrCompleteWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left with wave
    path.moveTo(0, 60);

    // Create smooth wave curve
    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, 30);
    path.quadraticBezierTo(size.width * 0.75, 60, size.width, 20);

    // Complete the rectangle
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
