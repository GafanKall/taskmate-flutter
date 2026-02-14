import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/board_screen.dart';
import 'screens/board_detail_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/notes_screen.dart';
import 'theme.dart';

// Simple global theme controller for the demo
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          initialRoute: '/',
          routes: {
            '/': (context) => const OnboardingScreen(),
            '/dashboard': (context) => const DashboardScreen(),
            '/board': (context) => const BoardScreen(),
            '/board-detail': (context) => const BoardDetailScreen(),
            '/schedule': (context) => const ScheduleScreen(),
            '/notes': (context) => const NotesScreen(),
          },
        );
      },
    );
  }
}
