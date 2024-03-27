import 'package:flutter/material.dart';
import 'components/expansion_settings_tile.dart';

class AdditionalSettings extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  const AdditionalSettings({
    super.key,
    required this.settings,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionSettingsTile(
      settings,
      icon: Icons.playlist_add_outlined,
      enableBoder: true,
      onUpdate: onUpdate,
      children: const [],
    );
  }
}
