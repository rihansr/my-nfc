import 'package:flutter/material.dart';

import 'components/block_actions.dart';
import 'components/expansion_block_tile.dart';

class TextBlock extends StatefulWidget {
  final Map<String, dynamic> data;
  const TextBlock({super.key, required this.data});

  @override
  State<TextBlock> createState() => _TextBlockState();
}

class _TextBlockState extends State<TextBlock> {
  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      widget.data,
      icon: Icons.title,
      children: const [],
    );
  }
}
