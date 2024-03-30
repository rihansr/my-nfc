import 'package:flutter/material.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import '../../utils/extensions.dart';
import '../../widgets/colour_picker_widget.dart';
import 'components/expansion_settings_tile.dart';
import 'components/spcaing.dart';

// ignore: must_be_immutable
class DividerSettings extends StatelessWidget {
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  late Color _selectedColor;

  DividerSettings({
    super.key,
    required this.block,
    this.onUpdate,
  }) : _selectedColor =
            block['data']?['style']?['color']?.toString().hexColor ??
                Colors.grey;

  update(String key, MapEntry<String, dynamic> value) {
    switch (key) {
      case "style":
        block.addEntry(key, value);
        return;
      case "data":
        block[key] ??= {};
        (block[key] as Map<String, dynamic>).addEntry('style', value);
        return;
    }
    onUpdate?.call(block);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionSettingsTile.settings(
      block['settings'],
      icon: Icons.remove_outlined,
      label: block['label'],
      enableBoder: true,
      onUpdate: (entry) {
        block.addEntry('settings', entry);
        onUpdate?.call(block);
      },
      onRemove: () => onUpdate?.call({}),
      padding: const EdgeInsets.fromLTRB(14, 0, 22, 8),
      children: [
        Spacing(
          margin: block['style']?['margin'],
          onUpdate: (spacing) => update('style', spacing),
        ),
        ColourPicker(
          title: string.color,
          value: _selectedColor,
          colors: kColors,
          onPick: (color) {
            _selectedColor = color;
            update('data', MapEntry('color', color.toHex));
          },
        ),
      ],
    );
  }
}
