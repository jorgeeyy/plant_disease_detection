import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedNavIndex = 1; // History is index 1

  // Sample history data
  final List<Map<String, dynamic>> _scanHistory = [
    {
      'plant': 'Tomato',
      'disease': 'Early Blight',
      'date': '2026-01-25',
      'confidence': '95%',
    },
    {
      'plant': 'Potato',
      'disease': 'Late Blight',
      'date': '2026-01-24',
      'confidence': '88%',
    },
    {
      'plant': 'Corn',
      'disease': 'Healthy',
      'date': '2026-01-23',
      'confidence': '92%',
    },
  ];

  void _handleNavigation(int index) {
    if (index == _selectedNavIndex) return;

    setState(() => _selectedNavIndex = index);

    // Navigate to the appropriate screen
    if (index == 0) {
      // Navigate to Home (Leaf Scanner)
      Navigator.pushReplacementNamed(context, '/');
    } else if (index == 2) {
      // Navigate to Settings
      Navigator.pushReplacementNamed(context, '/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scan History'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: _scanHistory.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No scan history yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _scanHistory.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final scan = _scanHistory[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: scan['disease'] == 'Healthy'
                                  ? Colors.green
                                  : Colors.orange,
                              child: Icon(
                                scan['disease'] == 'Healthy'
                                    ? Icons.check
                                    : Icons.warning,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              scan['plant'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  scan['disease'],
                                  style: TextStyle(
                                    color: scan['disease'] == 'Healthy'
                                        ? Colors.green
                                        : Colors.orange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Date: ${scan['date']}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Confidence: ${scan['confidence']}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: () {
                                // TODO: Navigate to detailed scan result
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            BottomNavBar(
              selectedIndex: _selectedNavIndex,
              onItemTapped: _handleNavigation,
            ),
          ],
        ),
      ),
    );
  }
}
