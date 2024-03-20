import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class AdditionalBlock extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>)? onUpdate;
  
  const AdditionalBlock({
    super.key,
    required this.data,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      data,
      icon: Icons.playlist_add_outlined,
      children: const [],
    );
  }
}
