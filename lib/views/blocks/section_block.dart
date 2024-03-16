import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'components/expansion_block_tile.dart';
import 'button_block.dart';
import 'contact_block.dart';
import 'divider_block.dart';
import 'image_block.dart';
import 'info_block.dart';
import 'social_media_block.dart';
import 'space_block.dart';
import 'text_block.dart';

class SectionBlock extends StatefulWidget {
  final MapEntry<Object, Map<String, dynamic>> data;
  const SectionBlock({super.key, required this.data});

  @override
  State<SectionBlock> createState() => _SectionBlockState();
}

class _SectionBlockState extends State<SectionBlock> {
  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      widget.data.value,
      children:
          ((widget.data.value['fields'] as List?) ?? []).mapIndexed((i, e) {
        Key key = widget.key != null ? Key('${widget.key}/$i') : Key('$i');
        MapEntry<Object, Map<String, dynamic>> value = MapEntry(i, e);
        switch (e['block']) {
          case "section":
            return SectionBlock(key: key, data: value);
          case "space":
            return SpaceBlock(key: key, data: value);
          case "divider":
            return DividerBlock(key: key, data: value);
          case "text":
            return TextBlock(key: key, data: value);
          case "image":
            return ImageBlock(key: key, data: value);
          case "contact":
            return ContactBlock(key: key, data: value);
          case "info":
            return InfoBlock(key: key, data: value);
          case "socialMedia":
            return SocialMediaBlock(key: key, data: value);
          case "button":
            return ButtonBlock(key: key, data: value);
          default:
            return SizedBox.shrink(key: key);
        }
      }).toList(),
    );
  }
}
