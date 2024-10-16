import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/constants.dart';
import '../../../shared/strings.dart';
import '../../../utils/extensions.dart';
import '../../../configs/app_config.dart';
import '../../../services/api.dart';
import '../../../services/server_env.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/input_field_widget.dart';
import '../../blocks/components.dart';
import 'image_view.dart';

class Backdrop extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  const Backdrop(
    this.settings, {
    super.key,
    this.onUpdate,
  });

  @override
  State<Backdrop> createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop> {
  late TextEditingController searchController;
  Timer? _debounce;
  int _page = 1;
  bool _isSearching = false;
  Uint8List? _imageBytes;
  final List<Map<String, dynamic>> _photos = [];

  @override
  void initState() {
    String? encodedBytes = widget.settings['bytes'];
    _imageBytes = encodedBytes == null ? null : base64Decode(encodedBytes);

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

  set imageBytes(Uint8List? bytes) {
    setState(() => _imageBytes = bytes);
    widget.settings['bytes'] = bytes == null ? null : base64Encode(bytes);
    widget.onUpdate?.call(widget.settings);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: _imageBytes != null
              ? ImageView(
                  bytes: _imageBytes!,
                  fit: BoxFit.cover,
                  style: widget.settings['style'],
                  onStyleChange: (data) {
                    widget.settings.addEntry('style', data);
                    widget.onUpdate?.call(widget.settings);
                  },
                  onRemove: () => imageBytes = null,
                )
              : Row(
                  children: [
                    Expanded(
                      child: InputField(
                        controller: searchController,
                        prefixIcon: const Icon(Icons.search, size: 20),
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        margin: const EdgeInsets.only(bottom: 12),
                        textStyle: theme.textTheme.bodySmall,
                        underlineOnly: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Button(
                      shape: BoxShape.rectangle,
                      label: string.upload,
                      fontSize: 13,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      margin: const EdgeInsets.only(bottom: 12),
                      radius: 6,
                      onPressed: () =>
                          extension.pickPhoto(ImageSource.gallery).then(
                        (path) async {
                          final bytes = await photoBytes(path);
                          imageBytes = bytes;
                        },
                      ),
                    )
                  ],
                ),
        ),
        if (_imageBytes == null && _photos.isNotEmpty) ...[
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
              onTap: () async {
                String? url = _photos[i]['urls']?['regular'] ??
                    _photos[i]['urls']?['full'] ??
                    _photos[i]['urls']?['raw'];
                Uint8List? bytes = url == null ? null : await photoBytes(url);
                imageBytes = bytes;
              },
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
          const SizedBox(height: 12),
        ] else if (_isSearching)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text.rich(
              TextSpan(
                text: '',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.hintColor,
                ),
                children: [
                  WidgetSpan(
                    child: CupertinoActivityIndicator(
                      color: theme.iconTheme.color,
                      radius: 8,
                    ),
                    alignment: PlaceholderAlignment.middle,
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(text: string.loading),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          )
      ],
    );
  }
}
