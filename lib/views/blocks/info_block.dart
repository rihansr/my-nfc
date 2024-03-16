import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class InfoBlock extends StatefulWidget {
  final MapEntry<Object, Map<String, dynamic>> data;
  const InfoBlock({super.key, required this.data});

  @override
  State<InfoBlock> createState() => _InfoBlockState();
}

class _InfoBlockState extends State<InfoBlock> {
  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      widget.data.value,
      icon: Icons.info_outline,
      children: const [],
    );
  }
}
