import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class SpaceBlock extends StatelessWidget {
  final Map<String, dynamic> data;
  const SpaceBlock({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      data,
      icon: Icons.zoom_out_map_outlined,
      children: const [],
    );
  }
}
