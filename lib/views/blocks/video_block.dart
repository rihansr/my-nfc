import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../services/api.dart';
import '../../utils/extensions.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import 'components.dart';

class VideoBlock extends StatelessWidget {
  final String path;
  final DashboardViewModel parent;
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  final String? _url;
  final Map<String, dynamic> _videoConfigs;
  final double? _aspectRatio;

  VideoBlock(
    this.configs, {
    required this.parent,
    required this.path,
    this.sectionStyle,
    super.key,
  })  : _url = configs['data']?['link'],
        _videoConfigs =
            Map<String, dynamic>.from(configs['data']?['configs'] ?? {}),
        _aspectRatio = (() {
          final ratio = configs['data']?['style']?['aspectRatio'];
          if (ratio != null) {
            List<String> splitRatio = ratio.split(':');
            return int.parse(splitRatio[0]) / int.parse(splitRatio[1]);
          } else {
            return null;
          }
        }());

  @override
  Widget build(BuildContext context) {
    final key = parent.key('$path/');

    return Container(
      key: key,
      decoration: BoxDecoration(
        color: configs['style']?['background']?['color']?.toString().hexColor,
        border: parent.isSelected(key) ? selectedBorder : null,
      ),
      transform: transform(configs['style']?['spacing']?['margin']),
      margin: margin(configs['style']?['spacing']?['margin']),
      padding: padding(configs['style']?['spacing']?['padding']),
      child: (() {
        if (_url == null) {
          return AspectRatio(
            aspectRatio: _aspectRatio ?? (16 / 9),
            child: const SizedBox.expand(),
          );
        } else if (_url.isYoutube) {
          return _YTVideoPlayer(
            _url,
            key: Key(_url),
            configs: _videoConfigs,
            aspectRatio: _aspectRatio,
          );
        } else {
          return _VideoPlayer(
            _url,
            key: Key(_url),
            configs: _videoConfigs,
            aspectRatio: _aspectRatio,
          );
        }
      }()),
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  final String url;
  final double? aspectRatio;
  final bool autoPlay;
  final bool loop;
  final bool mute;
  final bool showControls;
  final bool fullScreen;
  final Duration? startAt;
  final Duration? endAt;

  _VideoPlayer(
    this.url, {
    required Map<String, dynamic> configs,
    this.aspectRatio,
    super.key,
  })  : autoPlay = configs['autoPlay'] ?? false,
        loop = configs['loop'] ?? false,
        mute = configs['mute'] ?? false,
        showControls = configs['showControls'] ?? false,
        fullScreen = configs['allowFullScreen'] ?? false,
        startAt = configs['startAt']?.toString().duration,
        endAt = configs['endAt']?.toString().duration;

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(covariant _VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startAt != widget.startAt) {
      _chewieController?.copyWith(startAt: widget.startAt);
    }
    if (oldWidget.endAt != widget.endAt) {
      if (widget.endAt == null) {
        _videoController?.removeListener(() {});
      } else {
        _videoController?.addListener(() {
          if (_videoController!.value.position >= widget.endAt!) {
            _videoController?.pause();
          }
        });
      }
    }
    controller = _chewieController;
  }

  Future<String?> get _findUrl async {
    String? videoId = widget.url.vimeoId;
    return videoId != null ? await _fetchVimeoUrl(videoId) : widget.url;
  }

  Future<String?> _fetchVimeoUrl(String id) async {
    Response response = await api.invoke(
      baseUrl: 'https://player.vimeo.com',
      endpoint: 'video/$id/config',
      method: Method.get,
      cacheDuration: const Duration(days: 1),
      justifyResponse: true,
    );

    if (response.data == null || response.data! is! Map) return null;

    List resolutionJson =
        response.data['request']?['files']?['progressive'] ?? [];
    Map<String, String> resolutions = {
      for (var item in resolutionJson) item['quality']: item['url']
    };

    Map<String, dynamic> cdnsJson =
        response.data['request']?['files']?['hls']?['cdns'] ?? {};
    List urls = cdnsJson.values
        .map((e) => e['url'])
        .where((element) => element != null)
        .toList();

    return resolutions.isNotEmpty
        ? resolutions.values.last
        : urls.isNotEmpty
            ? urls.first
            : null;
  }

  Future<void> _initController() async {
    String? url = await _findUrl;
    if (url == null) return;
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));

    await _videoController?.initialize().then((_) {
      controller = ChewieController(
        videoPlayerController: _videoController!,
        allowedScreenSleep: false,
        startAt: widget.startAt,
      );
      if (widget.endAt != null) {
        _videoController?.addListener(() {
          if (_videoController!.value.position >= widget.endAt!) {
            _videoController?.pause();
          }
        });
      }
    });
  }

  set controller(ChewieController? controller) {
    setState(() {
      _chewieController = controller?.copyWith(
        autoPlay: widget.autoPlay,
        looping: widget.loop,
        showControls: widget.showControls,
        allowMuting: widget.mute,
        allowFullScreen: widget.fullScreen,
      );
      _chewieController?.setVolume(widget.mute ? 0.0 : 1.0);
    });
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
          child: Chewie(controller: _chewieController!),
        )
      : AspectRatio(
          aspectRatio: widget.aspectRatio ?? (16 / 9),
          child: const SizedBox.expand(
            child: Center(child: CircularProgressIndicator.adaptive()),
          ),
        );
}

class _YTVideoPlayer extends StatefulWidget {
  final String url;
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
  late YoutubePlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(covariant _YTVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _videoController.loadVideo(widget.url);
    }

    if (widget.autoPlay) _videoController.pauseVideo();
    widget.mute ? _videoController.mute() : _videoController.unMute();
    _videoController.setLoop(loopPlaylists: widget.loop);
    _videoController.update(
      fullScreenOption: FullScreenOption(enabled: widget.fullScreen),
    );

    if (widget.startAt != null && oldWidget.startAt != widget.startAt) {
      _videoController.duration.then((length) {
        if (length >= widget.startAt!) {
          _videoController.currentTime.then((now) {
            if (now < widget.startAt!) {
              _videoController.seekTo(seconds: widget.startAt!);
              _videoController.playVideo();
            }
          });
        }
      });
    }
  }

  Future<void> _initController() async {
    final videoId = YoutubePlayerController.convertUrlToId(widget.url);

    _videoController = YoutubePlayerController.fromVideoId(
      videoId: videoId ?? '',
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
    _videoController.update(
      fullScreenOption: FullScreenOption(enabled: widget.fullScreen),
    );
  }

  @override
  void dispose() {
    _videoController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => YoutubePlayer(
        controller: _videoController,
        aspectRatio: widget.aspectRatio ?? 16 / 9,
      );
}

extension _UrlExtensions on String {
  bool get isYoutube => RegExp(
        r'((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?',
      ).hasMatch(this);

  String? get vimeoId => RegExp(
        r'(?:http:|https:|)\/\/(?:player.|www.)?vimeo\.com\/(?:video\/|embed\/|watch\?\S*v=|v\/)?(\d*)',
      ).firstMatch(this)?.group(1);
}
