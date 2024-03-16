import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class DividerBlock extends StatefulWidget {
  final MapEntry<Object, Map<String, dynamic>> data;
  const DividerBlock({super.key, required this.data});

  @override
  State<DividerBlock> createState() => _DividerBlockState();
}

class _DividerBlockState extends State<DividerBlock> {
  @override
  Widget build(BuildContext context) {
     return ExpansionBlockTile(
      widget.data.value,
      icon: Icons.remove_outlined,
      children: const [],
    );
  }
}