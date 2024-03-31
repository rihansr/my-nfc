import 'package:flutter/material.dart';
import '../../utils/extensions.dart';
import '../../shared/strings.dart';
import '../../widgets/input_field_widget.dart';
import 'components/aspect_ratio_selector.dart';
import 'components/spcaing.dart';
import 'components/video_configs.dart';
import 'components/expansion_settings_tile.dart';

class VideoSettings extends StatelessWidget {
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  const VideoSettings({
    super.key,
    required this.block,
    this.onUpdate,
  });

  update(String key, MapEntry<String, dynamic> value) {
    switch (key) {
      case 'data':
      case 'style':
        block.addEntry(key, value);
      default:
        block['data'] ??= {};
        (block['data'] as Map<String, dynamic>).addEntry(key, value);
    }
    onUpdate?.call(block);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionSettingsTile.settings(
      block['settings'],
      key: Key('$key'),
      icon: Icons.video_library_outlined,
      label: block['label'],
      enableBoder: true,
      maintainState: true,
      onUpdate: (entry) {
        block.addEntry('settings', entry);
        onUpdate?.call(block);
      },
      onRemove: () => onUpdate?.call({}),
      padding: const EdgeInsets.fromLTRB(14, 0, 22, 8),
      children: [
        InputField(
          controller: TextEditingController(text: block['data']?['link']),
          minLines: 2,
          maxLines: 2,
          title: string.videoLink,
          textCapitalization: TextCapitalization.sentences,
          onTyping: (text) => update(
            'data',
            MapEntry('link', text.isEmpty ? null : text),
          ),
        ),
        AspectRatioSelector(
          block['style']?['aspectRatio'],
          onSelected: (ratio) => update(
            'style',
            MapEntry('aspectRatio', ratio),
          ),
        ),
        VideoConfigs(
          configs: block['data']?['configs'] ?? {},
          onUpdate: (entry) => update('configs', entry),
        ),
        Spacing(
          title: string.paddingAndMarginSettings,
          padding: block['style']?['padding'],
          margin: block['style']?['margin'],
          onUpdate: (spacing) => update('style', spacing),
        ),
      ],
    );
  }
}
