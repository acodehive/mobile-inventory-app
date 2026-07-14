/// Spacing, radius, and elevation constants — no magic numbers in the UI layer.
class AppDimens {
  AppDimens._();

  // Spacing scale (4pt grid)
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Radius
  static const double radiusSm = 10;
  static const double radiusMd = 16;
  static const double radiusLg = 24;
  static const double radiusXl = 32;
  static const double radiusPill = 999;

  // Elevation / blur
  static const double cardBlur = 20;
  static const double cardElevation = 8;

  // Component sizes
  static const double buttonHeight = 56;
  static const double inputHeight = 56;
  static const double appBarHeight = 64;
  static const double bottomNavHeight = 72;
  static const double statCardHeight = 120;
  static const double productThumbSize = 56;
  static const double avatarSize = 44;

  // Grid
  static const int dashboardGridColumns = 2;
  static const double gridSpacing = 14;

  // Animation durations (ms)
  static const int animFast = 180;
  static const int animMedium = 320;
  static const int animSlow = 520;
}
