import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class ActionsBlock extends StatefulWidget {
  final MapEntry<Object, Map<String, dynamic>> data;
  const ActionsBlock({super.key, required this.data});

  @override
  State<ActionsBlock> createState() => _ActionsBlockState();
}

class _ActionsBlockState extends State<ActionsBlock> {

  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      widget.data.value,
      icon: Icons.system_update_alt_outlined,
      children: const [],
    );
  }
}
