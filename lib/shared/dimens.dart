import 'package:flutter/material.dart';
import '../services/navigation_service.dart';

final dimen = Dimen.value;

class Dimen {
  static Dimen get value => Dimen._();
  Dimen._();

  Size size = MediaQuery.of(navigator.context).size;
  double height = MediaQuery.of(navigator.context).size.height;
  double width = MediaQuery.of(navigator.context).size.width;
  EdgeInsets padding = MediaQuery.of(navigator.context).padding;

  double bottom(double value, [bool merge = true]) =>
      padding.bottom == 0 ? value : padding.bottom + (merge ? value : 0);
}
