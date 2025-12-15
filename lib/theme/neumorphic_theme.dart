import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

class NeumorphicAppTheme {
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFE0E5EC);
  static const Color lightBase = Color(0xFFE0E5EC);
  static const Color lightAccent = Color(0xFF6366F1);
  static const Color lightTextPrimary = Color(0xFF1F2937);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF2C3E50);
  static const Color darkBase = Color(0xFF2C3E50);
  static const Color darkAccent = Color(0xFF818CF8);
  static const Color darkTextPrimary = Color(0xFFE5E7EB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  // Light Theme
  static NeumorphicThemeData lightTheme = NeumorphicThemeData(
    baseColor: lightBase,
    accentColor: lightAccent,
    lightSource: LightSource.topLeft,
    depth: 8,
    intensity: 0.65,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: lightTextPrimary,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: lightTextPrimary,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: lightTextPrimary,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: lightTextPrimary,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: lightTextPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: lightTextPrimary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: lightTextPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: lightTextSecondary,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: lightTextPrimary,
      ),
    ),
  );

  // Dark Theme
  static NeumorphicThemeData darkTheme = NeumorphicThemeData(
    baseColor: darkBase,
    accentColor: darkAccent,
    lightSource: LightSource.topLeft,
    shadowDarkColor: Color(0xFF6366F1),
    // shadowDarkColorEmboss: Colors.red,
    shadowLightColor: Colors.transparent,
    depth: 2,
    intensity: 0.05,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: darkTextPrimary,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: darkTextPrimary,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: darkTextPrimary,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkTextPrimary,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: darkTextPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: darkTextPrimary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: darkTextPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: darkTextSecondary,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkTextPrimary,
      ),
    ),
  );

  // Helper method to get text color based on theme
  static Color getTextColor(BuildContext context) {
    return NeumorphicTheme.isUsingDark(context)
        ? darkTextPrimary
        : lightTextPrimary;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return NeumorphicTheme.isUsingDark(context)
        ? darkTextSecondary
        : lightTextSecondary;
  }
}
