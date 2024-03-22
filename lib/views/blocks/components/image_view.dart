import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/strings.dart';
import '../../../shared/constants.dart';
import '../../../utils/extensions.dart';
import '../../../widgets/clipper_widget.dart';
import '../../../widgets/seekbar_widget.dart';

// ignore: must_be_immutable
class ImageView extends StatefulWidget {
  final String? path;
  final BoxFit? fit;
  final int? _size;
  final int? _overlayOpacity;
  final Map<String, dynamic>? style;
  final Function(MapEntry<String, dynamic>)? onStyleChange;
  final Function(String? path)? onPick;
  final Function()? onRemove;

  ImageView({
    super.key,
    required this.path,
    this.fit,
    this.style,
    this.onStyleChange,
    this.onPick,
    this.onRemove,
  })  : _size = style?['size'],
        _overlayOpacity = style?['overlayOpacity'];

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late int? size;
  late int? opacity;
  late String? path;

  @override
  void initState() {
    size = widget._size;
    opacity = widget._overlayOpacity;
    path = widget.path;
    super.initState();
  }

  Widget get image => Uri.tryParse(path!)?.isAbsolute ?? false
      ? FadeInImage.memoryNetwork(
          image: path!,
          fit: widget.fit,
          placeholder: kTransparentImage,
          placeholderErrorBuilder: (_, __, ___) =>
              const CupertinoActivityIndicator(),
          imageErrorBuilder: (_, __, ___) => const Placeholder(),
        )
      : kIsWeb
          ? Image.network(widget.path!, fit: widget.fit)
          : Image.file(File(widget.path!), fit: widget.fit);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return path == null
        ? AspectRatio(
            aspectRatio: 21 / 9,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () => extension.pickPhoto(ImageSource.gallery).then(
                (path) {
                  setState(() => this.path = path);
                  widget.onPick?.call(path);
                },
              ),
              child: Clipper(
                shape: BoxShape.rectangle,
                size: double.infinity,
                alignment: Alignment.center,
                radius: 6,
                border: Border.all(color: theme.disabledColor),
                child: Icon(
                  Icons.add_a_photo_outlined,
                  color: theme.hintColor,
                ),
              ),
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Clipper(
                shape: BoxShape.rectangle,
                radius: 6,
                color: theme.colorScheme.tertiary.withOpacity(0.05),
                border: Border.all(color: theme.disabledColor),
                child: Stack(
                  children: [
                    Clipper(
                      overlayColor: opacity == null
                          ? null
                          : Colors.black.withOpacity(opacity! / 100),
                      child: size != null
                          ? Transform.scale(
                              alignment: Alignment.center,
                              scale: size! / 10,
                              child: image,
                            )
                          : AspectRatio(
                              aspectRatio: 21 / 9,
                              child: image,
                            ),
                    ),
                    Positioned(
                      right: 2,
                      top: 2,
                      child: SizedBox.square(
                        dimension: 32,
                        child: IconButton(
                          onPressed: () {
                            setState(() => path = null);
                            widget.onRemove?.call();
                          },
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (size != null || opacity != null) ...[
                const SizedBox(height: 16),
                if (size != null)
                  Seekbar(
                    title: string.resize,
                    value: size!,
                    showCount: false,
                    defaultValue: 10,
                    min: 1,
                    max: 20,
                    onChanged: (value) {
                      setState(() => size = value);
                      widget.onStyleChange?.call(MapEntry('size', value));
                    },
                  ),
                if (opacity != null)
                  Seekbar(
                    title: string.overlayOpacity,
                    value: opacity!,
                    type: '%',
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() => opacity = value);
                      widget.onStyleChange
                          ?.call(MapEntry('overlayOpacity', value));
                    },
                  ),
              ]
            ],
          );
  }
}
