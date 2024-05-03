import 'package:flutter/material.dart';
import '../../utils/extensions.dart';
import '../../shared/strings.dart';
import '../../widgets/seekbar_widget.dart';
import 'components/block_expansion_tile.dart';

class SpaceSettings extends StatelessWidget {
  final Map<String, dynamic>? defaultBlock;
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  const SpaceSettings({
    super.key,
    this.defaultBlock,
    required this.block,
    this.onUpdate,
  });

  update(String key, int value) {
    block[key] ??= {};
    (block[key] as Map<String, dynamic>)
        .addEntry('style', MapEntry('height', value));
    onUpdate?.call(block);
  }

  @override
  Widget build(BuildContext context) {
    return BlockExpansionTile.settings(
      block['settings'],
      key: GlobalKey(debugLabel: '$key'),
      defaultStyle: defaultBlock?['style'],
      style: block['style'],
      icon: Icons.zoom_out_map_outlined,
      label: block['label'],
      enableBorder: true,
      onUpdate: (key, entry) {
        block.addEntry(key, entry);
        onUpdate?.call(block);
      },
      onRemove: () => onUpdate?.call({}),
      padding: const EdgeInsets.fromLTRB(12, 0, 22, 0),
      children: [
        Seekbar(
          title: string.height,
          defaultValue: defaultBlock?['data']?['style']?['height'] ?? 0,
          value: block['data']?['style']?['height'] ?? 0,
          type: 'px',
          min: 0,
          max: 200,
          onChanged: (value) => update('data', value),
        ),
      ],
    );
  }
}
