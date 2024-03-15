import 'package:flutter/material.dart';

import 'components/block_actions.dart';
import 'components/expansion_block_tile.dart';

class ImageBlock extends StatefulWidget {
  final Map<String, dynamic> data;
  const ImageBlock({super.key, required this.data});

  @override
  State<ImageBlock> createState() => _ImageBlockState();
}

class _ImageBlockState extends State<ImageBlock> {
  @override
  Widget build(BuildContext context) {
     return ExpansionBlockTile(
      widget.data,
      icon: Icons.image_outlined,
      children: const [],
    );
  }
}