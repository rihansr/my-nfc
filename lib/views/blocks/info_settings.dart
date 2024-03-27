import 'package:flutter/material.dart';
import '../../utils/extensions.dart';
import '../../widgets/input_field_widget.dart';
import 'components/expansion_settings_tile.dart';

class InfoSettings extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  const InfoSettings({
    super.key,
    required this.settings,
    this.onUpdate,
  });

  update(String key, String value) {
    settings['data'] ??= {};
    (settings['data'] as Map<String, dynamic>)
        .addEntry(key, MapEntry('text', value));
    onUpdate?.call(settings);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionSettingsTile(
      settings,
      icon: Icons.info_outline,
      padding: const EdgeInsets.fromLTRB(12, 0, 22, 8),
      enableBoder: true,
      onUpdate: onUpdate,
      children: (settings['data'] as Map<String, dynamic>?)
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
