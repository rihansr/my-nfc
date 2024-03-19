import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class LinksBlock extends StatelessWidget {
  final Map<String, dynamic> data;
  const LinksBlock({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      data,
      icon: Icons.group_outlined,
      children: const [],
    );
  }
}
