import 'package:flutter/material.dart';

final _colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 2, 20, 49),

  primary: const Color.fromARGB(255, 2, 25, 61),
  onPrimary: Colors.white,

  surface: const Color.fromARGB(255, 255, 255, 255),
  onSurface: const Color.fromARGB(255, 65, 65, 65),
  surfaceContainerLow: const Color.fromARGB(255, 248, 248, 248),
  onSurfaceVariant: const Color.fromARGB(255, 189, 189, 189),

  brightness: Brightness.light,
);

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _colorScheme,

  textTheme: TextTheme(
    // * Titre (Screen).
    displayMedium: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.6,
      color: _colorScheme.primary,
    ),
    // * Sous-titre (modules ou sous partie).
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.6,
      color: _colorScheme.primary,
    ),

    // * [Home] title.
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: _colorScheme.onSurfaceVariant),
    titleLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.normal, color: _colorScheme.primary),
    titleSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: _colorScheme.primary),

    // * [InteractiveElement/button]: all.
    labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _colorScheme.primary),

    // * [TextField][Link][Menu]: label + hint.
    labelMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: _colorScheme.primary),

    // * [Basic][Card] All data bloc text.
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: _colorScheme.onSurface),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: _colorScheme.onSurfaceVariant),

    // * [Modal] main text.
    headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _colorScheme.primary),
    // * [Modal] second text.
    headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.normal, color: _colorScheme.onSurfaceVariant),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _colorScheme.primary,
      foregroundColor: _colorScheme.onPrimary,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    ),
  ),

  // ---- CHAMPS DE TEXTE ----
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _colorScheme.surfaceContainerLow,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),

    hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: _colorScheme.onSurfaceVariant),
    iconColor: _colorScheme.onSurfaceVariant,

    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
);
