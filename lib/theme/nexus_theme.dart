import 'package:flutter/material.dart';

class NexusTheme {
  // Base Backgrounds - Warm Cream & Luxury Cocoa (Matching index.css)
  static const Color bgBase = Color(0xFFFAF6F0);
  static const Color bgSurface = Color(0xFFFFFFFF);
  static const Color bgSurfaceElevated = Color(0xFFF4EDE4);
  static const Color bgSurfaceTranslucent = Color(0xD9FFFFFF);
  
  // Brand Dark Cocoa & Chocolate Surface
  static const Color bgCocoaDark = Color(0xFF3D2314);
  static const Color bgCocoaDeeper = Color(0xFF2A170D);
  static const Color surfaceDark = Color(0xFF2A170D);
  
  // Glassmorphism & Borders
  static const Color cardGlass = Color(0x1F3D2314);
  static const Color cardBorder = Color(0x1F3D2314);
  static const Color cardBorderLight = Color(0x143D2314);
  static const Color cardGlassDark = Color(0x3DFFFFFF);
  
  // Warm Rose & Pink Palette (Primary Brand Accents)
  static const Color rosePrimary = Color(0xFFE05297);
  static const Color roseLight = Color(0xFFF472B6);
  static const Color roseDark = Color(0xFFD84384);
  static const Color roseDeep = Color(0xFFC23B75);
  static const Color roseGlow = Color(0x40E05297);

  // Artisan Amber & Gold Palettes (Warm Bakery)
  static const Color primaryGold = Color(0xFFFBBF24);
  static const Color primaryGoldHover = Color(0xFFF59E0B);
  static const Color amberDark = Color(0xFFD97706);
  static const Color goldGlow = Color(0x40F59E0B);

  // Soft Red & Error Alert (Matching React AuthModal / UserProfileModal)
  static const Color alertRedBg = Color(0xFFFEF2F2);
  static const Color alertRedBorder = Color(0xFFFECACA);
  static const Color alertRedText = Color(0xFFDC2626);
  static const Color accentRed = Color(0xFFEF4444);

  // Precision Tech Accents
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentIndigo = Color(0xFF6366F1);
  static const Color accentGreen = Color(0xFF10B981);
  
  // Typography Colors (Matching index.css)
  static const Color textDarkPrimary = Color(0xFF3D2314);
  static const Color textDarkSecondary = Color(0xFF6E5849);
  static const Color textMuted = Color(0xFF9E8C80);
  static const Color textLightPrimary = Colors.white;
  static const Color textLightSecondary = Color(0xFFF4EDE4);

  // Backward compatibility alias
  static const Color textPrimary = textLightPrimary;
  static const Color textSecondary = textLightSecondary;

  // Gradients
  static const LinearGradient roseGradient = LinearGradient(
    colors: [Color(0xFFF472B6), Color(0xFFE05297)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashProgressGradient = LinearGradient(
    colors: [Color(0xFFE05297), Color(0xFF3D2314)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
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

  static InputDecoration authInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: textMuted, fontSize: 13),
      prefixIcon: Icon(prefixIcon, color: textMuted, size: 18),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: bgBase,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: rosePrimary, width: 1.5),
      ),
    );
  }

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
        titleTextStyle: TextStyle(color: textLightPrimary, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgCocoaDark,
        selectedItemColor: rosePrimary,
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
