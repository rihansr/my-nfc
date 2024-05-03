import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'components/block_expansion_tile.dart';
import '../../utils/extensions.dart';
import 'components/image_view.dart';

class ImageSettings extends StatelessWidget {
  final Map<String, dynamic>? defaultBlock;
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  ImageSettings({
    super.key,
    this.defaultBlock,
    required this.block,
    this.onUpdate,
  }) : _imageBytes = ValueNotifier(() {
          String? encodedBytes = block['data']?['bytes'];
          return encodedBytes == null ? null : base64Decode(encodedBytes);
        }());

  final ValueNotifier<Uint8List?> _imageBytes;

  set imageBytes(Uint8List? bytes) {
    _imageBytes.value = bytes;
    block.addEntry(
        'data', MapEntry('bytes', bytes == null ? null : base64Encode(bytes)));
    onUpdate?.call(block);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlockExpansionTile.settings(
      block['settings'],
      key: GlobalKey(debugLabel: '$key'),
      defaultStyle: defaultBlock?['style'],
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
          valueListenable: _imageBytes,
          builder: (context, bytes, _) {
            return ImageView(
              bytes: bytes,
              fit: BoxFit.contain,
              onStyleChange: (data) {
                block['data'] ??= {};
                (block['data'] as Map<String, dynamic>).addEntry('style', data);
                onUpdate?.call(block);
              },
              onPick: (bytes) => imageBytes = bytes,
              onRemove: () => imageBytes = null,
            );
          },
        )
      ],
    );
  }
}
