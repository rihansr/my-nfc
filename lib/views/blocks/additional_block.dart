import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class AdditionalBlock extends StatefulWidget {
  final MapEntry<Object, Map<String, dynamic>> data;
  const AdditionalBlock({super.key, required this.data});

  @override
  State<AdditionalBlock> createState() => _AdditionalBlockState();
}

class _AdditionalBlockState extends State<AdditionalBlock> {
  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      widget.data.value,
      icon: Icons.playlist_add_outlined,
      children: const [],
    );
  }
}
