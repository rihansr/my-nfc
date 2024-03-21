import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class ButtonBlock extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>)? onUpdate;
  
  const ButtonBlock({
    super.key,
    required this.data,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      data,
      maintainState: true,
      icon: Icons.add_circle_outline,
      children: const [],
    );
  }
}
