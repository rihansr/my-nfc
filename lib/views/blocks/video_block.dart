import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../../widgets/clipper_widget.dart';

class VideoBlock extends StatefulWidget {
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  const VideoBlock(this.configs, {this.sectionStyle, super.key});

  @override
  State<VideoBlock> createState() => _VideoBlockState();
}

class _VideoBlockState extends State<VideoBlock> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'));
    await _controller.initialize().then((_) => setState(() {}));
    _controller.play();

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double? aspectRatio = (() {
      final ratio = widget.configs['style']?['aspectRatio'];
      if (ratio != null) {
        List<String> splitRatio = ratio.split(':');
        return int.parse(splitRatio[0]) / int.parse(splitRatio[1]);
      } else {
        return null;
      }
    }());
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: aspectRatio ?? _controller.value.aspectRatio,
            child: Chewie(controller: _chewieController),
          )
        : aspectRatio != null
            ? AspectRatio(
                aspectRatio: aspectRatio,
                child: const Clipper.expand(color: Colors.black12),
              )
            : const SizedBox.shrink();
  }
}
