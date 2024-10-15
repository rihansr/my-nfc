import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_nfc/services/navigation_service.dart';

import 'strings.dart';

final style = _Style.value;

class _Style {
  static _Style get value => _Style._();
  _Style._();

  showToast(String message) => Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14.0,
      );

  showColorPicker(Color color, {required void Function(Color) onColorChanged}) {
    ThemeData theme = Theme.of(navigator.context);
    ColorPicker(
      color: color,
      onColorChanged: onColorChanged,
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        string.selectColor,
        style: theme.textTheme.titleMedium,
      ),
      subheading: Text(
        string.selectColorShade,
        style: theme.textTheme.titleMedium,
      ),
      wheelSubheading: Text(
        string.selectedColor,
        style: theme.textTheme.titleMedium,
      ),
      showColorName: true,
      showColorCode: true,
      showRecentColors: true,
      elevation: 0.5,
      enableOpacity: true,
      selectedColorIcon: Iconsax.brush_4,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        copyButton: true,
        pasteButton: true,
        longPressMenu: true,
      ),
      materialNameTextStyle: theme.textTheme.bodySmall,
      colorNameTextStyle: theme.textTheme.bodySmall,
      colorCodeTextStyle: theme.textTheme.bodyMedium,
      colorCodePrefixStyle: theme.textTheme.bodySmall,
      selectedPickerTypeColor: theme.colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: true,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.bw: true,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: true,
      },
    ).showPickerDialog(
      navigator.context,
      actionsPadding: const EdgeInsets.all(16),
      constraints:
          const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
  }

  InputBorder inputBorder(
    Color color, {
    double width = 0.75,
    bool underlineOnly = false,
    double radius = 4,
  }) {
    BorderSide borderSide = BorderSide(color: color, width: width);

    return underlineOnly
        ? UnderlineInputBorder(borderSide: borderSide)
        : OutlineInputBorder(
            borderSide: borderSide,
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          );
  }
}
