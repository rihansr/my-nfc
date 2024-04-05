import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeModel {
  final int id;
  final Gradient background;
  final Color textColor;
  final Color iconColor;
  final Color dividerColor;
  final double horizontalPadding;
  final String? fontFamily;

  String get typography => fontFamily ?? GoogleFonts.openSans().fontFamily!;

  const ThemeModel({
    required this.id,
    required this.background,
    required this.textColor,
    required this.iconColor,
    required this.dividerColor,
    this.horizontalPadding = 20,
    this.fontFamily,
  });

  ThemeModel copyWith({
    int? id,
    Gradient? background,
    Color? textColor,
    Color? iconColor,
    Color? dividerColor,
    double? horizontalPadding,
    String? fontFamily,
  }) =>
      ThemeModel(
        id: id ?? this.id,
        background: background ?? this.background,
        textColor: textColor ?? this.textColor,
        iconColor: iconColor ?? this.iconColor,
        dividerColor: dividerColor ?? this.dividerColor,
        horizontalPadding: horizontalPadding ?? this.horizontalPadding,
        fontFamily: fontFamily ?? this.fontFamily,
      );

  ThemeModel inheritFrom(ThemeModel theme) =>
      ThemeModel(
        id: id,
        background: background,
        textColor: textColor,
        iconColor: iconColor,
        dividerColor: dividerColor,
        horizontalPadding: theme.horizontalPadding,
        fontFamily: theme.fontFamily,
      );

   @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;
    return other is ThemeModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
