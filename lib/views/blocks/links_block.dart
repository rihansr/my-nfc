import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class LinksBlock extends StatefulWidget {
  final MapEntry<Object, Map<String, dynamic>> data;
  const LinksBlock({super.key, required this.data});

  @override
  State<LinksBlock> createState() => _LinksBlockState();
}

class _LinksBlockState extends State<LinksBlock> {
  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      widget.data.value,
      icon: Icons.group_outlined,
      children: const [],
    );
  }
}
