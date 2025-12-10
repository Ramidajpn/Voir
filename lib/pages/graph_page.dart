import 'package:flutter/material.dart';
import 'dart:math' show pi;
import 'package:fl_chart/fl_chart.dart';
import 'home_page.dart';
import 'profile_page.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> with TickerProviderStateMixin {
  late AnimationController _temperatureController;

  @override
  void initState() {
    super.initState();
    _temperatureController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _temperatureController.forward();
  }

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
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
            child: Column(
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

                // 2. Lens Surface Temperature Card
                Container(
                  padding: EdgeInsets.all(isTablet ? 24 : 18),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 250, 250, 251),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.6),
                        blurRadius: 12,
                        offset: const Offset(-4, -4),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.thermostat,
                                color: const Color(0xFF638D94),
                                size: isTablet ? 35 : 32,
                              ),
                              SizedBox(width: isTablet ? 12 : 8),
                              Text(
                                'Lens Surface Temperature',
                                style: TextStyle(
                                  fontSize: isTablet ? 30 : 28,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                  color: const Color(0xFF638D94),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 12 : 8,
                              vertical: isTablet ? 6 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Last measured 3 mins ago',
                              style: TextStyle(
                                fontSize: isTablet ? 12 : 10,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 20 : 16),
                      Text(
                        'Temperature is within the safe range',
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Roboto',
                          color: const Color(0xFF638D94),
                        ),
                      ),
                      SizedBox(height: isTablet ? 50 : 48),
                      Center(
                        child: AnimatedBuilder(
                          animation: _temperatureController,
                          builder: (context, child) {
                            return CustomPaint(
                              size: Size(isTablet ? 250 : 200, isTablet ? 125 : 100),
                              painter: SemiCircularGaugePainter(
                                value: _temperatureController.value * 0.35,
                                temperature: 35,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: isTablet ? 24 : 20),
                      // Status indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildIndicator(Colors.green, 'Safe', isTablet),
                          SizedBox(width: isTablet ? 24 : 16),
                          _buildIndicator(Colors.yellow[600]!, 'Careful', isTablet),
                          SizedBox(width: isTablet ? 24 : 16),
                          _buildIndicator(Colors.red[600]!, 'Danger', isTablet),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 20 : 16),

                // 3. Eye Health & Usage Card
                Container(
                  padding: EdgeInsets.all(isTablet ? 24 : 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCF4F7),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.6),
                        blurRadius: 12,
                        offset: const Offset(-4, -4),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye_outlined,
                            color: const Color(0xFF638D94),
                            size: isTablet ? 32 : 28,
                          ),
                          SizedBox(width: isTablet ? 12 : 8),
                          Text(
                            'Avg stability 95%',
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Roboto',
                              color: const Color(0xFF638D94),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 12 : 8),
                      Text(
                        'Eye Muscle Movement',
                        style: TextStyle(
                          fontSize: isTablet ? 30 : 28,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Roboto',
                          color: const Color(0xFF395D62),
                        ),
                      ),
                      SizedBox(height: isTablet ? 16 : 12),
                      Text(
                        'Smooth and stable',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Roboto',
                          color: const Color(0xFF638D94),
                        ),
                      ),
                      SizedBox(height: isTablet ? 16 : 12),
                      // Line chart with fl_chart
                      SizedBox(
                        height: isTablet ? 200 : 160,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: 200,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: const Color(0xFF638D94).withOpacity(0.1),
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    if (value == 0) {
                                      return const Text('Last 8 hrs',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF638D94),
                                          ));
                                    } else if (value == 6) {
                                      return const Text('Today',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF638D94),
                                          ));
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    if (value == 0 ||
                                        value == 400 ||
                                        value == 800) {
                                      return Text(
                                        '${value.toInt()}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF638D94),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            minX: 0,
                            maxX: 6,
                            minY: 0,
                            maxY: 800,
                            lineBarsData: [
                              LineChartBarData(
                                spots: [
                                  const FlSpot(0, 250),
                                  const FlSpot(1, 420),
                                  const FlSpot(2, 320),
                                  const FlSpot(3, 550),
                                  const FlSpot(4, 380),
                                  const FlSpot(5, 620),
                                  const FlSpot(6, 450),
                                ],
                                isCurved: false,
                                color: const Color(0xFF638D94),
                                barWidth: 3,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color:
                                      const Color(0xFF638D94).withOpacity(0.2),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      const Color(0xFF638D94).withOpacity(0.3),
                                      const Color(0xFF638D94).withOpacity(0.0),
                                    ],
                                  ),
                                ),
                                dotData: FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 12 : 8),
                      Center(
                        child: Text(
                          'Last 8 hrs',
                          style: TextStyle(
                            fontSize: isTablet ? 12 : 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            color: const Color(0xFF638D94),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 100 : 80),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildNavigationBar(context, isTablet),
    );
  }

  Widget _buildIndicator(Color color, String label, bool isTablet) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 14 : 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
            color: const Color(0xFF638D94),
          ),
        ),
      ],
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
          // Graph - Active (with neumorphic effect)
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
              icon: const Icon(Icons.show_chart_outlined, color: Colors.black),
            ),
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
            onPressed: () {},
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

class SemiCircularGaugePainter extends CustomPainter {
  final double value;
  final int temperature;

  SemiCircularGaugePainter({required this.value, required this.temperature});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background semi-circle
    final backgroundPaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, pi, pi, false, backgroundPaint);

    // Fill arc
    final fillPaint = Paint()
      ..color = const Color(0xFF9DD8E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, pi, pi * value, false, fillPaint);

    // Text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${temperature}°C',
        style: const TextStyle(
          color: Color(0xFF638D94),
          fontSize: 60,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      size.height * 0.75 - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(SemiCircularGaugePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.temperature != temperature;
  }
}
