import 'package:flutter/material.dart';

// Custom Color Palette
const primaryColor = Color(
  0xFFAF8F6F,
); // Muted Brown – primary (buttons, highlights)
const secondaryColor = Color(
  0xFF74512D,
); // Deep Brown – secondary (CTA, accents)
const accentColor = Color(0xFF74512D); // Use same as secondary for simplicity
const successColor = Color(0xFF4CAF50); // Optional (green)
const warningColor = Color(0xFFFFC107); // Optional (amber)
const errorColor = Color(0xFFE53935); // Optional (red)
const backgroundColor = Color(0xFFF8F4E1); // Light Beige – background
const textColor = Color(0xFF543310); // Dark Brown – primary text
const textColorSecondary = Color(0xFF7C6C5B); // Muted brownish-gray for hints
const textFieldColor = Color(0xFFFFFBF5); // Very light beige for input fields

ThemeData lightTheme = ThemeData(
  fontFamily: "Sora",
  brightness: Brightness.light,
  useMaterial3: true,

  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: secondaryColor,
    onSecondary: Colors.white,
    error: errorColor,
    onError: Colors.white,
    surface: backgroundColor,
    onSurface: textColor,
    tertiary: accentColor,
  ),

  scaffoldBackgroundColor: backgroundColor,

  appBarTheme: const AppBarTheme(
    color: Colors.white,
    centerTitle: true,
    elevation: 0,
    iconTheme: IconThemeData(color: textColor),
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      color: textColor,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  iconTheme: const IconThemeData(color: textColor),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedIconTheme: IconThemeData(color: primaryColor),
    unselectedIconTheme: IconThemeData(color: textColorSecondary),
    selectedItemColor: primaryColor,
    unselectedItemColor: textColorSecondary,
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: textFieldColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: textColorSecondary),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      side: const BorderSide(color: primaryColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),

  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    fillColor: WidgetStateProperty.all(primaryColor),
  ),

  cardTheme: const CardTheme(
    color: Color(0xFFF8F4E1),
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  ),

  dialogTheme: const DialogTheme(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  ),

  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
  ),
);
