import 'package:flutter/material.dart';
import 'home_page.dart';
import 'graph_page.dart';
import 'test_page.dart';
import 'profile/my_devices_page.dart';
import 'profile/privacy_settings_page.dart';
import 'profile/help_support_page.dart';
import 'profile/about_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _userName = 'John Doe';
  late String _colorBlindType = 'Protanopia';

  void _editUserName(BuildContext context, bool isTablet) {
    final TextEditingController controller = TextEditingController(text: _userName);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2C),
          title: Text(
            'Edit Username',
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: controller,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 18 : 16,
            ),
            decoration: InputDecoration(
              hintText: 'Enter new name',
              hintStyle: TextStyle(color: Colors.white30),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white30),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: const Color(0xFF638D94)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: isTablet ? 17 : 15,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() => _userName = controller.text);
                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: TextStyle(
                  color: const Color(0xFF638D94),
                  fontSize: isTablet ? 17 : 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editProfileImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo upload feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _removeColorType(BuildContext context, bool isTablet) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2C),
          title: Text(
            'Remove Color Vision Type',
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'This will reset your color vision settings. You can retake the color vision training game.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: isTablet ? 17 : 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: isTablet ? 13 : 11,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _colorBlindType = '';
                });
                Navigator.pop(context);
                // Navigate to color vision training game
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Redirecting to Color Vision Training Game...'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Text(
                'Remove',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: isTablet ? 13 : 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSettingsMenu(BuildContext context, bool isTablet) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: isTablet ? 300 : 250,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2C),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSettingMenuOption('Edit Profile', Icons.edit, isTablet, context),
                Divider(
                  color: Colors.white10,
                  height: isTablet ? 12 : 8,
                  thickness: 0.5,
                ),
                _buildSettingMenuOption('Privacy Settings', Icons.privacy_tip, isTablet, context),
                Divider(
                  color: Colors.white10,
                  height: isTablet ? 12 : 8,
                  thickness: 0.5,
                ),
                _buildSettingMenuOption('Help & Support', Icons.help, isTablet, context),
                Divider(
                  color: Colors.white10,
                  height: isTablet ? 12 : 8,
                  thickness: 0.5,
                ),
                _buildSettingMenuOption('About', Icons.info, isTablet, context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingMenuOption(String title, IconData icon, bool isTablet, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16 : 12,
          vertical: isTablet ? 14 : 10,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: isTablet ? 24 : 22,
            ),
            SizedBox(width: isTablet ? 14 : 10),
            Text(
              title,
              style: TextStyle(
                fontSize: isTablet ? 17 : 15,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(String label, String value, Color valueColor, bool isTablet) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
              color: valueColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isTablet ? 6 : 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
              color: Colors.white60,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context, bool isTablet) {
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
                  color: const Color.fromARGB(255, 243, 240, 240).withOpacity(0.15),
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
          // Person - Active (with neumorphic effect)
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
          child: Column(
            children: [
              // Top padding and settings icon row
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 40.0 : 20.0,
                  vertical: isTablet ? 16.0 : 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => _showSettingsMenu(context, isTablet),
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: isTablet ? 28 : 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main centered content
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 40.0 : 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. Large profile image with edit overlay
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.15),
                                blurRadius: 30,
                                spreadRadius: 5,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: isTablet ? 80 : 65,
                            backgroundColor: Colors.grey.shade700,
                            backgroundImage: const AssetImage('assets/john doe.png'),
                            onBackgroundImageError: (exception, stackTrace) {},
                          ),
                        ),
                        // Edit icon overlay
                        InkWell(
                          onTap: _editProfileImage,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF638D94),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: isTablet ? 18 : 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: isTablet ? 32 : 24),

                    // 2. Username with edit icon
                    GestureDetector(
                      onTap: () => _editUserName(context, isTablet),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _userName,
                            style: TextStyle(
                              fontSize: isTablet ? 42 : 36,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Roboto',
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: isTablet ? 12 : 8),
                          Icon(
                            Icons.edit,
                            color: Colors.white54,
                            size: isTablet ? 20 : 18,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isTablet ? 16 : 12),

                    // 3. User info (email, color type, device id)
                    Column(
                      children: [
                        Text(
                          'john.doe@gmail.com',
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: isTablet ? 8 : 4),
                        if (_colorBlindType.isNotEmpty)
                          GestureDetector(
                            onTap: () => _removeColorType(context, isTablet),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 12 : 8,
                                    vertical: isTablet ? 6 : 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF638D94).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _colorBlindType,
                                    style: TextStyle(
                                      fontSize: isTablet ? 16 : 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Roboto',
                                      color: const Color(0xFF638D94),
                                    ),
                                  ),
                                ),
                                SizedBox(width: isTablet ? 8 : 4),
                                Icon(
                                  Icons.close,
                                  color: Colors.white30,
                                  size: isTablet ? 14 : 12,
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: isTablet ? 8 : 4),
                        Text(
                          'VL-2024-001',
                          style: TextStyle(
                            fontSize: isTablet ? 15 : 13,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            color: Colors.white30,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: isTablet ? 32 : 24),

                    // 4. Stats row (Battery, Firmware, Last Sync)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isTablet ? 20 : 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatsCard('Left Lens', '95%', Colors.green, isTablet),
                              Container(
                                width: 1,
                                height: isTablet ? 50 : 40,
                                color: Colors.white.withOpacity(0.1),
                              ),
                              _buildStatsCard('Right Lens', '95%', Colors.green, isTablet),
                              Container(
                                width: 1,
                                height: isTablet ? 50 : 40,
                                color: Colors.white.withOpacity(0.1),
                              ),
                              _buildStatsCard('Case', '100%', Colors.blue, isTablet),
                            ],
                          ),
                          SizedBox(height: isTablet ? 20 : 16),
                          Divider(
                            color: Colors.white.withOpacity(0.1),
                            height: 1,
                          ),
                          SizedBox(height: isTablet ? 20 : 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatsCard('Firmware', 'v2.1.0', const Color(0xFF638D94), isTablet),
                              Container(
                                width: 1,
                                height: isTablet ? 50 : 40,
                                color: Colors.white.withOpacity(0.1),
                              ),
                              _buildStatsCard('Last Sync', '2 min ago', Colors.blue, isTablet),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isTablet ? 40 : 32),

                    // 5. Settings container with rounded white background
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.all(isTablet ? 20 : 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Settings',
                            style: TextStyle(
                              fontSize: isTablet ? 24 : 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: isTablet ? 20 : 16),
                          _buildSettingsRow('Edit Profile', Icons.edit, isTablet),
                          Divider(
                            color: Colors.white.withOpacity(0.1),
                            height: isTablet ? 20 : 16,
                            thickness: 0.5,
                          ),
                          _buildSettingsRow('Privacy Settings', Icons.privacy_tip, isTablet),
                          Divider(
                            color: Colors.white.withOpacity(0.1),
                            height: isTablet ? 20 : 16,
                            thickness: 0.5,
                          ),
                          _buildSettingsRow('Help & Support', Icons.help, isTablet),
                          Divider(
                            color: Colors.white.withOpacity(0.1),
                            height: isTablet ? 20 : 16,
                            thickness: 0.5,
                          ),
                          _buildSettingsRow('About', Icons.info, isTablet),
                          Divider(
                            color: Colors.white.withOpacity(0.1),
                            height: isTablet ? 20 : 16,
                            thickness: 0.5,
                          ),
                          _buildSettingsRow('My Devices', Icons.devices, isTablet),
                          Divider(
                            color: Colors.white.withOpacity(0.1),
                            height: isTablet ? 20 : 16,
                            thickness: 0.5,
                          ),
                          _buildSettingsRow('Download My Data', Icons.cloud_download, isTablet),
                          Divider(
                            color: Colors.white.withOpacity(0.1),
                            height: isTablet ? 20 : 16,
                            thickness: 0.5,
                          ),
                          _buildSettingsRowDanger('Sign Out', Icons.logout, isTablet),
                        ],
                      ),
                    ),

                    SizedBox(height: isTablet ? 100 : 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildNavigationBar(context, isTablet),
    );
  }

  Widget _buildSettingsRow(String title, IconData icon, bool isTablet) {
    return InkWell(
      onTap: () {
        if (title == 'Edit Profile') {
          // Navigate to Edit Profile
        } else if (title == 'Privacy Settings') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PrivacySettingsPage()),
          );
        } else if (title == 'Help & Support') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HelpSupportPage()),
          );
        } else if (title == 'About') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AboutPage()),
          );
        } else if (title == 'My Devices') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MyDevicesPage()),
          );
        } else if (title == 'Download My Data') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Downloading your data...')),
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white70,
                size: isTablet ? 20 : 18,
              ),
              SizedBox(width: isTablet ? 12 : 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white30,
            size: isTablet ? 14 : 12,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRowDanger(String title, IconData icon, bool isTablet) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2A2A2C),
              title: Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Text(
                'Are you sure you want to sign out?',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isTablet ? 17 : 15,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: isTablet ? 17 : 15,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Signing out...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: isTablet ? 17 : 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.red.withOpacity(0.7),
                size: isTablet ? 20 : 18,
              ),
              SizedBox(width: isTablet ? 12 : 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                  color: Colors.red.withOpacity(0.8),
                ),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.red.withOpacity(0.3),
            size: isTablet ? 14 : 12,
          ),
        ],
      ),
    );
  }
}
