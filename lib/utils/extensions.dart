import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../shared/strings.dart';
import '../shared/styles.dart';

final extension = Extension.function;

class Extension {
  static Extension get function => Extension._();
  Extension._();

  Future<String?> pickPhoto(
    ImageSource source, {
    Function(String path)? onPicked,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    var pickedFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );

    String path = pickedFile?.path.trim() ?? '';
    if (path.isNotEmpty) onPicked?.call(path);
    return path.isEmpty ? null : path;
  }

  String generateRandomString({int length = 6, digitsOnly = false}) {
    const digits = "1234567890";
    const letters = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    var chars = digitsOnly ? digits : (letters + digits);
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}

extension StringExtension on String {
  String get inCaps =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String get allInCaps => toUpperCase();
  String get capitalizeFirstOfEach => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
  get copy => Clipboard.setData(ClipboardData(text: this))
      .then((value) => style.showToast('$this ${string.copied}'.trim()));
  Color get hexColor => HexColor.fromHex(this);
}

extension ContextExtension on BuildContext {
  get scroll => Scrollable.ensureVisible(
        this,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
      );
}

extension MapExtension on Map<String, dynamic> {
  addEntry(String key, MapEntry<String, dynamic> entry) {
    if (containsKey(key)) {
      this[key].addEntries([entry]);
    } else {
      this[key] = {}..addEntries([entry]);
    }
  }
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    switch (hexString.length) {
      case 6:
        buffer.write('FF$hexString');
      case 7:
        buffer.write(hexString.replaceFirst('#', 'FF'));
      case 8:
        buffer.write(hexString);
      case 9:
        buffer.write(hexString.replaceFirst('#', ''));
    }
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String get toHex => '#'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
