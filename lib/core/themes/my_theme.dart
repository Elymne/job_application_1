import 'package:flutter/material.dart';

final _colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 2, 20, 49),
  surface: Colors.white,
  primary: const Color.fromARGB(255, 2, 25, 61),
  onSurface: const Color.fromARGB(255, 158, 158, 158),
  brightness: Brightness.light,
);

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _colorScheme,

  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
      color: _colorScheme.primary,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
      color: _colorScheme.onSurface,
    ),

    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _colorScheme.primary),

    bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color.fromARGB(255, 29, 29, 29)),
    bodyMedium: TextStyle(fontSize: 14, color: _colorScheme.onSurface),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _colorScheme.primary,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    ),
  ),

  // ---- CHAMPS DE TEXTE ----
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade100,
    hintStyle: TextStyle(fontSize: 14, color: _colorScheme.onSurface),

    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),

    suffixIconColor: _colorScheme.onSurface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),

  // ---- AUTRES ----
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    iconTheme: IconThemeData(color: Colors.black87),
  ),
);
