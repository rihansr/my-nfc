import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class DividerBlock extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>)? onUpdate;
  
  const DividerBlock({
    super.key,
    required this.data,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      data,
      icon: Icons.remove_outlined,
      children: const [],
    );
  }
}
