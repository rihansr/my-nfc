import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBlock extends StatefulWidget {
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  const VideoBlock(this.configs, {this.sectionStyle, super.key});

  @override
  State<VideoBlock> createState() => _VideoBlockState();
}

class _VideoBlockState extends State<VideoBlock> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'));
    await _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const SizedBox.shrink();
  }
}
