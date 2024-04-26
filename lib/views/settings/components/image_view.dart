import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_nfc/views/blocks/components.dart';
import '../../../shared/strings.dart';
import '../../../utils/extensions.dart';
import '../../../widgets/clipper_widget.dart';
import '../../../widgets/seekbar_widget.dart';

// ignore: must_be_immutable
class ImageView extends StatefulWidget {
  final Uint8List? bytes;
  final BoxFit? fit;
  final int? _defaultScale;
  final int? _scale;
  final int? _overlayOpacity;
  final Map<String, dynamic>? defaultStyle;
  final Map<String, dynamic>? style;
  final Function(MapEntry<String, dynamic>)? onStyleChange;
  final Function(Uint8List? bytes)? onPick;
  final Function()? onRemove;

  ImageView({
    super.key,
    required this.bytes,
    this.fit,
    this.defaultStyle,
    this.style,
    this.onStyleChange,
    this.onPick,
    this.onRemove,
  })  : _scale =
            style?['scale'] == null ? null : (style!['scale'] * 10).toInt(),
        _defaultScale = defaultStyle?['scale'] == null
            ? null
            : (defaultStyle!['scale'] * 10).toInt(),
        _overlayOpacity = style?['overlayOpacity'];

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late int? scale;
  late int? opacity;
  late Uint8List? bytes;

  @override
  void initState() {
    scale = widget._scale;
    opacity = widget._overlayOpacity;
    bytes = widget.bytes;
    super.initState();
  }

  Widget get image => photo(bytes, fit: widget.fit ?? BoxFit.cover) ?? const Placeholder() /* Uri.tryParse(bytes!)?.isAbsolute ?? false
      ? FadeInImage.memoryNetwork(
          image: bytes!,
          fit: widget.fit,
          placeholder: kTransparentImage,
          placeholderErrorBuilder: (_, __, ___) =>
              const CupertinoActivityIndicator(),
          imageErrorBuilder: (_, __, ___) => const Placeholder(),
        )
      : kIsWeb
          ? Image.network(widget.bytes!, fit: widget.fit)
          : Image.file(File(widget.bytes!), fit: widget.fit) */
      ;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return bytes == null
        ? AspectRatio(
            aspectRatio: 21 / 9,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () => extension.pickPhoto(ImageSource.gallery).then(
                (path) async {
                  final bytes = await photoBytes(path);
                  setState(() => this.bytes = bytes);
                  widget.onPick?.call(bytes);
                },
              ),
              child: Clipper.rectangle(
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
                      child: scale != null
                          ? Transform.scale(
                              alignment: Alignment.center,
                              scale: scale! / 10,
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
                            setState(() => bytes = null);
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
              if (scale != null || opacity != null) ...[
                const SizedBox(height: 16),
                if (scale != null)
                  Seekbar(
                    title: string.resize,
                    value: scale!,
                    showCount: false,
                    defaultValue: widget._defaultScale ?? 10,
                    min: 1,
                    max: 20,
                    onChanged: (value) {
                      setState(() => scale = value);
                      widget.onStyleChange?.call(MapEntry('scale', value / 10));
                    },
                  ),
                if (opacity != null)
                  Seekbar(
                    title: string.overlayOpacity,
                    defaultValue: widget.defaultStyle?['overlayOpacity'],
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
