import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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
                            painter: CornerBracketsPainter(),
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _NavBarItem(
                            icon: Icons.home,
                            label: 'Home',
                            isSelected: _selectedNavIndex == 0,
                            onTap: () => setState(() => _selectedNavIndex = 0),
                          ),
                          _NavBarItem(
                            icon: Icons.history,
                            label: 'History',
                            isSelected: _selectedNavIndex == 1,
                            onTap: () => setState(() => _selectedNavIndex = 1),
                          ),
                          _NavBarItem(
                            icon: Icons.person,
                            label: 'Profile',
                            isSelected: _selectedNavIndex == 2,
                            onTap: () => setState(() => _selectedNavIndex = 2),
                          ),
                        ],
                      ),
                    ),
                  ),
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
        color: Colors.black.withOpacity(0.6),
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
        color: Colors.black.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.settings, color: Colors.white, size: 20),
        onPressed: () {},
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
                color: Colors.green.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.camera_alt, size: 32),
            color: Colors.white,
            onPressed: () {},
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

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.green : Colors.grey, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.green : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for corner brackets
class CornerBracketsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    const bracketLength = 30.0;
    const padding = 10.0;

    // Top-left corner
    canvas.drawLine(
      const Offset(padding, padding + bracketLength),
      const Offset(padding, padding),
      paint,
    );
    canvas.drawLine(
      const Offset(padding, padding),
      const Offset(padding + bracketLength, padding),
      paint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(size.width - padding - bracketLength, padding),
      Offset(size.width - padding, padding),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - padding, padding),
      Offset(size.width - padding, padding + bracketLength),
      paint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(padding, size.height - padding - bracketLength),
      Offset(padding, size.height - padding),
      paint,
    );
    canvas.drawLine(
      Offset(padding, size.height - padding),
      Offset(padding + bracketLength, size.height - padding),
      paint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(size.width - padding - bracketLength, size.height - padding),
      Offset(size.width - padding, size.height - padding),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - padding, size.height - padding),
      Offset(size.width - padding, size.height - padding - bracketLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
