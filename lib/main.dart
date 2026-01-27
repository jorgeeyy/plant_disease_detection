import 'package:flutter/material.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/mainpage/leaf_scanner_screen.dart';
import 'features/history/history_screen.dart';
import 'features/mainpage/settings_screen.dart';
import 'features/diagnosis/diagnosis_result_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const OnbardingScreen(),
        '/home': (context) => const LeafScannerScreen(),
        '/history': (context) => const HistoryScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/diagnosis': (context) => const DiagnosisResultScreen(),
      },
    );
  }
}
