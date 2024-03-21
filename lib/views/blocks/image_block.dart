import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';
import '../../utils/debug.dart';
import '../../utils/extensions.dart';
import 'components/image_view.dart';

class ImageBlock extends StatefulWidget {
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  const ImageBlock({
    super.key,
    required this.block,
    this.onUpdate,
  });

  @override
  State<ImageBlock> createState() => _ImageBlockState();
}

class _ImageBlockState extends State<ImageBlock> {
  String? _imagePath;
  set imagePath(String? image) {
    setState(() => _imagePath = image);
    widget.block.addEntry('data', MapEntry('path', image));
    widget.onUpdate?.call(widget.block);
  }

  @override
  void initState() {
    String path = widget.block['data']?['path']?.toString().trim() ?? '';
    debug.print(path);
    _imagePath = path.isEmpty ? null : path;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ExpansionBlockTile(
      widget.block,
      icon: widget.block['block'] == 'avatar'
          ? Icons.person_outline
          : Icons.image_outlined,
      padding: const EdgeInsets.fromLTRB(12, 8, 28, 18),
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
          size: widget.block['data']?['style']?['size'],
          overlayOpacity: widget.block['data']?['style']?['overlayOpacity'],
          onPick: (path) => imagePath = path,
          onRemove: () => imagePath = null,
        )
      ],
    );
  }
}
