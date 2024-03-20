import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../configs/app_config.dart';
import '../../services/api.dart';
import '../../services/server_env.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import '../../widgets/input_field_widget.dart';
import '../../widgets/button_widget.dart';
import 'components/expansion_block_tile.dart';

class BackdropBlock extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>)? onUpdate;

  const BackdropBlock({
    super.key,
    required this.data,
    this.onUpdate,
  });

  @override
  State<BackdropBlock> createState() => _BackdropBlockState();
}

class _BackdropBlockState extends State<BackdropBlock> {
  late TextEditingController searchController;
  Timer? _debounce;
  int _page = 1;
  bool _isSearching = false;
  final List<Map<String, dynamic>> _photos = [];

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
    super.initState();
  }

  searchPhotos({bool reload = true}) {
    if (reload) _page = 1;
    String? query = searchController.text.trim();
    query = query.isEmpty ? widget.data['label'] ?? 'banner' : query;
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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ExpansionBlockTile(
      widget.data,
      icon: Icons.image_outlined,
      padding:
          EdgeInsets.fromLTRB(0, widget.data['label'] == null ? 0 : 18, 28, 18),
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
        if (_photos.isNotEmpty) ...[
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
            itemBuilder: (context, i) => FadeInImage.memoryNetwork(
              image: _photos[i]['urls']?['thumb'] ?? ServerEnv.placeholderImage,
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
              placeholderErrorBuilder: (_, __, ___) =>
                  const CupertinoActivityIndicator(),
              imageErrorBuilder: (_, __, ___) => _isSearching
                  ? const CupertinoActivityIndicator()
                  : const Placeholder(),
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
