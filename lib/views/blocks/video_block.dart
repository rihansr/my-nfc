import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../utils/extensions.dart';
import '../../widgets/clipper_widget.dart';

class VideoBlock extends StatefulWidget {
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  final Map<String, dynamic> videoConfigs;

  VideoBlock(this.configs, {this.sectionStyle, super.key})
      : videoConfigs =
            Map<String, dynamic>.from(configs['data']?['configs'] ?? {});

  @override
  State<VideoBlock> createState() => _VideoBlockState();
}

class _VideoBlockState extends State<VideoBlock> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initController() async {
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.configs['data']?['link'] ?? ''));

    await _videoController?.initialize().then(
      (_) {
        setState(
          () => _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            allowedScreenSleep: false,
            autoPlay: widget.videoConfigs['autoPlay'] ?? false,
            looping: widget.videoConfigs['loop'] ?? false,
            showControls: widget.videoConfigs['showControls'] ?? false,
            allowMuting: widget.videoConfigs['mute'] ?? false,
            allowFullScreen: widget.videoConfigs['allowFullScreen'] ?? false,
            startAt: widget.videoConfigs['startAt']?.toString().duration,
          ),
        );
        _chewieController
            ?.setVolume((widget.videoConfigs['mute'] ?? false) ? 0.0 : 1.0);
      },
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => (() {
        final aspectRatio = (() {
          final ratio = widget.configs['style']?['aspectRatio'];
          if (ratio != null) {
            List<String> splitRatio = ratio.split(':');
            return int.parse(splitRatio[0]) / int.parse(splitRatio[1]);
          } else {
            return null;
          }
        }());

        return FutureBuilder(
            future: _initController(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  _chewieController != null) {
                return AspectRatio(
                  aspectRatio:
                      aspectRatio ?? _videoController!.value.aspectRatio,
                  child: Chewie(controller: _chewieController!),
                );
              } else {
                return AspectRatio(
                  aspectRatio: aspectRatio ?? (16 / 9),
                  child: const Clipper.expand(color: Colors.black12),
                );
              }
            });
      }());
}
