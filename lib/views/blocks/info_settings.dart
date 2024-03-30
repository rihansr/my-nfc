import 'package:flutter/material.dart';
import '../../utils/extensions.dart';
import '../../widgets/input_field_widget.dart';
import 'components/expansion_settings_tile.dart';

class InfoSettings extends StatelessWidget {
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  const InfoSettings({
    super.key,
    required this.block,
    this.onUpdate,
  });

  update(String key, String value) {
    block['data'] ??= {};
    (block['data'] as Map<String, dynamic>)
        .addEntry(key, MapEntry('text', value));
    onUpdate?.call(block);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionSettingsTile.settings(
      block['settings'],
      icon: Icons.info_outline,
      label: block['label'],
      enableBoder: true,
      onUpdate: (entry) {
        block.addEntry('settings', entry);
        onUpdate?.call(block);
      },
      onRemove: () => onUpdate?.call({}),
      padding: const EdgeInsets.fromLTRB(12, 0, 22, 8),
      children: (block['data'] as Map<String, dynamic>?)
              ?.entries
              .map(
                (e) => InputField(
                  controller: TextEditingController(text: e.value['text']),
                  hint: e.value['hint'],
                  margin: const EdgeInsets.only(top: 8),
                  onTyping: (text) => update(e.key, text),
                ),
              )
              .toList() ??
          [],
    );
  }
}
