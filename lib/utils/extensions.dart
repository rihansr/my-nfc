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

  get unfocus => FocusManager.instance.primaryFocus?.unfocus();
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
  String get camelToNormal =>
      split(RegExp(r"(?=(?!^)[A-Z])")).join(' ').capitalizeFirstOfEach;

  Duration get duration => RegExp(r'^\d{2}:\d{2}:\d{2}$').hasMatch(this)
      ? Duration(
          hours: int.parse(split(':')[0]),
          minutes: int.parse(split(':')[1]),
          seconds: int.parse(split(':')[2]),
        )
      : Duration.zero;
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

  Map<String, List<dynamic>> findLinks(List by) {
    Map<String, List<dynamic>> mapList = {};

    forEach((key, val) {
      if (val is Map) {
        if (val.containsKey('data')) {
          final data = Map<String, dynamic>.from(val['data']);
          mapList.update('data', (value) => value..add(data),
              ifAbsent: () => [data]);
        } else {
          mapList.addAll(Map<String, dynamic>.from(val).findLinks(by));
        }
      } else if (val is List) {
        for (var i = 0; i < val.length; i++) {
          final map = Map<String, dynamic>.from(val[i]);
          mapList.addAll(map.findLinks(by));
        }
      }
    });

    return mapList;
  }
}

extension DynamicMapExtension on Map {
  addEntry(String key, MapEntry entry) {
    if (containsKey(key)) {
      this[key].addEntries([entry]);
    } else {
      this[key] = {}..addEntries([entry]);
    }
  }

  void modify(Map values) {
    forEach((key, value) {
      if (values.containsKey(key)) {
        this[key] = values[key];
      } else if (value is Map) {
        value.modify(values);
      }
      if (value is List) {
        for (var i = 0; i < value.length; i++) {
          (value[i] as Map).modify(values);
        }
      }
    });
  }

  List<Map<String, dynamic>> filterBy(MapEntry entry) {
    List<Map<String, dynamic>> list = [];
    forEach((key, value) {
      if (value is Map) {
        final map = Map<String, dynamic>.from(value);
        map[entry.key] == entry.value
            ? list.add(map)
            : list.addAll(map.filterBy(entry));
      } else if (value is List) {
        for (var i = 0; i < value.length; i++) {
          final map = Map<String, dynamic>.from(value[i]);
          map[entry.key] == entry.value
              ? list.add(map)
              : list.addAll(map.filterBy(entry));
        }
      }
    });
    return list;
  }

  List<Map<String, dynamic>> findBy(String key) {
    List<Map<String, dynamic>> list = [];
    forEach((k, v) {
      if (v is Map) {
        final map = Map<String, dynamic>.from(v);
        k == key ? list.add(map) : list.addAll(map.findBy(key));
      } else if (v is List) {
        for (var i = 0; i < v.length; i++) {
          final map = Map<String, dynamic>.from(v[i]);
          k == key ? list.add(map) : list.addAll(map.findBy(key));
        }
      }
    });
    return list;
  }
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    hexString = hexString.toUpperCase();
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
