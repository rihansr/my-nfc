import 'package:flutter/material.dart';
import 'components/expansion_settings_tile.dart';
import '../../utils/extensions.dart';
import 'components/image_view.dart';

class ImageSettings extends StatefulWidget {
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  const ImageSettings({
    super.key,
    required this.block,
    this.onUpdate,
  });

  @override
  State<ImageSettings> createState() => _ImageSettingsState();
}

class _ImageSettingsState extends State<ImageSettings> {
  String? _imagePath;
  set imagePath(String? image) {
    setState(() => _imagePath = image);
    widget.block.addEntry('data', MapEntry('path', image));
    widget.onUpdate?.call(widget.block);
  }

  @override
  void initState() {
    String path = widget.block['data']?['path']?.toString().trim() ?? '';
    _imagePath = path.isEmpty ? null : path;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ExpansionSettingsTile.settings(
      widget.block['settings'],
      icon: widget.block['block'] == 'avatar'
          ? Icons.person_outline
          : Icons.image_outlined,
      label: widget.block['label'],
      enableBoder: true,
      onUpdate: (entry) {
        widget.block.addEntry('settings', entry);
        widget.onUpdate?.call(widget.block);
      },
      onRemove: () => widget.onUpdate?.call({}),
      padding: const EdgeInsets.fromLTRB(10, 8, 22, 18),
      children: [
        if (widget.block['label'] != null) ...[
          Text(
            widget.block['label'] ?? '',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
        ],
        ImageView(
          path: _imagePath,
          fit: BoxFit.contain,
          onStyleChange: (data) {
            widget.block['data'] ??= {};
            (widget.block['data'] as Map<String, dynamic>)
                .addEntry('style', data);
            widget.onUpdate?.call(widget.block);
          },
          onPick: (path) => imagePath = path,
          onRemove: () => imagePath = null,
        )
      ],
    );
  }
}
