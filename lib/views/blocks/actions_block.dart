import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class ActionsBlock extends StatelessWidget {
  final Map<String, dynamic> data;
  const ActionsBlock({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      data,
      icon: Icons.system_update_alt_outlined,
      children: const [],
    );
  }
}
