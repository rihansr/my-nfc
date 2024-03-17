import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import 'actions_block.dart';
import 'additional_block.dart';
import 'backdrop_block.dart';
import 'button_block.dart';
import 'components/expansion_block_tile.dart';
import 'contact_block.dart';
import 'divider_block.dart';
import 'image_block.dart';
import 'info_block.dart';
import 'links_block.dart';
import 'space_block.dart';
import 'text_block.dart';
import 'video_block.dart';

class SectionBlock extends StatefulWidget {
  final MapEntry<Object, Map<String, dynamic>> data;
  const SectionBlock({super.key, required this.data});

  @override
  State<SectionBlock> createState() => _SectionBlockState();
}

class _SectionBlockState extends State<SectionBlock> {
  @override
  Widget build(BuildContext context) {
    List fields = (widget.data.value['fields'] as List?) ?? [];
    return ExpansionBlockTile(
      widget.data.value,
      children: fields.isEmpty
          ? [
              _AddButton(
                onSelected: (data) => {},
              ),
            ]
          : [
              ...fields.mapIndexed(
                (i, e) {
                  Key key =
                      widget.key != null ? Key('${widget.key}/$i') : Key('$i');
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
                    case "banner":
                    case "background":
                      return BackdropBlock(key: key, data: value);
                    case "avatar":
                    case "image":
                      return ImageBlock(key: key, data: value);
                    case "contact":
                      return ContactBlock(key: key, data: value);
                    case "info":
                      return InfoBlock(key: key, data: value);
                    case "publicLinks":
                    case "links":
                      return LinksBlock(key: key, data: value);
                    case "button":
                      return ButtonBlock(key: key, data: value);
                    case "video":
                      return VideoBlock(key: key, data: value);
                    case "additional":
                      return AdditionalBlock(key: key, data: value);
                    case "actions":
                      return ActionsBlock(key: key, data: value);
                    default:
                      return SizedBox.shrink(key: key);
                  }
                },
              ),
              if (widget.data.value['primary'] == false)
                _AddButton(
                  onSelected: (data) => {},
                ),
            ],
    );
  }
}

class _AddButton extends StatelessWidget {
  final Function(Map<String, dynamic>)? onSelected;
  const _AddButton({this.onSelected});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 28),
      child: PopupMenuButton<Map<String, dynamic>>(
        itemBuilder: (context) {
          return kAdditionalBlocks.mapIndexed((index, element) {
            return PopupMenuItem<Map<String, dynamic>>(
              value: element,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text.rich(
                TextSpan(
                  style: theme.textTheme.bodySmall,
                  children: [
                    WidgetSpan(
                      child: Icon(
                        (() {
                          switch (element['block']) {
                            case "section":
                              return Icons.view_agenda;
                            case "space":
                              return Icons.zoom_out_map_rounded;
                            case "divider":
                              return Icons.remove_outlined;
                            case "text":
                              return Icons.title_outlined;
                            case "image":
                              return Icons.image_outlined;
                            case "contact":
                              return Icons.call_outlined;
                            case "info":
                              return Icons.info;
                            case "publicLinks":
                            case "links":
                              return Icons.group_outlined;
                            case "button":
                              return Icons.add_circle_outline;
                            case "video":
                              return Icons.video_library_outlined;
                            case "additional":
                              return Icons.playlist_add_outlined;
                            case "actions":
                              return Icons.system_update_alt_outlined;
                            default:
                              return Icons.info;
                          }
                        }()),
                        size: 16,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    const TextSpan(text: "  "),
                    TextSpan(text: element['label'] ?? ""),
                  ],
                ),
              ),
            );
          }).toList();
        },
        offset: const Offset(-3, 0),
        color: theme.scaffoldBackgroundColor,
        elevation: 2,
        onSelected: onSelected,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text.rich(
            TextSpan(
              style: theme.textTheme.bodySmall,
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.add,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  alignment: PlaceholderAlignment.middle,
                ),
                const TextSpan(text: "  "),
                TextSpan(text: string.addANewBlock),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
