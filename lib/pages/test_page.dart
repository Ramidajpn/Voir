import 'package:flutter/material.dart';
import 'home_page.dart';
import 'graph_page.dart';
import 'profile_page.dart';
import 'ishihara_test_page.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

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
          // Eye
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
          // Edit - Active (with neumorphic effect)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(3, 3),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 8,
                  offset: const Offset(-3, -3),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              iconSize: 40,
              icon: const Icon(Icons.edit, color: Colors.black),
            ),
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
              clipper: WaveClipper(),
              child: Container(
                color: Colors.white,
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

                        // Center Image - larger
                        Container(
                          width: isTablet ? 380 : 300,
                          height: isTablet ? 380 : 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 40,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/girl_vr.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.remove_red_eye,
                                    size: isTablet ? 120 : 100,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: isTablet ? 40 : 28),

                        // Title Text - eye-catching
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 50 : 24,
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: isTablet ? 32 : 26,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Roboto',
                                color: Colors.black,
                                height: 1.3,
                              ),
                              children: [
                                const TextSpan(text: 'Welcome to '),
                                TextSpan(
                                  text: 'Voir Vision Lab',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 10, 11, 11),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: isTablet ? 12 : 8),

                        // Subtitle - build profile
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 50 : 24,
                          ),
                          child: Text(
                            "let's build your personal vision profile!",
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                              color: Colors.black87,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: isTablet ? 20 : 14),

                        // Description Text
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 50 : 24,
                          ),
                          child: Text(
                            'This quick 2-minute setup helps our AI understand your eyes perfectly.',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto',
                              color: Colors.black45,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: isTablet ? 50 : 36),

                        // Get Started Button - shorter width
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 80 : 50,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const IshiharaTestPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  vertical: isTablet ? 18 : 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 10,
                                shadowColor: Colors.black.withOpacity(0.4),
                              ),
                              child: Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
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
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left with wave
    path.moveTo(0, 60);

    // Create smooth wave curve
    path.quadraticBezierTo(
      size.width * 0.25,
      0,
      size.width * 0.5,
      30,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      60,
      size.width,
      20,
    );

    // Complete the rectangle
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
