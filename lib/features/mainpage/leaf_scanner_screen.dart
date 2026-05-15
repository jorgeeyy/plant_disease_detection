import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'settings_screen.dart';
import '../../services/classifier.dart';
import '../../models/diagnosis_result.dart';
import 'diagnosis_result_screen.dart';

class LeafScannerScreen extends StatefulWidget {
  const LeafScannerScreen({super.key});

  @override
  State<LeafScannerScreen> createState() => _LeafScannerScreenState();
}

class _LeafScannerScreenState extends State<LeafScannerScreen> {
  late CameraController _controller;
  late Future<void> _initializeCamera;
  final Classifier _classifier = Classifier();
  final ImagePicker _picker = ImagePicker();
  int _selectedNavIndex = 0;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera = _setupCamera();
    _classifier.loadModel();
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
    _classifier.dispose();
    super.dispose();
  }

  Future<void> _captureAndAnalyze() async {
    if (_isAnalyzing) return;

    try {
      setState(() => _isAnalyzing = true);

      final XFile image = await _controller.takePicture();
      await _analyzeImage(image);
    } catch (e) {
      print('Error during capture: $e');
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  Future<void> _pickFromGallery() async {
    if (_isAnalyzing) return;

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() => _isAnalyzing = true);
      await _analyzeImage(image);
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  Future<void> _analyzeImage(XFile image) async {
    final result = await _classifier.classify(File(image.path));

    if (mounted) {
      final diagnosis = DiagnosisResult(
        diseaseName: result['label'],
        confidence: result['confidence'],
        imagePath: image.path,
        dateTime: DateTime.now(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiagnosisResultScreen(result: diagnosis),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SafeArea(
          child: FutureBuilder(
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

                        /// ANALYZING OVERLAY
                        if (_isAnalyzing)
                          Container(
                            color: Colors.black54,
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(color: Colors.green),
                                  SizedBox(height: 16),
                                  Text(
                                    "Analyzing leaf...",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  /// CAMERA CONTROLS PANEL
                  Container(
                    color: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: _BottomControls(
                      onCapture: _captureAndAnalyze,
                      onGalleryTap: _pickFromGallery,
                      isAnalyzing: _isAnalyzing,
                    ),
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
  final VoidCallback onCapture;
  final VoidCallback onGalleryTap;
  final bool isAnalyzing;

  const _BottomControls({
    required this.onCapture,
    required this.onGalleryTap,
    required this.isAnalyzing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Control(Icons.photo, "GALLERY", onTap: onGalleryTap),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: isAnalyzing ? Colors.grey : Colors.green,
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
            onPressed: isAnalyzing ? null : onCapture,
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
  final VoidCallback? onTap;

  const _Control(this.icon, this.label, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
