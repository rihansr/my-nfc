import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class ContactBlock extends StatelessWidget {
  final Map<String, dynamic> data;
  const ContactBlock({super.key, required this.data});
  
  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      data,
      icon: Icons.call_outlined,
      children: const [],
    );
  }
}
