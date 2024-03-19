import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class ButtonBlock extends StatelessWidget {
  final Map<String, dynamic> data;
  const ButtonBlock({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      data,
      icon: Icons.add_circle_outline,
      children: const [],
    );
  }
}
