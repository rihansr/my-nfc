import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../widgets/clipper_widget.dart';
import 'components/expansion_block_tile.dart';

class ImageBlock extends StatefulWidget {
  final MapEntry<Object, Map<String, dynamic>> data;
  const ImageBlock({super.key, required this.data});

  @override
  State<ImageBlock> createState() => _ImageBlockState();
}

class _ImageBlockState extends State<ImageBlock> {
  late File file;

  @override
  void initState() {
    file = File('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ExpansionBlockTile(
      widget.data.value,
      icon: widget.data.value['block'] == 'avatar' ? Iconsax.people: Icons.image_outlined,
      padding: const EdgeInsets.fromLTRB(0, 18, 28, 18),
      children: [
        AspectRatio(
          aspectRatio: 1 / 2,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            child: Clipper(
              shape: BoxShape.rectangle,
              size: double.infinity,
              alignment: Alignment.center,
              radius: 6,
              border: Border.all(width: .5, color: theme.disabledColor),
              child: file.existsSync()
                  ? Image.file(file, fit: BoxFit.contain)
                  : const Icon(Icons.add_a_photo_outlined, size: 32),
            ),
          ),
        )
      ],
    );
  }
}
