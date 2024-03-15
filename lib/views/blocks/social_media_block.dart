import 'package:flutter/material.dart';

import 'components/block_actions.dart';
import 'components/expansion_block_tile.dart';

class SocialMediaBlock extends StatefulWidget {
  final Map<String, dynamic> data;
  const SocialMediaBlock({super.key, required this.data});

  @override
  State<SocialMediaBlock> createState() => _SocialMediaBlockState();
}

class _SocialMediaBlockState extends State<SocialMediaBlock> {
  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      widget.data,
      icon: Icons.group_outlined,
      children: const [],
    );
  }
}
