import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class AdditionalBlock extends StatelessWidget {
  final Map<String, dynamic> data;
  const AdditionalBlock({super.key, required this.data});
  
  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      data,
      icon: Icons.playlist_add_outlined,
      children: const [],
    );
  }
}
