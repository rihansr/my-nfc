import 'package:flutter/material.dart';

class ColorPalette {
  Color primary;
  Color onPrimary;
  Color primaryLight;
  Color primaryDark;
  Color secondary;
  Color onSecondary;
  Color tertiary;
  Color onTertiary;
  Color scaffold;
  Color surface;
  Color onSurface;
  Color icon;
  Color text;
  Color headline;
  Color focus;
  Color divider;
  Color active;
  Color success;
  Color hint;
  Color disable;
  Color error;
  Color light;
  Color dark;

  ColorPalette({
    required this.primary,
    required this.onPrimary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.onTertiary,
    required this.scaffold,
    required this.surface,
    required this.onSurface,
    required this.icon,
    required this.text,
    required this.headline,
    required this.focus,
    required this.divider,
    required this.active,
    required this.success,
    required this.hint,
    required this.disable,
    required this.error,
    required this.light,
    required this.dark,
  });

  factory ColorPalette.dark() => ColorPalette(
        primary: const Color(0xFF074DFF),
        onPrimary: const Color(0xFF9207FF),
        primaryDark: const Color(0xFF074DFF),
        primaryLight: const Color(0xFF573CFE),
        secondary: const Color(0xFFE64DB8),
        onSecondary: const Color(0xFFCD07FF),
        tertiary: const Color(0xFFFFFFFF),
        onTertiary: const Color(0xFF09091a),
        scaffold: const Color(0xFF09091a),
        surface: const Color(0xFF09091a),
        onSurface: const Color(0xFF09091a),
        icon: const Color(0xFFFFFFFF),
        text: const Color(0xFFC1BFCE),
        headline: const Color(0xFFFFFFFF),
        focus: const Color(0xFFFFFFFF),
        divider: const Color(0xFFFFFFFF),
        active: const Color(0xFF6DFF6A),
        success: const Color(0xFF0ED678),
        hint: const Color(0xFFD7CACA),
        disable: const Color(0xFF666666),
        error: const Color(0xFFFF0707),
        light: const Color(0xFFFFFFFF),
        dark: const Color(0xFF000000),
      );

  factory ColorPalette.light() => ColorPalette(
        primary: const Color(0xFF074DFF),
        onPrimary: const Color(0xFF9207FF),
        primaryLight: const Color(0xFF573CFE),
        primaryDark: const Color(0xFF074DFF),
        secondary: const Color(0xFFE64DB8),
        onSecondary: const Color(0xFFCD07FF),
        tertiary: const Color(0xFF09091a),
        onTertiary: const Color(0xFFFFFFFF),
        scaffold: const Color(0xFFFFFFFF),
        surface: const Color(0xFFFFFFFF),
        onSurface: const Color(0xFFFFFFFF),
        icon: const Color(0xFF222233),
        text: const Color(0xFF222233),
        headline: const Color(0xFF09091a),
        focus: const Color(0xFFFFFFFF),
        divider: const Color(0xFF060B1F),
        active: const Color(0xFF6DFF6A),
        success: const Color(0xFF0ED678),
        hint: const Color(0xFF797595),
        disable: const Color(0xFFC1BFCE),
        error: const Color(0xFFFF0707),
        light: const Color(0xFFFFFFFF),
        dark: const Color(0xFF000000),
      );
}
