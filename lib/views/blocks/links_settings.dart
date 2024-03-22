import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class LinksSettings extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  const LinksSettings({
    super.key,
    required this.settings,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      settings,
      maintainState: true,
      icon: Icons.group_outlined,
      children: const [],
    );
  }
}
