import 'package:flutter/material.dart';
import '../services/navigation_service.dart';

final dimen = Dimen.value;

class Dimen {
  static Dimen get value => Dimen._();
  Dimen._();

  final Size size = MediaQuery.of(navigator.context).size;
  final double height = MediaQuery.of(navigator.context).size.height;
  final double width = MediaQuery.of(navigator.context).size.width;
  final EdgeInsets padding = MediaQuery.of(navigator.context).padding;

  final double maxMobileWidth = 450;
  bool get isMobile => width <= maxMobileWidth;

  double bottom(double value, [bool merge = true]) =>
      padding.bottom == 0 ? value : padding.bottom + (merge ? value : 0);
}
