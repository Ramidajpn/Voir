import 'package:flutter/material.dart';
import 'home_page.dart';
import 'graph_page.dart';
import 'profile_page.dart';

class IshiharaTestPage extends StatefulWidget {
  const IshiharaTestPage({super.key});

  @override
  State<IshiharaTestPage> createState() => _IshiharaTestPageState();
}

class _IshiharaTestPageState extends State<IshiharaTestPage> {
  int currentPlate = 1;
  bool showResult = false;

  // Score counters
  int normal = 0;
  int protan = 0;
  int deutan = 0;
  int monochrome = 0;

  // Plate data: each plate has choices with their scoring rules
  // Format: {'choice': {'normal': x, 'protan': x, 'deutan': x, 'monochrome': x}}
  final Map<int, Map<String, Map<String, int>>> plateData = {
    // Group 1 - Plate 1
    1: {
      '72': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '12': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    // Group 2 - Plates 2-9 (Normal / Red-Green / Monochrome)
    2: {
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      '8': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '3': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
    },
    3: {
      '6': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '5': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    4: {
      '70': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      '29': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    5: {
      '57': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      '35': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
    },
    6: {
      '5': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '2': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    7: {
      '5': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      '3': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
    },
    8: {
      '15': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      '17': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
    },
    9: {
      '21': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      '74': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    // Group 3 - Plates 10-17 (Normal vs Red-Green/Monochrome)
    10: {
      '2': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 1},
    },
    11: {
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 1},
      '6': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
    },
    12: {
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 1},
      '97': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
    },
    13: {
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 1},
      '45': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
    },
    14: {
      '5': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 1},
    },
    15: {
      '7': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 1},
    },
    16: {
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 1},
      '16': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
    },
    17: {
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 1},
      '73': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
    },
    // Group 4 - Plates 18-21 (Hidden digits — Colorblind sees numbers)
    18: {
      '5': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    19: {
      'Can\'t see anything': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      '2': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
    },
    20: {
      '45': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    21: {
      'Can\'t see anything': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      '73': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
    },
    // Group 5 - Plates 22-24 (Classification — MOST IMPORTANT)
    22: {
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      '26': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '2': {'normal': 0, 'protan': 0, 'deutan': 1, 'monochrome': 0},
      '6': {'normal': 0, 'protan': 1, 'deutan': 0, 'monochrome': 0},
    },
    23: {
      '42': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '2': {'normal': 0, 'protan': 1, 'deutan': 0, 'monochrome': 0},
      '4': {'normal': 0, 'protan': 0, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    24: {
      '5': {'normal': 0, 'protan': 1, 'deutan': 0, 'monochrome': 0},
      '35': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      '3': {'normal': 0, 'protan': 0, 'deutan': 1, 'monochrome': 0}
    },
    25:{
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      '6': {'normal': 0, 'protan': 1, 'deutan': 0, 'monochrome': 0},
      '9': {'normal': 0, 'protan': 0, 'deutan': 1, 'monochrome': 0},
      '96': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0}
    },
    26: {
      'red line': {'normal': 0, 'protan': 0, 'deutan': 1, 'monochrome': 0},
      'purple and red line spots': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'purple line': {'normal': 0, 'protan': 1, 'deutan': 0, 'monochrome': 0},
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1}
    },
    27: {
      'purple line': {'normal': 0, 'protan': 1, 'deutan': 0, 'monochrome': 0},
      'purple and red line spots': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'red line': {'normal': 0, 'protan': 0, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1}
    },
    28: {
      'a line': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0}
    },
    29: {
      'Can\'t see anything': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'a line': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0}
    },
    30: {
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      'blue or green line': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0}
    },
    31: {
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      'blue or green line': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
    },
    32: {
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'orange line': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1}
    },
    33: {
      'orange line': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1}
    },
    34: {
      'blue or green line': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      'red-green or violet line': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0}
    },
    35: {
      'blue or green line': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'red-green or violet line': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1}
    },
    36: {
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      'orange line': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'blue-green or violet line': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0}
    },
    37: {
      'blue-green or violet line': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'orange line': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1}
    },
  };

  void _handleAnswer(String choice) {
    final scores = plateData[currentPlate]?[choice];
    if (scores != null) {
      setState(() {
        normal += scores['normal'] ?? 0;
        protan += scores['protan'] ?? 0;
        deutan += scores['deutan'] ?? 0;
        monochrome += scores['monochrome'] ?? 0;

        if (currentPlate < 37) {
          currentPlate++;
        } else {
          showResult = true;
        }
      });
    }
  }

  String _getResultType() {
    final scores = {
      'normal': normal,
      'protan': protan,
      'deutan': deutan,
      'monochrome': monochrome,
    };

    final maxScore = scores.values.reduce((a, b) => a > b ? a : b);
    return scores.entries.firstWhere((e) => e.value == maxScore).key;
  }

  String _getResult() {
    final winner = _getResultType();

    switch (winner) {
      case 'normal':
        return 'Normal Color Vision';
      case 'protan':
        return 'Protanopia / Protanomaly';
      case 'deutan':
        return 'Deuteranopia / Deuteranomaly';
      case 'monochrome':
        return 'Monochromacy (Severe Color Blindness)';
      default:
        return 'Unknown';
    }
  }

  String _getAvatarPath() {
    final type = _getResultType();
    switch (type) {
      case 'normal':
        return 'assets/avatar/normal.png';
      case 'protan':
        return 'assets/avatar/protan.png';
      case 'deutan':
        return 'assets/avatar/Deutan.png';
      case 'monochrome':
        return 'assets/avatar/mono.png';
      default:
        return 'assets/avatar/normal.png';
    }
  }

  String _getResultTitle() {
    final type = _getResultType();
    switch (type) {
      case 'normal':
        return 'Normal Vision';
      case 'protan':
        return 'Protanopia';
      case 'deutan':
        return 'Deuteranopia';
      case 'monochrome':
        return 'Monochromacy';
      default:
        return 'Unknown';
    }
  }

  Color _getAccentColor() {
    final type = _getResultType();
    switch (type) {
      case 'normal':
        return const Color(0xFF4CAF50); // Green
      case 'protan':
        return const Color(0xFFE53935); // Red
      case 'deutan':
        return const Color(0xFF43A047); // Green
      case 'monochrome':
        return const Color(0xFF607D8B); // Blue Grey
      default:
        return Colors.black;
    }
  }

  Color _getAccentLightColor() {
    final type = _getResultType();
    switch (type) {
      case 'normal':
        return const Color(0xFFE8F5E9); // Light Green
      case 'protan':
        return const Color(0xFFFFF5F5); // Light Red
      case 'deutan':
        return const Color(0xFFF1F8E9); // Light Green
      case 'monochrome':
        return const Color(0xFFECEFF1); // Light Blue Grey
      default:
        return Colors.grey.shade100;
    }
  }

  String _getResultEmoji() {
    final type = _getResultType();
    switch (type) {
      case 'normal':
        return '🌈';
      case 'protan':
        return '❤️';
      case 'deutan':
        return '🌿';
      case 'monochrome':
        return '✨';
      default:
        return '';
    }
  }

  String _getResultDescription() {
    final type = _getResultType();
    switch (type) {
      case 'normal':
        return 'Your color perception aligns closely with the typical visual spectrum found in most of the global population.\n\nThis means you can distinguish hues and contrasts across the full color range, just as most standardized visual designs intend.';
      case 'protan':
        return 'Your perception of red-based hues works a little differently from average observers.\n\nColors in the red spectrum may appear softer or shifted, shaping a unique way you interpret contrast.\n\nYou\'re not "incorrect"—you simply perceive color through your own spectrum.';
      case 'deutan':
        return 'You may see red-green-brown hues as closer together compared to typical observers.\n\nSome green or red tones blend softly, forming a characteristic palette that\'s uniquely yours.';
      case 'monochrome':
        return 'Your visual system may rely more on brightness, contrast, and shapes rather than hue-based information.\n\nThis can make the world appear more grayscale or limited in color range.';
      default:
        return '';
    }
  }

  String _getHiddenStrengths() {
    final type = _getResultType();
    switch (type) {
      case 'normal':
        return 'Your visual profile is right in the sweet spot where most color systems are calibrated. You can enjoy the full spectrum of colors as intended by designers and artists worldwide!';
      case 'protan':
        return 'Many people with protan vision develop strong contrast awareness, lighting interpretation skills, and attention to detail. These abilities often translate into exceptional pattern recognition.';
      case 'deutan':
        return 'People with deutan vision often show strong brightness sensitivity, shading interpretation, and texture recognition. Your unique perspective can reveal details others might miss.';
      case 'monochrome':
        return 'Many monochromatic viewers excel in luminance sensitivity and fine-detail recognition. Your visual system may process shapes and contrasts with exceptional clarity.';
      default:
        return '';
    }
  }

  String _getAIExplanation() {
    final type = _getResultType();
    switch (type) {
      case 'normal':
        return 'Our AI has analyzed your responses and confirmed your standard color perception range.';
      case 'protan':
        return 'Our AI will now adjust your color space to match your natural visual range.';
      case 'deutan':
        return 'Your profile is now prepared for AI-optimized color rendering designed specifically for you.';
      case 'monochrome':
        return 'Our AI is ready to enhance your environment according to the way you naturally see.';
      default:
        return '';
    }
  }

  void _restartTest() {
    setState(() {
      currentPlate = 1;
      showResult = false;
      normal = 0;
      protan = 0;
      deutan = 0;
      monochrome = 0;
    });
  }

  Widget _buildNavigationBar(BuildContext context, bool isTablet) {
    return Container(
      margin: EdgeInsets.all(isTablet ? 24 : 20),
      padding: EdgeInsets.symmetric(
        vertical: isTablet ? 16 : 12,
        horizontal: isTablet ? 24 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
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
            icon: const Icon(Icons.home, color: Colors.white),
          ),
          // Graph
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const GraphPage()),
              );
            },
            iconSize: 40,
            icon: const Icon(Icons.show_chart_outlined, color: Colors.white),
          ),
          // Eye
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 16,
                  spreadRadius: 3,
                  offset: const Offset(0, 6),
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
          // Edit - Active (with pressed inward/concave effect)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black,
              boxShadow: [
                // Inner shadow effect (concave/pressed inward)
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
                BoxShadow(
                  color: Colors.grey.shade800,
                  blurRadius: 4,
                  offset: const Offset(-1, -1),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.shade900,
                  Colors.black,
                ],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade700,
                  width: 1,
                ),
              ),
              child: IconButton(
                onPressed: () {},
                iconSize: 40,
                icon: const Icon(Icons.edit, color: Colors.white),
              ),
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
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTestContent(BuildContext context, bool isTablet) {
    final choices = plateData[currentPlate]?.keys.toList() ?? [];

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 24),
        child: Column(
          children: [
            SizedBox(height: isTablet ? 60 : 40),

            // Top Text
            Text(
              'What number or color do you see?',
              style: TextStyle(
                fontSize: isTablet ? 36 : 28,
                fontWeight: FontWeight.w700,
                fontFamily: 'Roboto',
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: isTablet ? 20 : 16),

            Text(
              'This test uses randomized color dot plates to confirm the type of your color vision deficiency before proceeding to the detailed AI Spectral Test.',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto',
                color: Colors.black54,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: isTablet ? 32 : 24),

            // Plate indicator
            Text(
              'Plate $currentPlate of 37',
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Roboto',
                color: Colors.black87,
              ),
            ),

            SizedBox(height: isTablet ? 32 : 24),

            // Ishihara Image
            Container(
              width: isTablet ? 350 : 280,
              height: isTablet ? 350 : 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/ishihara/plate_$currentPlate.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: isTablet ? 60 : 50,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Plate $currentPlate',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: isTablet ? 18 : 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: isTablet ? 40 : 32),

            // Answer Choices
            ...choices.map((choice) => Padding(
                  padding: EdgeInsets.only(bottom: isTablet ? 16 : 14),
                  child: SizedBox(
                    width: isTablet ? 320 : 260,
                    child: OutlinedButton(
                      onPressed: () => _handleAnswer(choice),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(color: Colors.black, width: 2),
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 18 : 16,
                          horizontal: isTablet ? 36 : 28,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        choice,
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                )),

            SizedBox(height: isTablet ? 50 : 40),
          ],
        ),
      ),
    );
  }

  // Dark theme navbar for result screen
  Widget _buildResultNavigationBar(BuildContext context, bool isTablet) {
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

  Widget _buildResultContent(BuildContext context, bool isTablet) {
    final resultTitle = _getResultTitle();
    final avatarPath = _getAvatarPath();
    final description = _getResultDescription();
    final hiddenStrengths = _getHiddenStrengths();
    final aiExplanation = _getAIExplanation();
    final accentColor = _getAccentColor();
    final accentLightColor = _getAccentLightColor();
    final emoji = _getResultEmoji();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 50 : 28),
        child: Column(
          children: [
            SizedBox(height: isTablet ? 40 : 24),

            // "Your result is..." header
            Text(
              'Your result is...',
              style: TextStyle(
                fontSize: isTablet ? 38 : 32,
                fontWeight: FontWeight.w700,
                fontFamily: 'Roboto',
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: isTablet ? 28 : 20),

            // White Card with avatar and result
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 24 : 20,
                vertical: isTablet ? 28 : 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 4,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.15),
                    blurRadius: 50,
                    spreadRadius: 6,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Result Title with emoji and accent color
                  Text(
                    '$resultTitle $emoji',
                    style: TextStyle(
                      fontSize: isTablet ? 28 : 24,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Roboto',
                      color: accentColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: isTablet ? 20 : 16),

                  // Avatar Image - bigger mascot
                  Container(
                    width: isTablet ? 180 : 140,
                    height: isTablet ? 180 : 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        avatarPath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              size: isTablet ? 100 : 80,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 24 : 20),

                  // Description Text - Left aligned, dark gray, bold
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                        color: const Color(0xFF424242), // Dark gray
                        height: 1.8,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  SizedBox(height: isTablet ? 20 : 16),

                  // Hidden Strengths Feature Box
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isTablet ? 18 : 14),
                    decoration: BoxDecoration(
                      color: accentLightColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '✨ Hidden Strengths',
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Roboto',
                            color: accentColor,
                          ),
                        ),
                        SizedBox(height: isTablet ? 10 : 8),
                        Text(
                          hiddenStrengths,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 13,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            color: const Color(0xFF616161),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 18 : 14),

                  // AI Explanation - smaller, italic, gray
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      aiExplanation,
                      style: TextStyle(
                        fontSize: isTablet ? 13 : 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Roboto',
                        color: const Color(0xFF9E9E9E),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: isTablet ? 48 : 40),

            // Bottom text with wide margins
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 12),
              child: Text(
                'To unlock full AI Lens features, please scan your medical certificate so the system can tailor your visual experience just for you!',
                style: TextStyle(
                  fontSize: isTablet ? 13 : 11,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                  color: Colors.white54,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: isTablet ? 28 : 24),

            // Next Button (white with black text + white drop shadow)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.15),
                    blurRadius: 40,
                    spreadRadius: 4,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SizedBox(
                width: isTablet ? 240 : 180,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to next screen (medical scan)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 16 : 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: isTablet ? 17 : 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: isTablet ? 16 : 14),

            // Restart Test button (dark grey + white drop shadow)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SizedBox(
                width: isTablet ? 240 : 180,
                child: ElevatedButton(
                  onPressed: _restartTest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade800,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 14 : 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Restart Test',
                    style: TextStyle(
                      fontSize: isTablet ? 15 : 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: isTablet ? 28 : 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      backgroundColor: showResult ? Colors.black : Colors.white,
      body: SafeArea(
        child: showResult
            ? _buildResultContent(context, isTablet)
            : _buildTestContent(context, isTablet),
      ),
      bottomNavigationBar: showResult
          ? _buildResultNavigationBar(context, isTablet)
          : _buildNavigationBar(context, isTablet),
    );
  }
}
