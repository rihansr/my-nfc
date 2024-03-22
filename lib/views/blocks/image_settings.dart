import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';
import '../../utils/debug.dart';
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
    debug.print(path);
    _imagePath = path.isEmpty ? null : path;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ExpansionBlockTile(
      widget.settings,
      icon: widget.settings['block'] == 'avatar'
          ? Icons.person_outline
          : Icons.image_outlined,
      padding: const EdgeInsets.fromLTRB(12, 8, 28, 18),
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
          size: widget.settings['data']?['style']?['size'],
          overlayOpacity: widget.settings['data']?['style']?['overlayOpacity'],
          onPick: (path) => imagePath = path,
          onRemove: () => imagePath = null,
        )
      ],
    );
  }
}
