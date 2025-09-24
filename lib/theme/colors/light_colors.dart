import 'package:flutter/material.dart';

class LightColors {
  static const Color kLightYellow = Color(0xFFFFF9EC);
  static const Color kLightYellow2 = Color(0xFFFFE4C7);
  static const Color kDarkYellow = Color(0xFFF9BE7C);
  static const Color kPalePink = Color(0xFFFED4D6);
  static const Color kLightBlue = Color(0xFF00D2F0);

  static const Color kRed = Color(0xFFE46472);
  static const Color kLavender = Color(0xFFD5E4FE);
  static const Color kBlue = Color(0xFF6488E4);
  static const Color kLightGreen = Color(0xFFD9E6DC);
  static const Color kGreen = Color(0xFF309397);

  static const Color kDarkBlue = Color(0xFF0D253F);
  static const LinearGradient kRedlyGradiant = LinearGradient(colors: [
    Color(0xFFF73B0F),
    Color(0xFFF07D42),
  ]);

  static const Color yellow = Color(0xFFFFE324);
  static const Color darkYellow = Color(0xFFFFB533);
  static const LinearGradient yellowGradient = LinearGradient(
    colors: [yellow, darkYellow],
  );

  static const LinearGradient kDeepRedlyGradiant = LinearGradient(colors: [
    Color(0xFFFF8F01),
    Color(0xFFFF0000),
  ]);

  static const Color flesh = Color(0xFFFED3A0);
  static const Color yellowOrange = Color(0xFFFFA63F);
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [flesh, yellowOrange],
  );
  static const Color lightOrange = Color(0xFFFFCB52);
  static const Color orange = Color(0xFFFF7B02);
  static const LinearGradient darkOrangeGradient = LinearGradient(
    colors: [orange, lightOrange],
  );
  static const Color lightBrown = Color(0xFFFEB395);
  static const Color brown = Color(0xFFF17E50);
  static const LinearGradient brownGradient = LinearGradient(
    colors: [lightOrange, brown],
  );

  static const Color lightTosca = Color(0xFF95D1FE);
  static const Color tosca = Color(0xFF509EF1);
  static const LinearGradient toscaGradient = LinearGradient(
    colors: [lightTosca, tosca],
  );

  static const Color lightDonker = Color(0xFF9C95FE);
  static const Color donker = Color(0xFF6850F1);
  static const LinearGradient donkerGradient = LinearGradient(
    colors: [lightDonker, donker],
  );

  // Enhanced App Theme Gradients
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryBlueDark = Color(0xFF1D4ED8);
  static const Color secondaryIndigo = Color(0xFF6366F1);
  static const Color secondaryIndigoDark = Color(0xFF4338CA);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryBlueDark, secondaryIndigo],
  );

  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
  );

  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF86EFAC), Color(0xFF22C55E)],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC084FC), Color(0xFF9333EA)],
  );

  static const LinearGradient pinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF9A8D4), Color(0xFFEC4899)],
  );

  static const LinearGradient tealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5EEAD4), Color(0xFF14B8A6)],
  );

  static const LinearGradient indigoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFA5B4FC), Color(0xFF6366F1)],
  );

  static const LinearGradient redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFCA5A5), Color(0xFFEF4444)],
  );

  // Card gradients for note cards
  static const List<LinearGradient> cardGradients = [
    blueGradient,
    greenGradient,
    purpleGradient,
    pinkGradient,
    orangeGradient,
    tealGradient,
    indigoGradient,
    redGradient,
  ];

  // Accent colors for borders and icons
  static const List<Color> cardAccentColors = [
    Color(0xFF3B82F6), // Blue
    Color(0xFF22C55E), // Green
    Color(0xFF9333EA), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFFF97316), // Orange
    Color(0xFF14B8A6), // Teal
    Color(0xFF6366F1), // Indigo
    Color(0xFFEF4444), // Red
  ];

  // Background colors
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textHint = Color(0xFF94A3B8);

  // Helper methods
  static LinearGradient getCardGradient(int index) {
    return cardGradients[index % cardGradients.length];
  }

  static Color getCardAccentColor(int index) {
    return cardAccentColors[index % cardAccentColors.length];
  }
}
