import 'dart:math' as math;
import 'package:flutter/material.dart';

LinearGradient gradient({
  Object? angle,
  required List<Color> colors,
  List<double>? stops,
}) {
  Alignment kAlignment = alignment(angle);
  return LinearGradient(
    begin: -kAlignment,
    end: kAlignment,
    colors: colors,
    stops: stops,
  );
}

Alignment alignment(Object? angleOrEndAlignment) {
  if (angleOrEndAlignment == null) {
    return Alignment.bottomCenter;
  } else if (angleOrEndAlignment is num) {
    final angle = angleOrEndAlignment.toDouble();
    return _degreesToAlignment(angle - 90);
  } else if (angleOrEndAlignment is Alignment) {
    return angleOrEndAlignment;
  } else {
    throw const FormatException(
      // ignore: lines_longer_than_80_chars
      'The "angleOrEndAlignment" argument is valid only for the "double" or "Alignment" type.',
    );
  }
}

Alignment _degreesToAlignment(double degrees) {
  final verticalOrHorizontal = _getVerticalOrHorizontal(degrees);
  if (verticalOrHorizontal != null) {
    return verticalOrHorizontal;
  }

  final x = _x(degrees);
  final y = _y(degrees);
  final xAbs = x.abs();
  final yAbs = y.abs();

  if ((0.0 < xAbs && xAbs < 1.0) || (0.0 < yAbs && yAbs < 1.0)) {
    final magnification = (1 / xAbs) < (1 / yAbs) ? (1 / xAbs) : (1 / yAbs);
    return Alignment(x, y) * magnification;
  } else {
    return Alignment(x, y);
  }
}

Alignment? _getVerticalOrHorizontal(double degrees) {
  var modDeg = degrees % 360;
  if (degrees < 0.0 && modDeg != 0.0) {
    modDeg -= 360;
  }

  if (modDeg == 0.0 || modDeg == -0.0) {
    return Alignment.centerRight;
  }
  if (modDeg == 90.0 || modDeg == -270.0) {
    return Alignment.bottomCenter;
  }
  if (modDeg == 180.0 || modDeg == -180.0) {
    return Alignment.centerLeft;
  }
  if (modDeg == 270.0 || modDeg == -90.0) {
    return Alignment.topCenter;
  }
  return null;
}

double _x(double degrees) {
  final radians = degrees / 180.0 * math.pi;
  return double.parse(math.cos(radians).toStringAsPrecision(8));
}

double _y(double degrees) {
  final radians = degrees / 180.0 * math.pi;
  return double.parse(math.sin(radians).toStringAsPrecision(8));
}
