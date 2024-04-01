import 'package:flutter/material.dart';
import '../../utils/extensions.dart';
import 'components/settings_expansion_tile.dart';

class AdditionalSettings extends StatelessWidget {
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  const AdditionalSettings({
    super.key,
    required this.block,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsExpansionTile.settings(
      block['settings'],
      key: Key('$key'),
      icon: Icons.playlist_add_outlined,
      label: block['label'],
      enableBorder: true,
      onUpdate: (entry) {
        block.addEntry('settings', entry);
        onUpdate?.call(block);
      },
      onRemove: () => onUpdate?.call({}),
      children: const [],
    );
  }
}
