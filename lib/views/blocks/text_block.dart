import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class TextBlock extends StatefulWidget {
  final MapEntry<Object, Map<String, dynamic>> data;
  const TextBlock({super.key, required this.data});

  @override
  State<TextBlock> createState() => _TextBlockState();
}

class _TextBlockState extends State<TextBlock> {
  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      widget.data.value,
      icon: Icons.title,
      children: const [],
    );
  }
}
