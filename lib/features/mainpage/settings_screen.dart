import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../theme_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _offlineModeEnabled = false;
  int _selectedNavIndex = 2; // Settings is index 2

  void _handleNavigation(int index) {
    if (index == _selectedNavIndex) return;

    setState(() => _selectedNavIndex = index);

    // Navigate to the appropriate screen
    if (index == 0) {
      // Navigate to Home (Leaf Scanner)
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      // Navigate to History
      Navigator.pushReplacementNamed(context, '/history');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 16),

                  // General Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'General',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  SwitchListTile(
                    title: const Text('Notifications'),
                    subtitle: const Text('Enable push notifications'),
                    value: _notificationsEnabled,
                    activeThumbColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),

                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Use dark theme'),
                    value: themeManager.isDarkMode,
                    activeThumbColor: Colors.green,
                    onChanged: (value) {
                      themeManager.toggleTheme(value);
                    },
                  ),

                  SwitchListTile(
                    title: const Text('Offline Mode'),
                    subtitle: const Text('Work without internet connection'),
                    value: _offlineModeEnabled,
                    activeThumbColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        _offlineModeEnabled = value;
                      });
                    },
                  ),

                  const Divider(),

                  // Camera Settings Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Camera',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  ListTile(
                    leading: const Icon(Icons.camera_alt, color: Colors.green),
                    title: const Text('Camera Quality'),
                    subtitle: const Text('High'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to camera quality settings
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.flash_on, color: Colors.green),
                    title: const Text('Flash Settings'),
                    subtitle: const Text('Auto'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to flash settings
                    },
                  ),

                  const Divider(),

                  // About Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'About',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: Colors.green,
                    ),
                    title: const Text('App Version'),
                    subtitle: const Text('1.0.0'),
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.privacy_tip_outlined,
                      color: Colors.green,
                    ),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to privacy policy
                    },
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.description_outlined,
                      color: Colors.green,
                    ),
                    title: const Text('Terms of Service'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to terms of service
                    },
                  ),

                  const SizedBox(height: 32),
                ],
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
