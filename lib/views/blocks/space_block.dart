import 'package:flutter/material.dart';

class SpaceBlock extends StatelessWidget {
  
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  const SpaceBlock(this.configs, {this.sectionStyle, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: configs['data']?['style']?['height']?.toDouble() ?? 0.0,
    );
  }
}
