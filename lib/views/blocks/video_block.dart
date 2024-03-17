import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';

class VideoBlock extends StatefulWidget {
  final MapEntry<Object, Map<String, dynamic>> data;
  const VideoBlock({super.key, required this.data});

  @override
  State<VideoBlock> createState() => _VideoBlockState();
}

class _VideoBlockState extends State<VideoBlock> {
  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      widget.data.value,
      icon: Icons.video_library_outlined,
      children: const [],
    );
  }
}
