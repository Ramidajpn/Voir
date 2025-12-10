import 'package:flutter/material.dart';
import '../home_page.dart';
import '../graph_page.dart';
import '../profile_page.dart';

class MyDevicesPage extends StatelessWidget {
  const MyDevicesPage({super.key});

  Widget _buildDeviceStatus(String name, String status, Color statusColor, String battery, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                  color: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 12 : 8,
                  vertical: isTablet ? 6 : 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: isTablet ? 12 : 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Battery Level',
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                  color: Colors.white70,
                ),
              ),
              Text(
                battery,
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, VoidCallback onTap, bool isTablet) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: isTablet ? 22 : 20,
            ),
            SizedBox(width: isTablet ? 12 : 8),
            Text(
              title,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white30,
              size: isTablet ? 14 : 12,
            ),
          ],
        ),
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
            onPressed: () {},
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
                  'My Devices',
                  style: TextStyle(
                    fontSize: isTablet ? 36 : 28,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto',
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: isTablet ? 12 : 8),

                Text(
                  'Manage your Voir contact lenses and charging case',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                    color: Colors.white70,
                  ),
                ),

                SizedBox(height: isTablet ? 40 : 32),

                // Connection Status
                Text(
                  'Connection Status',
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: isTablet ? 16 : 12),

                _buildDeviceStatus('Left Lens', 'Connected', Colors.green, '95%', isTablet),
                SizedBox(height: isTablet ? 12 : 8),
                _buildDeviceStatus('Right Lens', 'Connected', Colors.green, '95%', isTablet),
                SizedBox(height: isTablet ? 12 : 8),
                _buildDeviceStatus('Charging Case', 'Connected', Colors.green, '100%', isTablet),

                SizedBox(height: isTablet ? 40 : 32),

                // Device Actions
                Text(
                  'Device Actions',
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: isTablet ? 16 : 12),

                _buildActionButton('Find My Lenses', Icons.location_on, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Activating sound and LED pulse on lenses...')),
                  );
                }, isTablet),

                SizedBox(height: isTablet ? 12 : 8),

                _buildActionButton('Firmware Update', Icons.system_update, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Checking for updates...')),
                  );
                }, isTablet),

                SizedBox(height: isTablet ? 12 : 8),

                _buildActionButton('Calibration Info', Icons.info, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Last calibration: Dec 8, 2024')),
                  );
                }, isTablet),

                SizedBox(height: isTablet ? 12 : 8),

                _buildActionButton('Re-calibrate', Icons.tune, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Starting recalibration process...')),
                  );
                }, isTablet),

                SizedBox(height: isTablet ? 12 : 8),

                _buildActionButton('Unpair Device', Icons.link_off, () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: const Color(0xFF2A2A2C),
                        title: const Text(
                          'Unpair Device',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Text(
                          'Are you sure you want to unpair these lenses? You\'ll need to re-pair them to use this app.',
                          style: TextStyle(color: Colors.white70, fontSize: isTablet ? 14 : 12),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Lenses unpaired successfully')),
                              );
                            },
                            child: const Text('Unpair', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                }, isTablet),

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
