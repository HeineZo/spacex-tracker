import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'data/providers/favorites_provider.dart';
import 'data/services/onboarding_service.dart';
import 'ui/screens/launches_screen.dart';
import 'ui/screens/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');
  
  // Set system navigation bar color (bottom bar on Android/iOS)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // Transparent or set a specific color
      systemNavigationBarIconBrightness: Brightness.dark, // For dark icons (use Brightness.light for light icons)
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
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
          appBarTheme: const AppBarTheme(
            // Change this color to customize the AppBar background
            backgroundColor: Colors.indigo, // You can use any color here
            foregroundColor: Colors.white, // Text and icon color
            elevation: 0, // Remove shadow (set to 0 or any value)
            centerTitle: false,
          ),
        ),
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
