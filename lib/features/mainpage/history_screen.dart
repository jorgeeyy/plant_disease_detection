import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedNavIndex = 1; // History is index 1

  void _handleNavigation(int index) {
    if (index == _selectedNavIndex) return;

    setState(() => _selectedNavIndex = index);

    // Navigate to the appropriate screen
    if (index == 0) {
      // Navigate to Home (Leaf Scanner)
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 2) {
      // Navigate to Settings
      Navigator.pushReplacementNamed(context, '/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Scan History',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // backgroundColor: Colors.white,
          // foregroundColor: Colors.white,
          // automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                          'All Scans',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Diseased',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Healthy',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'this week'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage('assets/images/blight.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Diseased',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Early Blight',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Oct 24, 2023'),
                                    Text('96% Confident'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedNavIndex,
          onItemTapped: _handleNavigation,
        ),
      );
  }
}
