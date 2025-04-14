import 'package:flutter/material.dart';

class AppColors {
  // static const Color primaryColor = Color(0xFF6055D8); // Example primary color
  // static const Color secondaryColor = Color(0xFFB39DDB);
  // static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Colors.black;
  static const Color buttonColor = Color(0xFF4CAF50);
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color blue = Color(0xff114BCA);
  static const Color primaryColor = Color(0xFFAEC6F9);
  static const Color secondaryColor = Colors.white;
  static const Color backgroundColor = Colors.white;
  static const Color purple = Color(0xff6055d8);
  static const Color black = Color(0xff6055d8);
  static const Color primaryColor2 = Color(0xFFF89E4A);
  static const Color secondaryColor2 = Colors.white;
    static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color((0xff6055d8)), Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const Color orage = Color(0xffF67C0A);
  static const LinearGradient appGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.center,
    colors: [
      primaryColor, // Top Color
      secondaryColor, // Bottom Color
    ],

  );
  static const LinearGradient appGradient2 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.center,
    colors: [
      primaryColor2, // Top Color
      secondaryColor2, // Bottom Color
    ],
    // stops: [0.1, 0.3],
  );
}
