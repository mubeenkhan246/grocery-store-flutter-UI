import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const green = Color(0xFF16A34A);
  static const mint = Color(0xFF8EF0B1);
  static const citrus = Color(0xFFFFD166);
  static const tomato = Color(0xFFFF6B6B);
  static const ink = Color(0xFF102118);

  static ThemeData get light => _theme(Brightness.light);
  static ThemeData get dark => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: green,
      brightness: brightness,
      primary: green,
      secondary: citrus,
      surface: isDark ? const Color(0xFF07110C) : const Color(0xFFF8FBF8),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: 'SF Pro Display',
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      textTheme: TextTheme(
        displaySmall: TextStyle(fontWeight: FontWeight.w800, color: isDark ? Colors.white : ink, height: 1.02),
        headlineMedium: TextStyle(fontWeight: FontWeight.w800, color: isDark ? Colors.white : ink),
        titleLarge: TextStyle(fontWeight: FontWeight.w800, color: isDark ? Colors.white : ink),
        titleMedium: TextStyle(fontWeight: FontWeight.w700, color: isDark ? Colors.white : ink),
        bodyLarge: TextStyle(color: isDark ? Colors.white.withValues(alpha: .78) : ink.withValues(alpha: .78)),
        bodyMedium: TextStyle(color: isDark ? Colors.white.withValues(alpha: .64) : ink.withValues(alpha: .62)),
      ),
    );
  }
}
