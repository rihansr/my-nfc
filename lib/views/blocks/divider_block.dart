import 'package:flutter/material.dart';

import 'components/block_actions.dart';
import 'components/expansion_block_tile.dart';

class DividerBlock extends StatefulWidget {
  final Map<String, dynamic> data;
  const DividerBlock({super.key, required this.data});

  @override
  State<DividerBlock> createState() => _DividerBlockState();
}

class _DividerBlockState extends State<DividerBlock> {
  @override
  Widget build(BuildContext context) {
     return ExpansionBlockTile(
      widget.data,
      icon: Icons.remove_outlined,
      children: const [],
    );
  }
}