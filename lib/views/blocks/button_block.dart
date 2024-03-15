import 'package:flutter/material.dart';

import 'components/block_actions.dart';
import 'components/expansion_block_tile.dart';

class ButtonBlock extends StatefulWidget {
  final Map<String, dynamic> data;
  const ButtonBlock({super.key, required this.data});

  @override
  State<ButtonBlock> createState() => _ButtonBlockState();
}

class _ButtonBlockState extends State<ButtonBlock> {
  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      widget.data,
      icon: Icons.system_update_alt_outlined,
      children: const [],
    );
  }
}
