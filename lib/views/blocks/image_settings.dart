import 'package:flutter/material.dart';
import 'components/expansion_settings_tile.dart';
import '../../utils/extensions.dart';
import 'components/image_view.dart';

class ImageSettings extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  const ImageSettings({
    super.key,
    required this.settings,
    this.onUpdate,
  });

  @override
  State<ImageSettings> createState() => _ImageSettingsState();
}

class _ImageSettingsState extends State<ImageSettings> {
  String? _imagePath;
  set imagePath(String? image) {
    setState(() => _imagePath = image);
    widget.settings.addEntry('data', MapEntry('path', image));
    widget.onUpdate?.call(widget.settings);
  }

  @override
  void initState() {
    String path = widget.settings['data']?['path']?.toString().trim() ?? '';
    _imagePath = path.isEmpty ? null : path;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ExpansionSettingsTile(
      widget.settings,
      icon: widget.settings['block'] == 'avatar'
          ? Icons.person_outline
          : Icons.image_outlined,
      padding: const EdgeInsets.fromLTRB(10, 8, 26, 18),
      enableBoder: true,
      children: [
        if (widget.settings['label'] != null) ...[
          Text(
            widget.settings['label'] ?? '',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
        ],
        ImageView(
          path: _imagePath,
          fit: BoxFit.contain,
          style: widget.settings['data']?['style'],
          onStyleChange: (data) {
            widget.settings['data'] ??= {};
            (widget.settings['data'] as Map<String, dynamic>)
                .addEntry('style', data);
            widget.onUpdate?.call(widget.settings);
          },
          onPick: (path) => imagePath = path,
          onRemove: () => imagePath = null,
        )
      ],
    );
  }
}
