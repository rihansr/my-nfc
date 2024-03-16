import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class SpaceBlock extends StatefulWidget {
  final MapEntry<Object, Map<String, dynamic>> data;
  const SpaceBlock({super.key, required this.data});

  @override
  State<SpaceBlock> createState() => _SpaceBlockState();
}

class _SpaceBlockState extends State<SpaceBlock> {

  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      widget.data.value,
      icon: Icons.zoom_out_map_outlined,
      children: const [],
    );
  }
}
