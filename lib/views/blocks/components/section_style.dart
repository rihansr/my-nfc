import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/extensions.dart';
import '../../../configs/app_config.dart';
import '../../../services/api.dart';
import '../../../services/server_env.dart';
import '../../../shared/constants.dart';
import '../../../shared/strings.dart';
import '../../../widgets/colour_picker_widget.dart';
import '../../../widgets/input_field_widget.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/seekbar_widget.dart';
import '../../../widgets/tab_widget.dart';
import 'image_view.dart';

class SectionStyle extends StatelessWidget {
  final Map<String, dynamic> style;
  final Function(Map<String, dynamic>)? onUpdate;

  late final String? _selectedVerticalAlignment;
  late final String? _selectedHorizontalAlignment;
  late final Color? _selectedOverlayColor;
  late final int _selectedOverlayOpacity;

  SectionStyle(
    this.style, {
    super.key,
    this.onUpdate,
  })  : _selectedVerticalAlignment = style['alignment']?['vertical'],
        _selectedHorizontalAlignment = style['alignment']?['horizontal'],
        _selectedOverlayColor = style['overlay']?['color']?.toString().hexColor,
        _selectedOverlayOpacity = style['overlay']?['opacity'] ?? 0;

  update(String key, MapEntry<String, dynamic> entry) {
    Map<String, dynamic> style = Map<String, dynamic>.from(this.style);
    style.addEntry(key, entry);
    onUpdate?.call(style);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if ((style['background'] as Map?)?.containsKey('image') ?? false)
          _BackgroundImage(
            style['background']?['image'] ?? {},
            onUpdate: (map) {
              style['background']?['image'] = map;
              onUpdate?.call(style);
            },
          ),
        if (style.containsKey('alignment')) ...[
          TabWidget(
            title: string.contentVerticalAlignment,
            tabs: kVerticalAlignments,
            value: _selectedVerticalAlignment,
            onSelect: (alignment) {
              _selectedVerticalAlignment = alignment;
              update('alignment', MapEntry('vertical', alignment));
            },
          ),
          TabWidget(
            title: string.contentHorizontalAlignment,
            tabs: kHorizontalAlignments,
            value: _selectedHorizontalAlignment,
            onSelect: (alignment) {
              _selectedHorizontalAlignment = alignment;
              update('alignment', MapEntry('horizontal', alignment));
            },
          ),
        ],
        if (style.containsKey('overlay')) ...[
          ColourPicker(
            title: string.overlayColor,
            value: _selectedOverlayColor,
            colors: kColors,
            onPick: (color) {
              _selectedOverlayColor = color;
              update('overlay', MapEntry('color', color.toHex));
            },
          ),
          Seekbar(
            title: string.overlayOpacity,
            value: _selectedOverlayOpacity,
            type: '%',
            min: 0,
            max: 100,
            onChanged: (opacity) {
              _selectedOverlayOpacity = opacity;
              update('overlay', MapEntry('opacity', opacity));
            },
          ),
        ]
      ],
    );
  }
}

class _BackgroundImage extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  const _BackgroundImage(
    this.settings, {
    this.onUpdate,
  });

  @override
  State<_BackgroundImage> createState() => _BackgroundImageState();
}

class _BackgroundImageState extends State<_BackgroundImage> {
  late TextEditingController searchController;
  Timer? _debounce;
  int _page = 1;
  bool _isSearching = false;
  String? _imagePath;
  final List<Map<String, dynamic>> _photos = [];

  @override
  void initState() {
    String path = widget.settings['path']?.toString().trim() ?? '';
    _imagePath = path.isEmpty ? null : path;

    searchController = TextEditingController();
    searchController.addListener(() {
      if (_debounce?.isActive ?? false) {
        _debounce?.cancel();
      } else if (searchController.text.trim().isEmpty) {
        return;
      }
      _debounce = Timer(
        const Duration(milliseconds: 500),
        () => searchPhotos(),
      );
    });
    super.initState();
  }

  searchPhotos({bool reload = true}) {
    if (reload) _page = 1;
    String? query = searchController.text.trim();
    query = query.isEmpty ? widget.settings['label'] ?? 'banner' : query;
    setState(() => _isSearching = true);
    api
        .invoke(
      via: kIsWeb ? InvokeType.http : InvokeType.dio,
      baseUrl: ServerEnv.searchPhotos,
      queryParams: {
        'page': _page,
        'query': query,
        'per_page': 12,
        'orientation': 'landscape',
      },
      additionalHeaders: {
        HttpHeaders.authorizationHeader:
            "Client-ID ${appConfig.configs['unsplash']['access_key']},"
      },
      enableCaching: true,
      cacheSubKey: '$query-$_page',
    )
        .then((response) {
      if (response.data['results'] != null) {
        _page++;
        setState(() {
          _isSearching = false;
          if (reload) _photos.clear();
          _photos.addAll(
              List<Map<String, dynamic>>.from(response.data['results']));
        });
      }
    });
  }

  set imagePath(String? image) {
    setState(() => _imagePath = image);
    widget.settings['path'] = image;
    widget.onUpdate?.call(widget.settings);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        _imagePath != null
            ? ImageView(
                path: _imagePath!,
                fit: BoxFit.cover,
                style: widget.settings['style'],
                onStyleChange: (data) {
                  widget.settings.addEntry('style', data);
                  widget.onUpdate?.call(widget.settings);
                },
                onRemove: () => imagePath = null,
              )
            : Row(
                children: [
                  Expanded(
                    child: InputField(
                      controller: searchController,
                      prefixIcon: const Icon(Icons.search, size: 20),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      margin: const EdgeInsets.all(0),
                      textStyle: theme.textTheme.bodySmall,
                      underlineOnly: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Button(
                    shape: BoxShape.rectangle,
                    label: string.uploadImage,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    margin: const EdgeInsets.all(0),
                    radius: 6,
                    onPressed: () {
                      extension
                          .pickPhoto(ImageSource.gallery)
                          .then((path) => imagePath = path);
                    },
                  )
                ],
              ),
        if (_imagePath == null && _photos.isNotEmpty) ...[
          const SizedBox(height: 24),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _photos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, i) => InkWell(
              onTap: () => imagePath = _photos[i]['urls']?['regular'] ??
                  _photos[i]['urls']?['full'] ??
                  _photos[i]['urls']?['raw'],
              child: FadeInImage.memoryNetwork(
                image:
                    _photos[i]['urls']?['thumb'] ?? ServerEnv.placeholderImage,
                fit: BoxFit.cover,
                placeholder: kTransparentImage,
                placeholderErrorBuilder: (_, __, ___) =>
                    const CupertinoActivityIndicator(),
                imageErrorBuilder: (_, __, ___) => _isSearching
                    ? const CupertinoActivityIndicator()
                    : const Placeholder(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (!_isSearching)
            Center(
              child: Button(
                label: string.loadMore,
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                margin: const EdgeInsets.all(0),
                fontColor: theme.hintColor,
                borderTint: theme.hintColor,
                onPressed: () => searchPhotos(reload: false),
              ),
            ),
          const SizedBox(height: 24),
          Text(
            string.agreeUnsplashTerms,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.disabledColor,
            ),
          ),
        ]
      ],
    );
  }
}
