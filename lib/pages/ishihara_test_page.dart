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
      '12': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '72': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'ไม่เห็นเลข': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    // Group 2 - Plates 2-9 (Normal / Red-Green / Monochrome)
    2: {
      '8': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '3': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'ไม่เห็นเลข': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    3: {
      '6': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '5': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    4: {
      '29': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '70': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    5: {
      '57': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '35': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    6: {
      '5': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '2': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    7: {
      '3': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '5': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    8: {
      '15': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '17': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    9: {
      '74': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '21': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    // Group 3 - Plates 10-17 (Normal vs Red-Green/Monochrome)
    10: {
      '2': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 1},
    },
    11: {
      '6': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 1},
    },
    12: {
      '97': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 1},
    },
    13: {
      '45': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 1},
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
      '16': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 1},
    },
    17: {
      '73': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 1},
    },
    // Group 4 - Plates 18-21 (Hidden digits — Colorblind sees numbers)
    18: {
      'Can\'t see anything': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      '5': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
    },
    19: {
      'Can\'t see anything': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      '2': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
    },
    20: {
      'Can\'t see anything': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      '45': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
    },
    21: {
      'Can\'t see anything': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 1},
      '73': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
    },
    // Group 5 - Plates 22-24 (Classification — MOST IMPORTANT)
    22: {
      '26': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '6': {'normal': 0, 'protan': 1, 'deutan': 0, 'monochrome': 0},
      '2': {'normal': 0, 'protan': 0, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    23: {
      '42': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '2': {'normal': 0, 'protan': 1, 'deutan': 0, 'monochrome': 0},
      '4': {'normal': 0, 'protan': 0, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    24: {
      '35': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '5': {'normal': 0, 'protan': 1, 'deutan': 0, 'monochrome': 0},
      '3': {'normal': 0, 'protan': 0, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1},
    },
    25:{
      '96': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      '6': {'normal': 0, 'protan': 1, 'deutan': 0, 'monochrome': 0},
      '9': {'normal': 0, 'protan': 0, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1}
    },
    26: {
      'purple and red line spots': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'purple line': {'normal': 0, 'protan': 1, 'deutan': 0, 'monochrome': 0},
      'red line': {'normal': 0, 'protan': 0, 'deutan': 1, 'monochrome': 0},
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1}
    },
    27: {
      'purple and red line spots': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'purple line': {'normal': 0, 'protan': 1, 'deutan': 0, 'monochrome': 0},
      'red line': {'normal': 0, 'protan': 0, 'deutan': 1, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1}
    },
    28: {
      'Can\'t see anything': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'a line': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0}
    },
    29: {
      'Can\'t see anything': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'a line': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0}
    },
    30: {
      'blue or green line': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1}
    },
    31: {
      'blue or green line': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1}
    },
    32: {
      'orange line': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1}
    },
    33: {
      'orange line': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'Can\'t see anything': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1}
    },
    34: {
      'blue or green line': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'red-green or violet line': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1}
    },
    35: {
      'blue or green line': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'red-green or violet line': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1}
    },
    36: {
      'orange line': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'blue-green or violet line': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
      'black and grey': {'normal': 0, 'protan': 0, 'deutan': 0, 'monochrome': 1}
    },
    37: {
      'orange line': {'normal': 1, 'protan': 0, 'deutan': 0, 'monochrome': 0},
      'blue-green or violet line': {'normal': 0, 'protan': 1, 'deutan': 1, 'monochrome': 0},
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

        if (currentPlate < 24) {
          currentPlate++;
        } else {
          showResult = true;
        }
      });
    }
  }

  String _getResult() {
    final scores = {
      'normal': normal,
      'protan': protan,
      'deutan': deutan,
      'monochrome': monochrome,
    };

    final maxScore = scores.values.reduce((a, b) => a > b ? a : b);
    final winner = scores.entries.firstWhere((e) => e.value == maxScore).key;

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
              'What number do you see?',
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
              'Plate $currentPlate of 24',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.w600,
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

  Widget _buildResultContent(BuildContext context, bool isTablet) {
    final result = _getResult();

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Result:',
              style: TextStyle(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: isTablet ? 24 : 16),

            Text(
              result,
              style: TextStyle(
                fontSize: isTablet ? 36 : 28,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: isTablet ? 48 : 36),

            // Restart Button
            SizedBox(
              width: isTablet ? 250 : 200,
              child: ElevatedButton(
                onPressed: _restartTest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: isTablet ? 18 : 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                  shadowColor: Colors.black.withOpacity(0.4),
                ),
                child: Text(
                  'Restart Test',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: showResult
            ? _buildResultContent(context, isTablet)
            : _buildTestContent(context, isTablet),
      ),
      bottomNavigationBar: _buildNavigationBar(context, isTablet),
    );
  }
}
