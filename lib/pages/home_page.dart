import 'package:flutter/material.dart';
import 'graph_page.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showEmergencyStopDialog(BuildContext context, {bool isTablet = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Disable VOIR Lens?',
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Are you sure you want to disable the VOIR Lens?',
            style: TextStyle(
              color: Colors.white70,
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Roboto',
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            // No button (white)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 40 : 30,
                  vertical: isTablet ? 14 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'No',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            // Yes button (black)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement disable lens functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 40 : 30,
                  vertical: isTablet ? 14 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Yes',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 40.0 : 16.0,
              vertical: isTablet ? 30.0 : 16.0,
            ),
            child: _buildPhoneLayout(context, isTablet: isTablet),
          ),
        ),
      ),

      bottomNavigationBar: _buildNavigationBar(context, isTablet, 0),
    );
  }

  Widget _buildNavigationBar(BuildContext context, bool isTablet, int activeIndex) {
    return Container(
      margin: EdgeInsets.all(isTablet ? 24 : 20),
      padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12, horizontal: isTablet ? 24 : 16),
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
          // Home - Active (with neumorphic effect)
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
              icon: const Icon(Icons.home, color: Colors.black),
            ),
          ),
          // Graph - inactive (plain icon)
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const GraphPage()),
              );
            },
            iconSize: 40,
            icon: const Icon(Icons.show_chart_outlined, color: Colors.black),
          ),

          // Eye - Active (plain icon with white circle background)
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
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Icon(
              Icons.remove_red_eye,
              color: Colors.black,
              size: 56,
            ),
          ),

          // Edit/Pen - inactive (plain icon)
          IconButton(
            onPressed: () {},
            iconSize: 40,
            icon: const Icon(Icons.edit, color: Colors.black),
          ),
          // Person - inactive (plain icon)
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

  // Layout สำหรับมือถือและแท็บเล็ตแนวตั้ง (ใช้ UI เดียวกัน)
  Widget _buildPhoneLayout(BuildContext context, {bool isTablet = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Header Profile
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: isTablet ? 35 : 20,
                  backgroundColor: Colors.grey,
                  backgroundImage: const AssetImage('assets/john doe.png'),
                  onBackgroundImageError: (exception, stackTrace) {
                    // ถ้ารูปไม่พบ จะใช้สีเทาแทน
                  },
                ),
                SizedBox(width: isTablet ? 16 : 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome,",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: isTablet ? 16 : 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Text(
                      "John Doe!",
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Text(
                      "Types: Protanopia",
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: isTablet ? 35 : 35,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: isTablet ? 35 : 35,
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: isTablet ? 35 : 35),

        // 2. Title "Quick Look!"
        Text(
          "Quick Look!",
          style: TextStyle(
            fontSize: isTablet ? 42 : 24,
            fontWeight: FontWeight.w700,
            letterSpacing: isTablet ? 0.8 : 0,
            fontFamily: 'Roboto',
          ),
        ),
        SizedBox(height: isTablet ? 4 : 2),
        Text(
          "Your Contact Lens Status",
          style: TextStyle(
            fontSize: isTablet ? 20 : 14,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
            letterSpacing: isTablet ? 0.3 : 0,
            fontFamily: 'Roboto',
          ),
        ),

        SizedBox(height: isTablet ? 16 : 10),

        // 3. Lens Status (Left / Right) - Card Style
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLensStatusCard("Left", "95%", isTablet: isTablet),
            _buildLensStatusCard("Right", "95%", isTablet: isTablet),
          ],
        ),

        SizedBox(height: isTablet ? 16 : 10),

        // 4. Charger Case - Card Style
        Center(
          child: RepaintBoundary(
            child: Stack(
              children: [
                // Shadow/Background Layer
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: isTablet ? 140 : 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                // Main Card
                Container(
                  padding: EdgeInsets.all(isTablet ? 28 : 22),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Charger",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: isTablet ? 26 : 20,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: isTablet ? 4 : 2),
                          Text(
                            "100%",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: isTablet ? 26 : 20,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 8 : 4),
                      Container(
                        height: isTablet ? 240 : 180,
                        width: isTablet ? 240 : 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/case.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.white10,
                                child: Icon(
                                  Icons.battery_charging_full,
                                  size: isTablet ? 80 : 70,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: isTablet ? 16 : 10),

        // 5. Emergency Stop Button
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              final isTablet = MediaQuery.of(context).size.width > 600;
              _showEmergencyStopDialog(context, isTablet: isTablet);
            },
            icon: Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: isTablet ? 32 : 24,
            ),
            label: Text(
              "Emergency Stop",
              style: TextStyle(
                fontSize: isTablet ? 20 : 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white12,
              foregroundColor: Colors.white,
              elevation: isTablet ? 6 : 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(color: Colors.white, width: isTablet ? 2 : 1.5),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 60 : 40,
                vertical: isTablet ? 18 : 14,
              ),
            ),
          ),
        ),
        SizedBox(height: isTablet ? 16 : 10),
      ],
    );
  }

  // ฟังก์ชันสร้าง Widget ย่อยสำหรับสถานะเลนส์ (แบบ Card) - ไม่มี Card border
  Widget _buildLensStatusCard(
    String side,
    String percent, {
    bool isTablet = false,
  }) {
    return Column(
      children: [
        // Lens Image - ไม่มี Card, แค่รูป
        Container(
          height: isTablet ? 200 : 150,
          width: isTablet ? 240 : 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/lens.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.blueAccent.withOpacity(0.2),
                  child: Icon(
                    Icons.remove_red_eye,
                    size: isTablet ? 70 : 60,
                    color: Colors.blueAccent,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: isTablet ? 14 : 10),
        Text(
          side,
          style: TextStyle(
            color: Colors.grey,
            fontSize: isTablet ? 16 : 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
        SizedBox(height: isTablet ? 3 : 2),
        Text(
          percent,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isTablet ? 26 : 18,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }
}
