import 'package:flutter/material.dart';

const colorPrimario = Color(0xFF1FA2FF);
const colorOscuro = Color(0xFF0B2A4A);
const colorAzul = Color(0xFF2A6FB3);
const colorVerde = Color(0xFF28A745);

ThemeData webBusTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: colorPrimario),
    scaffoldBackgroundColor: const Color(0xFFEAF2FA),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorVerde,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}
