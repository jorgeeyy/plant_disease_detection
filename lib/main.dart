import 'package:flutter/material.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/mainpage/leaf_scanner_screen.dart';
import 'features/mainpage/history_screen.dart';
import 'features/mainpage/settings_screen.dart';
import 'features/mainpage/diagnosis_result_screen.dart';

import 'package:provider/provider.dart';
import 'theme_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant Disease Detection',
      themeMode: themeManager.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
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
