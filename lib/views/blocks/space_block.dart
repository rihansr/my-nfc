import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class SpaceBlock extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>)? onUpdate;

  const SpaceBlock({
    super.key,
    required this.data,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      data,
      maintainState: true,
      icon: Icons.zoom_out_map_outlined,
      children: const [],
    );
  }
}
