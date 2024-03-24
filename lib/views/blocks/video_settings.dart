import 'package:flutter/material.dart';
import 'components/expansion_settings_tile.dart';

class VideoSettings extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  const VideoSettings({
    super.key,
    required this.settings,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionSettingsTile(
      settings,
      maintainState: true,
      icon: Icons.video_library_outlined,
      enableBoder: true,
      onUpdate: onUpdate,
      children: const [],
    );
  }
}
