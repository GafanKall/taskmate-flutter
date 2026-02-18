import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/board_provider.dart';
import 'providers/task_provider.dart';
import 'providers/note_provider.dart';
import 'providers/event_provider.dart';
import 'providers/weekly_schedule_provider.dart';
import 'providers/notification_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/board_screen.dart';
import 'screens/board_detail_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'theme.dart';

// Simple global theme controller for the demo
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..checkAuthStatus(),
        ),
        ChangeNotifierProvider(create: (_) => BoardProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => WeeklyScheduleProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: currentMode,
              initialRoute: auth.isAuthenticated ? '/dashboard' : '/',
              routes: {
                '/': (context) => const OnboardingScreen(),
                '/sign-in': (context) => const SignInScreen(),
                '/sign-up': (context) => const SignUpScreen(),
                '/dashboard': (context) => const DashboardScreen(),
                '/board': (context) => const BoardScreen(),
                '/board-detail': (context) => const BoardDetailScreen(),
                '/schedule': (context) => const ScheduleScreen(),
                '/notes': (context) => const NotesScreen(),
              },
            );
          },
        );
      },
    );
  }
}
