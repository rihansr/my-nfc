import 'package:flutter/material.dart';
import 'button_block.dart';
import 'components/block_actions.dart';
import 'components/expansion_block_tile.dart';
import 'contact_block.dart';
import 'divider_block.dart';
import 'image_block.dart';
import 'info_block.dart';
import 'social_media_block.dart';
import 'space_block.dart';
import 'text_block.dart';

class SectionBlock extends StatefulWidget {
  final Map<String, dynamic> data;
  const SectionBlock({super.key, required this.data});

  @override
  State<SectionBlock> createState() => _SectionBlockState();
}

class _SectionBlockState extends State<SectionBlock> {
  @override
  Widget build(BuildContext context) {
    return ExpansionBlockTile(
      widget.data,
      children: ((widget.data['fields'] as List?) ?? []).map((e) {
        switch (e['block']) {
          case "section":
            return SectionBlock(data: e);
          case "space":
            return SpaceBlock(data: e);
          case "divider":
            return DividerBlock(data: e);
          case "text":
            return TextBlock(data: e);
          case "image":
            return ImageBlock(data: e);
          case "contact":
            return ContactBlock(data: e);
          case "info":
            return InfoBlock(data: e);
          case "socialMedia":
            return SocialMediaBlock(data: e);
          case "button":
            return ButtonBlock(data: e);
          default:
            return const SizedBox.shrink();
        }
      }).toList(),
    );
  }
}
