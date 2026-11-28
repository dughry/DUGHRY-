part of dughry;

class DughryColors {
  static const Color royalNavyDeep = Color(0xFF07142B);
  static const Color royalNavyMid = Color(0xFF0D254C);
  static const Color royalNavyCard = Color(0xFF122E5C);
  static const Color royalNavySurface = Color(0xFF17386E);

  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF3D778);
  static const Color goldDark = Color(0xFF9E7B1B);

  static const Color silverPrimary = Color(0xFFD0D7E2);
  static const Color silverBright = Color(0xFFF4F7FB);
  static const Color silverMuted = Color(0xFF8C9BB0);

  static const Color crimsonRed = Color(0xFFE11D48);
  static const Color crimsonDark = Color(0xFF9F1239);

  static const Color textLight = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color borderSubtle = Color(0x26D4AF37);
  static const Color successGreen = Color(0xFF10B981);

  static const LinearGradient royalBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      royalNavyMid,
      royalNavyDeep,
      Color(0xFF050E1E),
    ],
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      goldLight,
      goldPrimary,
      goldDark,
    ],
  );
}
