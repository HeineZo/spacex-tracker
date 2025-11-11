import 'package:flutter/material.dart';
import '../../data/models/launch.dart';
import '../screens/launch_details_screen.dart';

/// Naviguer vers l'écran de détails d'un lancement
void navigateToLaunchDetails(BuildContext context, Launch launch) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => LaunchDetailsScreen(launch: launch),
    ),
  );
}

