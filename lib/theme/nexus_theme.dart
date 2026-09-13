import 'package:flutter/material.dart';

class NexusTheme {
  // Base Backgrounds - Warm Cream & Luxury Cocoa
  static const Color bgBase = Color(0xFFFAF6F0);
  static const Color bgSurface = Color(0xFFFFFFFF);
  static const Color bgSurfaceElevated = Color(0xFFF4EDE4);
  
  // Brand Dark Cocoa & Chocolate Surface
  static const Color bgCocoaDark = Color(0xFF3D2314);
  static const Color bgCocoaDeeper = Color(0xFF2A170D);
  static const Color surfaceDark = Color(0xFF2A170D);
  
  // Glassmorphism & Cards
  static const Color cardGlass = Color(0x1F3D2314);
  static const Color cardBorder = Color(0x2B3D2314);
  static const Color cardGlassDark = Color(0x3DFFFFFF);
  
  // Rose & Pink Palette (Primary Brand Accents)
  static const Color rosePrimary = Color(0xFFE05297);
  static const Color roseLight = Color(0xFFF472B6);
  static const Color roseDark = Color(0xFFD84384);
  
  // Artisan Amber & Gold Palettes (Warm Bakery)
  static const Color primaryGold = Color(0xFFFBBF24);
  static const Color primaryGoldHover = Color(0xFFF59E0B);
  static const Color amberDark = Color(0xFFD97706);
  
  // Precision Tech Accents
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentRed = Color(0xFFEF4444);
  
  // Typography Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFF4EDE4);
  static const Color textMuted = Color(0xFF9E8C80);

  // Gradients
  static const LinearGradient roseGradient = LinearGradient(
    colors: [Color(0xFFF472B6), Color(0xFFE05297)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFCD34D), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cocoaGradient = LinearGradient(
    colors: [Color(0xFF3D2314), Color(0xFF2A170D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cyberGradient = LinearGradient(
    colors: [Color(0xFF22D3EE), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF3D2314), Color(0xFF1E120A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: bgCocoaDeeper,
      primaryColor: rosePrimary,
      colorScheme: const ColorScheme.dark(
        primary: rosePrimary,
        secondary: primaryGold,
        surface: bgCocoaDark,
        background: bgCocoaDeeper,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgCocoaDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgCocoaDark,
        selectedItemColor: roseLight,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: rosePrimary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
