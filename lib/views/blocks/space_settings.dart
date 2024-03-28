import 'package:flutter/material.dart';
import '../../utils/extensions.dart';
import '../../shared/strings.dart';
import '../../widgets/seekbar_widget.dart';
import 'components/expansion_settings_tile.dart';

// ignore: must_be_immutable
class SpaceSettings extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  late int _selectedHeight;

  SpaceSettings({
    super.key,
    required this.settings,
    this.onUpdate,
  }) : _selectedHeight = settings['data']?['style']?['height'] ?? 20;

  update(int value) {
    _selectedHeight = value;
    settings['data'] ??= {};
    (settings['data'] as Map<String, dynamic>)
        .addEntry('style', MapEntry('height', value));
    onUpdate?.call(settings);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionSettingsTile(
      settings,
      icon: Icons.zoom_out_map_outlined,
      padding: const EdgeInsets.fromLTRB(12, 0, 22, 0),
      enableBoder: true,
      onUpdate: onUpdate,
      children: [
        Seekbar(
          title: string.height,
          value: _selectedHeight,
          type: 'px',
          min: 0,
          max: 200,
          defaultValue: 20,
          onChanged: update,
        ),
      ],
    );
  }
}
