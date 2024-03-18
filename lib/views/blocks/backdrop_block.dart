import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../configs/app_config.dart';
import '../../services/api.dart';
import '../../services/server_env.dart';
import '../../shared/strings.dart';
import '../../widgets/input_field_widget.dart';
import '../../widgets/button_widget.dart';
import 'components/expansion_block_tile.dart';

class BackdropBlock extends StatefulWidget {
  final MapEntry<Object, Map<String, dynamic>> data;
  const BackdropBlock({super.key, required this.data});

  @override
  State<BackdropBlock> createState() => _BackdropBlockState();
}

class _BackdropBlockState extends State<BackdropBlock> {
  late TextEditingController searchController;
  Timer? _debounce;
  int _page = 1;
  bool _isSearching = false;
  List<Map<String, dynamic>> photos = [];

  @override
  void initState() {
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => searchPhotos());
    super.initState();
  }

  searchPhotos({bool reload = true}) {
    if (reload) _page = 1;
    String? query = searchController.text.trim();
    query = query.isEmpty ? widget.data.value['label'] ?? 'banner' : query;
    setState(() => _isSearching = true);
    api
        .invoke(
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
          if (reload) photos.clear();
          photos.addAll(
              List<Map<String, dynamic>>.from(response.data['results']));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ExpansionBlockTile(
      widget.data.value,
      icon: Icons.image_outlined,
      padding: const EdgeInsets.fromLTRB(0, 18, 28, 18),
      children: [
        Row(
          children: [
            Expanded(
              child: InputField(
                controller: searchController,
                prefixIcon: const Icon(Icons.search, size: 20),
                padding: const EdgeInsets.symmetric(vertical: 6),
                margin: const EdgeInsets.all(0),
                textStyle: theme.textTheme.bodySmall,
                underlineOnly: true,
              ),
            ),
            const SizedBox(width: 8),
            Button(
              shape: BoxShape.rectangle,
              label: string.uploadImage,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              margin: const EdgeInsets.all(0),
            )
          ],
        ),
        const SizedBox(height: 24),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: photos.length + (_isSearching ? 10 : 0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, i) => CachedNetworkImage(
            imageUrl:
                photos.length > i ? (photos[i]['urls']?['thumb'] ?? '') : '',
            fit: BoxFit.cover,
            placeholder: (context, url) => const CupertinoActivityIndicator(),
            errorWidget: (context, url, error) => _isSearching
                ? const CupertinoActivityIndicator()
                : const Placeholder(),
          ),
        ),
        const SizedBox(height: 12),
        if (!_isSearching)
          Center(
            child: Button(
              label: string.loadMore,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
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
        )
      ],
    );
  }
}
