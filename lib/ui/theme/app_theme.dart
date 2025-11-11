import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _spaceDarkBlue = Color(0xFF0A0E27);
  static const Color _spaceBlue = Color(0xFF1A1F3A);
  static const Color _spaceCyan = Color(0xFF00D4FF);
  static const Color _spaceIndigo = Color(0xFF6B46C1);
  static const Color _spacePurple = Color(0xFF8B5CF6);

  static ColorScheme get _colorScheme => ColorScheme(
        brightness: Brightness.dark,
        primary: _spaceCyan,
        onPrimary: _spaceDarkBlue,
        primaryContainer: _spaceCyan.withValues(alpha: 0.2),
        onPrimaryContainer: _spaceCyan,
        
        secondary: _spaceIndigo,
        onSecondary: Colors.white,
        secondaryContainer: _spaceIndigo.withValues(alpha: 0.2),
        onSecondaryContainer: _spaceIndigo,
        
        tertiary: _spacePurple,
        onTertiary: Colors.white,
        tertiaryContainer: _spacePurple.withValues(alpha: 0.2),
        onTertiaryContainer: _spacePurple,
        
        surface: _spaceBlue,
        onSurface: Colors.white,
        surfaceContainerHighest: _spaceBlue.withValues(alpha: 0.6),
        surfaceContainerHigh: _spaceBlue.withValues(alpha: 0.4),
        surfaceContainer: _spaceBlue.withValues(alpha: 0.3),
        surfaceContainerLow: _spaceBlue.withValues(alpha: 0.2),
        surfaceContainerLowest: _spaceBlue.withValues(alpha: 0.1),
        
        error: const Color(0xFFCF6679),
        onError: Colors.white,
        errorContainer: const Color(0xFFCF6679).withValues(alpha: 0.2),
        onErrorContainer: const Color(0xFFCF6679),
        
        outline: _spaceCyan.withValues(alpha: 0.5),
        outlineVariant: _spaceCyan.withValues(alpha: 0.3),
        
        shadow: Colors.black,
        scrim: Colors.black,
        
        inverseSurface: Colors.white,
        onInverseSurface: _spaceDarkBlue,
        inversePrimary: _spaceDarkBlue,
      );

  static ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: _colorScheme,
        
        textTheme: GoogleFonts.onestTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        
        appBarTheme: AppBarTheme(
          backgroundColor: _spaceBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.onest(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        
        cardTheme: CardThemeData(
          color: _spaceBlue,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: _spaceCyan,
            foregroundColor: _spaceDarkBlue,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.onest(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: _spaceCyan,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: GoogleFonts.onest(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        chipTheme: ChipThemeData(
          backgroundColor: _spaceBlue.withValues(alpha: 0.5),
          labelStyle: GoogleFonts.onest(
            color: Colors.white,
            fontSize: 14,
          ),
          secondaryLabelStyle: GoogleFonts.onest(
            color: Colors.white,
            fontSize: 14,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return _spaceCyan;
              }
              return _spaceBlue.withValues(alpha: 0.5);
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return _spaceDarkBlue;
              }
              return Colors.white;
            }),
            side: WidgetStateProperty.all(
              BorderSide(color: _spaceCyan.withValues(alpha: 0.3)),
            ),
          ),
        ),
        
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: _spaceCyan,
          linearTrackColor: _spaceCyan.withValues(alpha: 0.2),
          circularTrackColor: _spaceCyan.withValues(alpha: 0.2),
        ),
        
        dividerTheme: DividerThemeData(
          color: _spaceCyan.withValues(alpha: 0.2),
          thickness: 1,
          space: 1,
        ),
        
        scaffoldBackgroundColor: _spaceDarkBlue,
        
        snackBarTheme: SnackBarThemeData(
          backgroundColor: _spaceBlue,
          contentTextStyle: GoogleFonts.onest(
            color: Colors.white,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: _spaceBlue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),
      );
}

