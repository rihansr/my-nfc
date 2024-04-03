import 'package:flutter/material.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import '../../utils/extensions.dart';
import '../../widgets/colour_picker_widget.dart';
import 'components/block_expansion_tile.dart';
import 'components/spcaing.dart';

// ignore: must_be_immutable
class DividerSettings extends StatelessWidget {
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  const DividerSettings({
    super.key,
    required this.block,
    this.onUpdate,
  });

  update(String key, MapEntry<String, dynamic> value) {
    switch (key) {
      case "style":
        block.addEntry(key, value);
      default:
        block['data'] ??= {};
        (block['data'] as Map<String, dynamic>).addEntry('style', value);
    }
    onUpdate?.call(block);
  }

  @override
  Widget build(BuildContext context) {
    return BlockExpansionTile.settings(
      block['settings'],
      key: Key('$key'),
      icon: Icons.remove_outlined,
      label: block['label'],
      enableBorder: true,
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
          value: block['data']?['style']?['color']?.toString().hexColor ??
              const Color(0xff9e9e9e),
          colors: kColors,
          onPick: (color) => update('data', MapEntry('color', color.toHex)),
        ),
      ],
    );
  }
}
