import 'package:flutter/material.dart';
import '../../utils/extensions.dart';
import '../../shared/strings.dart';
import '../../widgets/input_field_widget.dart';
import 'components/aspect_ratio_selector.dart';
import 'components/spcaing.dart';
import 'components/video_configs.dart';
import 'components/expansion_settings_tile.dart';

class VideoSettings extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  const VideoSettings({
    super.key,
    required this.settings,
    this.onUpdate,
  });

  updateSettings(String key, MapEntry<String, dynamic> value) {
    switch (key) {
      case 'style':
      case 'data':
        settings.addEntry(key, value);
      default:
        settings['data'] ??= {};
        (settings['data'] as Map<String, dynamic>).addEntry(key, value);
    }
    onUpdate?.call(settings);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionSettingsTile(
      settings,
      maintainState: true,
      icon: Icons.video_library_outlined,
      enableBoder: true,
      onUpdate: onUpdate,
      padding: const EdgeInsets.fromLTRB(14, 0, 22, 8),
      children: [
        InputField(
          controller: TextEditingController(text: settings['data']?['link']),
          minLines: 2,
          maxLines: 2,
          title: string.videoLink,
          textCapitalization: TextCapitalization.sentences,
          onTyping: (text) => updateSettings(
            'data',
            MapEntry('link', text.isEmpty ? null : text),
          ),
        ),
        AspectRatioSelector(
          settings['style']?['aspectRatio'],
          onSelected: (ratio) => updateSettings(
            'style',
            MapEntry('aspectRatio', ratio),
          ),
        ),
        VideoConfigs(
          configs: settings['data']?['configs'] ?? {},
          onUpdate: (entry) => updateSettings('configs', entry),
        ),
        Spacing(
          title: string.paddingAndMarginSettings,
          padding: settings['style']?['padding'],
          margin: settings['style']?['margin'],
          onUpdate: (spacing) => updateSettings('style', spacing),
        ),
      ],
    );
  }
}
