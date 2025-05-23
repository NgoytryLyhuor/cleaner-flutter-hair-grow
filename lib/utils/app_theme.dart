import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF000000);
  static const Color accentColor = Color(0xFFF3F3F3);
  static const Color textColor = Color(0xFF000000);
  static const Color textLightColor = Color(0xFF999999);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFE53935);
  
  // Text Styles
  static TextStyle get extraLightStyle => const TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w200,
    color: textColor,
  );
  
  static TextStyle get lightStyle => const TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w300,
    color: textColor,
  );
  
  static TextStyle get regularStyle => const TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w400,
    color: textColor,
  );
  
  static TextStyle get mediumStyle => const TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w500,
    color: textColor,
  );
  
  static TextStyle get semiBoldStyle => const TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w600,
    color: textColor,
  );
  
  static TextStyle get boldStyle => const TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w700,
    color: textColor,
  );
  
  static TextStyle get extraBoldStyle => const TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w800,
    color: textColor,
  );
  
  static TextStyle get blackStyle => const TextStyle(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w900,
    color: textColor,
  );
  
  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: textColor,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: blackStyle.copyWith(fontSize: 26),
        displayMedium: extraBoldStyle.copyWith(fontSize: 24),
        displaySmall: boldStyle.copyWith(fontSize: 22),
        headlineMedium: semiBoldStyle.copyWith(fontSize: 20),
        headlineSmall: mediumStyle.copyWith(fontSize: 18),
        titleLarge: regularStyle.copyWith(fontSize: 16),
        titleMedium: regularStyle.copyWith(fontSize: 14),
        bodyLarge: regularStyle.copyWith(fontSize: 16),
        bodyMedium: regularStyle.copyWith(fontSize: 14),
        bodySmall: lightStyle.copyWith(fontSize: 12),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        buttonColor: primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryColor,
    );
  }
}
