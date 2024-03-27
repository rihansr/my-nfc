import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/extensions.dart';
import '../../configs/app_config.dart';
import '../../services/api.dart';
import '../../services/server_env.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import '../../widgets/input_field_widget.dart';
import '../../widgets/button_widget.dart';
import 'components/expansion_settings_tile.dart';
import 'components/image_view.dart';

class BackdropSettings extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  const BackdropSettings({
    super.key,
    required this.settings,
    this.onUpdate,
  });

  @override
  State<BackdropSettings> createState() => _BackdropSettingsState();
}

class _BackdropSettingsState extends State<BackdropSettings> {
  late TextEditingController searchController;
  Timer? _debounce;
  int _page = 1;
  bool _isSearching = false;
  String? _imagePath;
  final List<Map<String, dynamic>> _photos = [];

  @override
  void initState() {
    String path = widget.settings['data']?['path']?.toString().trim() ?? '';
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
    widget.settings.addEntry('data', MapEntry('path', image));
    widget.onUpdate?.call(widget.settings);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ExpansionSettingsTile(
      widget.settings,
      icon: Icons.image_outlined,
      padding: EdgeInsets.fromLTRB(
          12, widget.settings['label'] == null ? 4 : 18, 22, 18),
      enableBoder: true,
      onUpdate: widget.onUpdate,
      children: [
        _imagePath != null
            ? ImageView(
                path: _imagePath!,
                fit: BoxFit.cover,
                style: widget.settings['data']?['style'],
                onStyleChange: (data) {
                  widget.settings['data'] ??= {};
                  (widget.settings['data'] as Map<String, dynamic>)
                      .addEntry('style', data);
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
                      extension.pickPhoto(ImageSource.gallery).then((path) {
                        imagePath = path;
                      });
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
