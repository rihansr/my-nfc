import 'dart:developer';
import 'package:flutter/foundation.dart';

final Debug debug = Debug.value;

class Debug {
  static Debug get value => Debug._();

  Debug._();

  var enabled = kDebugMode;

  print(dynamic message, {bool bounded = true, String? tag}) =>
      {if (enabled) _log(message, bounded, tag)};

  _log(dynamic message, bool bounded, String? boundedText) {
    log(
      '${bounded || boundedText != null ? '\n<=====${boundedText ?? ''}=====>\n' : ''}'
      '$message'
      '${bounded || boundedText != null ? '\n<=====${boundedText ?? ''}=====>\n' : ''}',
    );
  }
}
