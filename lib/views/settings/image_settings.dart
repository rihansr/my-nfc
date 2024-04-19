import 'package:flutter/material.dart';
import 'components/block_expansion_tile.dart';
import '../../utils/extensions.dart';
import 'components/image_view.dart';

class ImageSettings extends StatelessWidget {
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  ImageSettings({
    super.key,
    required this.block,
    this.onUpdate,
  }) : _imagePath = ValueNotifier(() {
          String path = block['data']?['path']?.toString().trim() ?? '';
          return path.isEmpty ? null : path;
        }());

  final ValueNotifier<String?> _imagePath;

  set imagePath(String? image) {
    _imagePath.value = image;
    block.addEntry('data', MapEntry('path', image));
    onUpdate?.call(block);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlockExpansionTile.settings(
      block['settings'],
      key: Key('$key'),
      style: block['style'],
      icon: block['subBlock'] == 'image_avatar'
          ? Icons.person_outline
          : Icons.image_outlined,
      label: block['label'],
      enableBorder: true,
      onUpdate: (key, entry) {
        block.addEntry(key, entry);
        onUpdate?.call(block);
      },
      onRemove: () => onUpdate?.call({}),
      padding: const EdgeInsets.fromLTRB(10, 8, 22, 18),
      children: [
        if (block['label'] != null) ...[
          const SizedBox(height: 12),
          Text(
            block['label'] ?? '',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
        ],
        ValueListenableBuilder(
          valueListenable: _imagePath,
          builder: (context, path, _) {
            return ImageView(
              path: path,
              fit: BoxFit.contain,
              onStyleChange: (data) {
                block['data'] ??= {};
                (block['data'] as Map<String, dynamic>).addEntry('style', data);
                onUpdate?.call(block);
              },
              onPick: (path) => imagePath = path,
              onRemove: () => imagePath = null,
            );
          },
        )
      ],
    );
  }
}
