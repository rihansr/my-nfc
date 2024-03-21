import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class ActionsBlock extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>)? onUpdate;
  
  const ActionsBlock({
    super.key,
    required this.data,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      data,
      maintainState: true,
      icon: Icons.system_update_alt_outlined,
      children: const [],
    );
  }
}
