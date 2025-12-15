import 'package:flutter/material.dart';
import '../home_page.dart';
import '../graph_page.dart';
import '../profile_page.dart';
import '../test_page.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  Widget _buildHelpCategory(String title, List<String> items, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
              color: Colors.white,
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          ...items.asMap().entries.map((entry) {
            int index = entry.key;
            String item = entry.value;
            bool isLast = index == items.length - 1;

            return Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white30,
                        size: isTablet ? 12 : 10,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: isTablet ? 8 : 6),
                    child: Divider(
                      color: Colors.white.withOpacity(0.1),
                      height: 1,
                    ),
                  ),
              ],
            );
          }),
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
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            iconSize: 40,
            icon: const Icon(Icons.home, color: Colors.black),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const GraphPage()),
              );
            },
            iconSize: 40,
            icon: const Icon(Icons.show_chart_outlined, color: Colors.black),
          ),
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
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: const Icon(
              Icons.remove_red_eye,
              color: Colors.black,
              size: 56,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const TestPage()),
              );
            },
            iconSize: 40,
            icon: const Icon(Icons.edit, color: Colors.black),
          ),
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
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
              iconSize: 40,
              icon: const Icon(Icons.person, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 40.0 : 20.0,
              vertical: isTablet ? 20.0 : 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(isTablet ? 12 : 8),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: isTablet ? 20 : 18,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isTablet ? 32 : 24),

                // Title
                Text(
                  'Help & Support',
                  style: TextStyle(
                    fontSize: isTablet ? 36 : 28,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto',
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: isTablet ? 12 : 8),

                Text(
                  'Get help with your Voir smart contact lenses',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                    color: Colors.white70,
                  ),
                ),

                SizedBox(height: isTablet ? 40 : 32),

                _buildHelpCategory('Tutorials', [
                  'How to Wear & Remove',
                  'AI Modes Guide',
                  'Getting Started',
                ], isTablet),

                SizedBox(height: isTablet ? 20 : 16),

                _buildHelpCategory('Troubleshooting', [
                  'Connection Issues',
                  'Color Correction Fix',
                  'Battery Problems',
                  'Device Not Responding',
                ], isTablet),

                SizedBox(height: isTablet ? 20 : 16),

                _buildHelpCategory('Support', [
                  'Live Chat Support',
                  'Email Support',
                  'Schedule Video Call',
                ], isTablet),

                SizedBox(height: isTablet ? 20 : 16),

                _buildHelpCategory('Emergency', [
                  'Emergency Guide',
                  'Report Hardware Issue',
                  'Medical Emergency',
                ], isTablet),

                SizedBox(height: isTablet ? 100 : 80),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildNavigationBar(context, isTablet),
    );
  }
}
