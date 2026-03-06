import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AppColorsLight {
  // ===== Gradients =====
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF252A3A), Color(0xFF344B93), Color(0xFF0E8FC6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );
  static const LinearGradient primaryGradient2 = LinearGradient(
    colors: [Color(0xFF252A3A), Color(0xFF344B93), Color(0xFF0E8FC6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.5, 1.0],
  );
  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFBEBEBE)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color primary = Color(0xFF2E569B);
  static const Color secondary = Color(0xFFBEBEBE);

  static const Color accent = Color(0xFF4EB3E2);

  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF0F6488);

  static const Color background = Color(0xFFFFFFFF);
}
