// NCRRA Trusted Member Utility: warm ivory, deep navy, quiet teal and restrained amber states.
import 'package:flutter/material.dart';

abstract final class NcrraColors {
  static const ivory = Color(0xFFF8F7F3);
  static const navy = Color(0xFF0B1E3B);
  static const teal = Color(0xFF2C7D78); // restrained NCRRA mark/detail accent
  static const actionNavy = Color(0xFF0B1E3B); // primary banking-style action
  static const dustyBlue = Color(0xFF315A86); // selected/secondary emphasis
  static const warmSand = Color(0xFFF1E7D2); // account and billing surfaces
  static const white = Color(0xFFFFFFFF);
  static const secondaryText = Color(0xFF5B6473);
  static const mutedText = Color(0xFF65707B);
  static const border = Color(0xFFDEE4E8);
  static const mintSurface = Color(0xFFF3F5F7);
  static const mintBadge = Color(0xFFE7EEF5);
  static const mintOrb = Color(0xFFEFF3F7);
  static const amberSurface = Color(0xFFF6E8D5);
  static const amberText = Color(0xFF8E4D1F);
  static const coral = Color(0xFFBA4C45);
  static const slateSurface = Color(0xFFEFF1F4);
}

abstract final class NcrraSpacing {
  static const gutter = 20.0;
  static const control = 12.0;
  static const section = 24.0;
  static const card = 16.0;
}

abstract final class NcrraRadius {
  static const control = Radius.circular(12);
  static const card = Radius.circular(16);
  static const pill = Radius.circular(999);
}

ThemeData ncrraTheme() {
  const textTheme = TextTheme(
    displaySmall: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 34, height: 1.06, fontWeight: FontWeight.w800, letterSpacing: -2.2, color: NcrraColors.navy),
    headlineSmall: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 27, height: 1.08, fontWeight: FontWeight.w800, letterSpacing: -1.5, color: NcrraColors.navy),
    titleLarge: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 25, height: 1.15, fontWeight: FontWeight.w800, letterSpacing: -1.35, color: NcrraColors.navy),
    titleMedium: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 21, height: 1.15, fontWeight: FontWeight.w800, letterSpacing: -1.05, color: NcrraColors.navy),
    titleSmall: TextStyle(fontFamily: 'Manrope', fontSize: 15, height: 1.25, fontWeight: FontWeight.w800, color: NcrraColors.navy),
    bodyLarge: TextStyle(fontFamily: 'Manrope', fontSize: 15, height: 1.6, fontWeight: FontWeight.w400, color: NcrraColors.secondaryText),
    bodyMedium: TextStyle(fontFamily: 'Manrope', fontSize: 14, height: 1.45, fontWeight: FontWeight.w400, color: NcrraColors.secondaryText),
    bodySmall: TextStyle(fontFamily: 'Manrope', fontSize: 12, height: 1.5, fontWeight: FontWeight.w400, color: NcrraColors.secondaryText),
    labelLarge: TextStyle(fontFamily: 'Manrope', fontSize: 14, height: 1.2, fontWeight: FontWeight.w800, color: NcrraColors.navy),
    labelMedium: TextStyle(fontFamily: 'Manrope', fontSize: 12, height: 1.2, fontWeight: FontWeight.w800, color: NcrraColors.navy),
    labelSmall: TextStyle(fontFamily: 'Manrope', fontSize: 11, height: 1.2, fontWeight: FontWeight.w800, color: NcrraColors.mutedText),
  );

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: NcrraColors.ivory,
    colorScheme: const ColorScheme.light(primary: NcrraColors.actionNavy, onPrimary: NcrraColors.white, surface: NcrraColors.white, onSurface: NcrraColors.navy, secondary: NcrraColors.dustyBlue),
    textTheme: textTheme,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: NcrraColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: const BorderRadius.all(NcrraRadius.control), borderSide: const BorderSide(color: NcrraColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(NcrraRadius.control), borderSide: const BorderSide(color: NcrraColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(NcrraRadius.control), borderSide: const BorderSide(color: NcrraColors.teal, width: 1.5)),
      labelStyle: textTheme.labelLarge,
    ),
  );
}
