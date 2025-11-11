import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'data/providers/favorites_provider.dart';
import 'data/services/onboarding_service.dart';
import 'ui/screens/launches_screen.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF0A0E27), 
      systemNavigationBarIconBrightness: Brightness.light, 
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, 
    ),
  );
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        home: const _InitialScreen(),
      ),
    );
  }
}

class _InitialScreen extends StatelessWidget {
  const _InitialScreen();

  @override
  Widget build(BuildContext context) {
    final onboardingService = OnboardingService.instance;
    return FutureBuilder<bool>(
      future: onboardingService.hasCompletedOnboarding(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final hasCompleted = snapshot.data ?? false;
        return hasCompleted ? const LaunchesScreen() : const OnboardingScreen();
      },
    );
  }
}
