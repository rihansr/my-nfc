import 'package:flutter/material.dart';
import '../../shared/strings.dart';
import '../../utils/extensions.dart';
import '../../widgets/colour_picker_widget.dart';
import 'components/expansion_block_tile.dart';
import 'components/spcaing.dart';

// ignore: must_be_immutable
class DividerSettings extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  late Color _selectedColor;

  DividerSettings({
    super.key,
    required this.settings,
    this.onUpdate,
  }) : _selectedColor =
            settings['data']?['color']?.toString().hexColor ?? Colors.grey;

  updateBlock(String key, MapEntry<String, dynamic> value) {
    settings.addEntry(key, value);
    onUpdate?.call(settings);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      settings,
      maintainState: true,
      icon: Icons.zoom_out_map_outlined,
      padding: const EdgeInsets.fromLTRB(14, 0, 24, 8),
      children: [
        Spacing(
          margin: settings['data']?['margin'],
          onUpdate: (spacing) => updateBlock('data', spacing),
        ),
        ColourPicker(
          title: string.color,
          value: _selectedColor,
          colors: const [
            Colors.white,
            Colors.black,
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.yellow,
            Colors.orange,
            Colors.purple,
            Colors.pink,
            Colors.teal,
            Colors.brown
          ],
          onPick: (color) {
            _selectedColor = color;
            updateBlock('data', MapEntry('color', color.toHex));
          },
        ),
      ],
    );
  }
}
