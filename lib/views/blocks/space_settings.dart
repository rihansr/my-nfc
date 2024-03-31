import 'package:flutter/material.dart';
import '../../utils/extensions.dart';
import '../../shared/strings.dart';
import '../../widgets/seekbar_widget.dart';
import 'components/expansion_settings_tile.dart';

// ignore: must_be_immutable
class SpaceSettings extends StatelessWidget {
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  late int _selectedHeight;

  SpaceSettings({
    super.key,
    required this.block,
    this.onUpdate,
  }) : _selectedHeight = block['data']?['style']?['height'] ?? 20;

  update(String key, int value) {
    block[key] ??= {};
    (block[key] as Map<String, dynamic>)
        .addEntry('style', MapEntry('height', value));
    onUpdate?.call(block);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionSettingsTile.settings(
      block['settings'],
      key: Key('$key'),
      icon: Icons.zoom_out_map_outlined,
      label: block['label'],
      enableBoder: true,
      onUpdate: (entry) {
        block.addEntry('settings', entry);
        onUpdate?.call(block);
      },
      onRemove: () => onUpdate?.call({}),
      padding: const EdgeInsets.fromLTRB(12, 0, 22, 0),
      children: [
        Seekbar(
          title: string.height,
          value: _selectedHeight,
          type: 'px',
          min: 0,
          max: 200,
          defaultValue: 20,
          onChanged: (value) {
            _selectedHeight = value;
            update('data', value);
          },
        ),
      ],
    );
  }
}
