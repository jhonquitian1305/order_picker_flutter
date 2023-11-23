import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Colors.white,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              Colors.black,
            ),
          ),
        ),
        textTheme: GoogleFonts.redHatDisplayTextTheme(),
        useMaterial3: true,
      );
}
