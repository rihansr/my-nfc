import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
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
    return (() {
      if (url == null) return const SizedBox();
      if (url!.isYoutube) {
        return _YTVideoPlayer(
          url,
          key: Key(url!),
          configs: videoConfigs,
          aspectRatio: aspectRatio,
        );
      } else if (url!.isVimeo) {
        return _WebPlayer(
          url,
          key: Key(url!),
          configs: videoConfigs,
          aspectRatio: aspectRatio,
        );
      } else {
        return _VideoPlayer(
          url,
          key: Key(url!),
          configs: videoConfigs,
          aspectRatio: aspectRatio,
        );
      }
    }());
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

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    if (widget.url == null) return;
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url!));

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

class _WebPlayer extends StatefulWidget {
  final String? url;
  final Map<String, dynamic> configs;
  final double? aspectRatio;

  const _WebPlayer(
    this.url, {
    required this.configs,
    this.aspectRatio,
    super.key,
  });

  @override
  State<_WebPlayer> createState() => _WebPlayerState();
}

class _WebPlayerState extends State<_WebPlayer> {
  InAppWebViewController? _controller;
  Uri? url;
  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    StringBuffer buffer = StringBuffer();
    buffer.write('<html>');
    buffer.write('<body>');
    buffer.write('<iframe ');
    buffer.write(
        'style="position:absolute;left:0px;top:0px;width:100%;height:100vh;" ');
    /* buffer.write('src="https://www.youtube.com/embed/_ifwJhUPLzA?'
        'autoplay=${_BoolToInt(widget.configs['autoPlay'])}'
        '&loop=${_BoolToInt(widget.configs['loop'])}'
        '&controls=${_BoolToInt(widget.configs['showControls'])}'
        '&mute=${_BoolToInt(widget.configs['mute'])}" '); */
    buffer.write('src="https://player.vimeo.com/video/243692318?'
        'autoplay=${_BoolToInt(widget.configs['autoPlay'])}'
        '&loop=${_BoolToInt(widget.configs['loop'])}'
        '&controls=${_BoolToInt(widget.configs['showControls'])}'
        '&muted=${_BoolToInt(widget.configs['mute'])}" ');
    buffer.write('controls="${_BoolToInt(widget.configs['showControls'])}" ');
    buffer.write('frameborder="0" ');
    buffer.write('allow="accelerometer; ');
    if (widget.configs['autoPlay'] ?? false) {
      buffer.write('autoplay; ');
    }
    buffer.write('modestbranding; encrypted-media; gyroscope;" ');
    if (widget.configs['allowFullScreen'] ?? false) {
      buffer.write('webkitallowfullscreen mozallowfullscreen allowfullscreen ');
    }
    buffer.write('>');
    buffer.write('</iframe>');
    buffer.write('</body>');
    buffer.write('</html>');

    url = Uri.dataFromString(buffer.toString(), mimeType: 'text/html');
  }

  int _BoolToInt(bool? value) => (value ?? false) ? 1 : 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: widget.aspectRatio ?? 16 / 9,
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: url),
          onWebViewCreated: (controller) => {_controller = controller},
        ),
      );
}

class _YTVideoPlayer extends StatefulWidget {
  final String? url;
  final double? aspectRatio;
  final bool autoPlay;
  final bool loop;
  final bool mute;
  final bool showControls;
  final bool fullScreen;
  final double? startAt;
  final double? endAt;

  _YTVideoPlayer(
    this.url, {
    required Map<String, dynamic> configs,
    this.aspectRatio,
    super.key,
  })  : autoPlay = configs['autoPlay'] ?? false,
        loop = configs['loop'] ?? false,
        mute = configs['mute'] ?? false,
        showControls = configs['showControls'] ?? false,
        fullScreen = configs['allowFullScreen'] ?? false,
        startAt = configs['startAt']?.toString().duration.inSeconds.toDouble(),
        endAt = configs['endAt']?.toString().duration.inSeconds.toDouble();

  @override
  State<_YTVideoPlayer> createState() => _YTVideoPlayerState();
}

class _YTVideoPlayerState extends State<_YTVideoPlayer> {
  YoutubePlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(covariant _YTVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != null && oldWidget.url != widget.url) {
      _videoController?.loadVideo(widget.url!);
    }

    if (widget.autoPlay) _videoController?.pauseVideo();
    widget.mute ? _videoController?.mute() : _videoController?.unMute();
    _videoController?.setLoop(loopPlaylists: widget.loop);
    _videoController?.update(
      fullScreenOption: FullScreenOption(enabled: widget.fullScreen),
    );

    if (widget.startAt != null && oldWidget.startAt != widget.startAt) {
      _videoController?.duration.then((length) {
        if (length >= widget.startAt!) {
          _videoController?.currentTime.then((now) {
            if (now < widget.startAt!) {
              _videoController?.seekTo(seconds: widget.startAt!);
              _videoController?.playVideo();
            }
          });
        }
      });
    }
  }

  Future<void> _initController() async {
    if (widget.url == null) return;
    final videoId = YoutubePlayerController.convertUrlToId(widget.url!);
    if (videoId == null) return;

    _videoController = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      params: YoutubePlayerParams(
        loop: widget.loop,
        showControls: widget.showControls,
        mute: widget.mute,
        showFullscreenButton: widget.fullScreen,
      ),
      autoPlay: widget.autoPlay,
      startSeconds: widget.startAt,
      endSeconds: widget.endAt,
    );
    _videoController?.update(
      fullScreenOption: FullScreenOption(enabled: widget.fullScreen),
    );
  }

  @override
  void dispose() {
    _videoController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _videoController != null
      ? YoutubePlayer(
          controller: _videoController!,
          aspectRatio: widget.aspectRatio ?? 16 / 9,
        )
      : AspectRatio(
          aspectRatio: widget.aspectRatio ?? (16 / 9),
          child: const Clipper.expand(color: Colors.black12),
        );
}

extension _UrlExtensions on String {
  bool get isYoutube => RegExp(
          r'((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?')
      .hasMatch(this);

  bool get isVimeo => RegExp(
          r'((?:https?:)?\/\/)?((?:www|m)\.)?((?:vimeo\.com))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?').hasMatch(this);
}
