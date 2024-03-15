import 'package:flutter/material.dart';

import 'components/block_actions.dart';
import 'components/expansion_block_tile.dart';

class ContactBlock extends StatefulWidget {
  final Map<String, dynamic> data;
  const ContactBlock({super.key, required this.data});

  @override
  State<ContactBlock> createState() => _ContactBlockState();
}

class _ContactBlockState extends State<ContactBlock> {
  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      widget.data,
      icon: Icons.call_outlined,
      children: const [],
    );
  }
}
