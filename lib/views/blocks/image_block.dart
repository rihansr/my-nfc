import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'components/expansion_block_tile.dart';
import '../../utils/extensions.dart';
import '../../widgets/clipper_widget.dart';

class ImageBlock extends StatefulWidget {
  final MapEntry<Object, Map<String, dynamic>> data;
  const ImageBlock({super.key, required this.data});

  @override
  State<ImageBlock> createState() => _ImageBlockState();
}

class _ImageBlockState extends State<ImageBlock> {
  dynamic _image;
  set image(dynamic image) => setState(
        () => _image = image,
      );

  @override
  void initState() {
    String path = widget.data.value['data']?['path']?.toString().trim() ?? '';
    bool isUrl = Uri.tryParse(path)?.hasAbsolutePath ?? false;
    _image = path.isEmpty ? null : (isUrl ? path : File(path));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ExpansionBlockTile(
      widget.data.value,
      icon: widget.data.value['block'] == 'avatar'
          ? Icons.person_outline
          : Icons.image_outlined,
      padding: const EdgeInsets.fromLTRB(12, 8, 28, 18),
      children: [
        if (widget.data.value['label'] != null) ...[
          Text(
            widget.data.value['label'] ?? '',
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
              if (_image != null) return;
              extension.pickPhoto(ImageSource.gallery).then((file) {
                image = file.existsSync() ? file : null;
              });
            },
            child: Clipper(
              shape: BoxShape.rectangle,
              size: double.infinity,
              alignment: Alignment.center,
              radius: 6,
              color: _image != null
                  ? theme.colorScheme.tertiary.withOpacity(0.05)
                  : null,
              border: Border.all(color: theme.disabledColor),
              child: _image != null
                  ? Stack(
                      children: [
                        Positioned.fill(
                          child: _image is File
                              ? Image.file(_image, fit: BoxFit.contain)
                              : CachedNetworkImage(
                                  imageUrl: _image,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) =>
                                      const CupertinoActivityIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Placeholder(),
                                ),
                        ),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: SizedBox.square(
                            dimension: 32,
                            child: IconButton(
                              onPressed: () => image = null,
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
