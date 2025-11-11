import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _key = 'has_completed_onboarding';
  static OnboardingService? _instance;
  SharedPreferences? _prefs;

  OnboardingService._();

  static OnboardingService get instance {
    _instance ??= OnboardingService._();
    return _instance!;
  }

  Future<SharedPreferences> get _prefsInstance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<bool> hasCompletedOnboarding() async {
    final prefs = await _prefsInstance;
    return prefs.getBool(_key) ?? false;
  }

  Future<void> completeOnboarding() async {
    final prefs = await _prefsInstance;
    await prefs.setBool(_key, true);
  }
}

