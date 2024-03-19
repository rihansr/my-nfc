import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class InfoBlock extends StatelessWidget {
  final Map<String, dynamic> data;
  const InfoBlock({super.key, required this.data});
  
  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      data,
      icon: Icons.info_outline,
      children: const [],
    );
  }
}
