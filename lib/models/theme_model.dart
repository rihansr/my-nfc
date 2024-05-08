import 'package:flutter/material.dart';

class ThemeModel {
  final int id;
  final List<Color> colors;
  final List<double> stops;
  final Color textColor;
  final Color iconColor;
  final Color dividerColor;
  final double horizontalPadding;
  final String fontFamily;

  const ThemeModel({
    required this.id,
    required this.colors,
    required this.stops,
    required this.textColor,
    required this.iconColor,
    required this.dividerColor,
    this.horizontalPadding = 20,
    this.fontFamily = 'Open Sans',
  });

  ThemeModel copyWith({
    int? id,
    List<Color>? colors,
    List<double>? stops,
    Color? textColor,
    Color? iconColor,
    Color? dividerColor,
    double? horizontalPadding,
    String? fontFamily,
  }) =>
      ThemeModel(
        id: id ?? this.id,
        colors: colors ?? this.colors,
        stops: stops ?? this.stops,
        textColor: textColor ?? this.textColor,
        iconColor: iconColor ?? this.iconColor,
        dividerColor: dividerColor ?? this.dividerColor,
        horizontalPadding: horizontalPadding ?? this.horizontalPadding,
        fontFamily: fontFamily ?? this.fontFamily,
      );

  ThemeModel inheritFrom(ThemeModel theme) => ThemeModel(
        id: id,
        colors: colors,
        stops: stops,
        textColor: textColor,
        iconColor: iconColor,
        dividerColor: dividerColor,
        horizontalPadding: theme.horizontalPadding,
        fontFamily: theme.fontFamily,
      );

  Gradient get background => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
        stops: stops,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
