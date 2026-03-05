import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Blues
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color skyBlue = Color(0xFF90CAF9);
  static const Color paleSky = Color(0xFFBBDEFB);
  static const Color iceBlue = Color(0xFFE3F2FD);

  // Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8FAFE);
  static const Color lightGrey = Color(0xFFF1F5F9);
  static const Color midGrey = Color(0xFF94A3B8);
  static const Color darkGrey = Color(0xFF475569);
  static const Color charcoal = Color(0xFF1E293B);

  // Accent
  static const Color accentIndigo = Color(0xFF3949AB);
  static const Color successGreen = Color(0xFF10B981);
  static const Color errorRed = Color(0xFFEF4444);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, lightBlue],
    stops: [0.0, 1.0],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1565C0), Color(0xFF1E88E5), Color(0xFF42A5F5)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE3F2FD), Color(0xFFF8FAFE), white],
    stops: [0.0, 0.4, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [white, Color(0xFFF0F7FF)],
  );
}
