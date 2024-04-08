import 'package:flutter/material.dart';

class SpaceBlock extends StatelessWidget {
  final Map<String, dynamic> configs;
  const SpaceBlock(this.configs, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: configs['style']?['height']?.toDouble() ?? 0.0);
  }
}
