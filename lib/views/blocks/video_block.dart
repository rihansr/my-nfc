import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class VideoBlock extends StatelessWidget {
  final Map<String, dynamic> data;
  const VideoBlock({super.key, required this.data});
  
  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      data,
      icon: Icons.video_library_outlined,
      children: const [],
    );
  }
}
