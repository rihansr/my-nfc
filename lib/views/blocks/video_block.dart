import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../utils/extensions.dart';
import '../../widgets/clipper_widget.dart';

class VideoBlock extends StatelessWidget {
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  final String? url;
  final Map<String, dynamic> videoConfigs;
  final double? aspectRatio;

  VideoBlock(this.configs, {this.sectionStyle, super.key})
      : url = configs['data']?['link'],
        videoConfigs =
            Map<String, dynamic>.from(configs['data']?['configs'] ?? {}),
        aspectRatio = (() {
          final ratio = configs['style']?['aspectRatio'];
          if (ratio != null) {
            List<String> splitRatio = ratio.split(':');
            return int.parse(splitRatio[0]) / int.parse(splitRatio[1]);
          } else {
            return null;
          }
        }());

  @override
  Widget build(BuildContext context) {
    return _VideoPlayer(
      url,
      key: Key(url ?? ''),
      configs: videoConfigs,
      aspectRatio: aspectRatio,
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  final String? url;
  final Map<String, dynamic> configs;
  final double? aspectRatio;

  const _VideoPlayer(
    this.url, {
    required this.configs,
    this.aspectRatio,
    super.key,
  });

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoController;
  String? _url;

  @override
  void initState() {
    super.initState();
    _url = widget.url;
    _initController();
  }
  

  Future<void> _initController() async {
    if (_url == null) return;
    _videoController = VideoPlayerController.networkUrl(Uri.parse(_url!));

    await _videoController?.initialize().then(
          (_) => setState(() => _chewieController = ChewieController(
                videoPlayerController: _videoController!,
                allowedScreenSleep: false,
                startAt: widget.configs['startAt']?.toString().duration,
              )),
        );
  }

  _setConfigs() {
    _chewieController = _chewieController!.copyWith(
      autoPlay: widget.configs['autoPlay'] ?? false,
      looping: widget.configs['loop'] ?? false,
      showControls: widget.configs['showControls'] ?? false,
      allowMuting: widget.configs['mute'] ?? false,
      allowFullScreen: widget.configs['allowFullScreen'] ?? false,
      startAt: widget.configs['startAt']?.toString().duration,
    );
    _chewieController?.setVolume(widget.configs['mute'] ?? false ? 0.0 : 1.0);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _chewieController != null
      ? AspectRatio(
          aspectRatio:
              widget.aspectRatio ?? _videoController!.value.aspectRatio,
          child: Chewie(
            controller: (() {
              _setConfigs();
              return _chewieController!;
            }()),
          ),
        )
      : AspectRatio(
          aspectRatio: widget.aspectRatio ?? (16 / 9),
          child: const Clipper.expand(color: Colors.black12),
        );
}
