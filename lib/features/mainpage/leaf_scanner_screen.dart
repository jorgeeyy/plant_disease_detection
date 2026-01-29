import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'settings_screen.dart';

class LeafScannerScreen extends StatefulWidget {
  const LeafScannerScreen({super.key});

  @override
  State<LeafScannerScreen> createState() => _LeafScannerScreenState();
}

class _LeafScannerScreenState extends State<LeafScannerScreen> {
  late CameraController _controller;
  late Future<void> _initializeCamera;
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera = _setupCamera();
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
          future: _initializeCamera,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                /// CAMERA PREVIEW SECTION
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      /// CAMERA FEED
                      CameraPreview(_controller),

                      /// TOP OVERLAY (Offline + Settings)
                      Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [_OfflineBadge(), _SettingsButton()],
                        ),
                      ),

                      /// CORNER BRACKETS
                      Center(
                        child: SizedBox(
                          width: 280,
                          height: 420,
                          child: CustomPaint(
                            size: const Size(280, 420),
                            // painter: CornerBracketsPainter(),
                          ),
                        ),
                      ),

                      /// HELPER TEXT
                      const Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Text(
                          "Align leaf within the frame",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// CAMERA CONTROLS PANEL (WHITE BACKGROUND)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: _BottomControls(),
                ),

                /// BOTTOM NAVIGATION BAR
                BottomNavBar(
                  selectedIndex: _selectedNavIndex,
                  onItemTapped: (index) {
                    if (index == _selectedNavIndex) return;

                    setState(() => _selectedNavIndex = index);

                    // Navigate to the appropriate screen
                    if (index == 1) {
                      // Navigate to History
                      Navigator.pushReplacementNamed(context, '/history');
                    } else if (index == 2) {
                      // Navigate to Settings
                      Navigator.pushReplacementNamed(context, '/settings');
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OfflineBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off, size: 14, color: Colors.white),
          SizedBox(width: 6),
          Text(
            "Offline Mode",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.settings, color: Colors.white, size: 20),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        },
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Control(Icons.photo, "GALLERY"),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.camera_alt, size: 32),
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/diagnosis');
            },
          ),
        ),
        _Control(Icons.flash_off, "FLASH OFF"),
      ],
    );
  }
}

class _Control extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Control(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.grey[700], size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
