import 'package:flutter/material.dart';
import 'components/expansion_settings_tile.dart';

class ButtonSettings extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  const ButtonSettings({
    super.key,
    required this.settings,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionSettingsTile(
      settings,
      icon: Icons.add_circle_outline,
      enableBoder: true,
      onUpdate: onUpdate,
      children: const [],
    );
  }
}
