import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'components/expansion_block_tile.dart';
import '../../utils/extensions.dart';
import '../../widgets/clipper_widget.dart';

class ImageBlock extends StatefulWidget {
  final Map<String, dynamic> data;
  const ImageBlock({super.key, required this.data});

  @override
  State<ImageBlock> createState() => _ImageBlockState();
}

class _ImageBlockState extends State<ImageBlock> {
  String? _imagePath;
  set imagePath(dynamic image) => setState(
        () => _imagePath = image,
      );

  @override
  void initState() {
    String path = widget.data['data']?['path']?.toString().trim() ?? '';
    _imagePath = path.isEmpty ? null : path;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ExpansionBlockTile(
      widget.data,
      icon: widget.data['block'] == 'avatar'
          ? Icons.person_outline
          : Icons.image_outlined,
      padding: const EdgeInsets.fromLTRB(12, 8, 28, 18),
      children: [
        if (widget.data['label'] != null) ...[
          Text(
            widget.data['label'] ?? '',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
        ],
        AspectRatio(
          aspectRatio: 21 / 9,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () {
              if (_imagePath != null) return;
              extension.pickPhoto(ImageSource.gallery).then((path) {
                imagePath = path;
              });
            },
            child: Clipper(
              shape: BoxShape.rectangle,
              size: double.infinity,
              alignment: Alignment.center,
              radius: 6,
              color: _imagePath != null
                  ? theme.colorScheme.tertiary.withOpacity(0.05)
                  : null,
              border: Border.all(color: theme.disabledColor),
              child: _imagePath != null
                  ? Stack(
                      children: [
                        Positioned.fill(
                          child:
                              Uri.tryParse(_imagePath ?? '')?.hasAbsolutePath ??
                                      false
                                  ? CachedNetworkImage(
                                      imageUrl: _imagePath!,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          const CupertinoActivityIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Placeholder(),
                                    )
                                  : kIsWeb
                                      ? Image.network(_imagePath!,
                                          fit: BoxFit.contain)
                                      : Image.file(File(_imagePath!),
                                          fit: BoxFit.contain),
                        ),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: SizedBox.square(
                            dimension: 32,
                            child: IconButton(
                              onPressed: () => imagePath = null,
                              padding: const EdgeInsets.all(0),
                              icon: Icon(Icons.close, color: theme.hintColor),
                            ),
                          ),
                        )
                      ],
                    )
                  : Icon(
                      Icons.add_a_photo_outlined,
                      color: theme.hintColor,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
