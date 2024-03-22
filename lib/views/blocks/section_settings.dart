import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'components/expansion_block_tile.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import 'actions_settings.dart';
import 'additional_settings.dart';
import 'backdrop_settings.dart';
import 'button_settings.dart';
import 'contact_settings.dart';
import 'divider_settings.dart';
import 'image_settings.dart';
import 'info_settings.dart';
import 'links_settings.dart';
import 'space_settings.dart';
import 'text_settings.dart';
import 'video_settings.dart';

class SectionSettings extends StatelessWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  const SectionSettings({
    super.key,
    required this.settings,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    List fields = (settings['fields'] as List?) ?? [];
    return ExpansionBlockTile(
      settings,
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
                      this.key != null ? Key('${this.key}/$i') : Key('$i');
                  switch (e['block']) {
                    case "section":
                      return SectionSettings(
                        key: key,
                        settings: e,
                        onUpdate: (section) {
                          settings['fields'][i] = section;
                          onUpdate?.call(settings);
                        },
                      );
                    case "space":
                      return SpaceSettings(
                        key: key,
                        settings: e,
                        onUpdate: (block) {
                          settings['fields'][i] = block;
                          onUpdate?.call(settings);
                        },
                      );
                    case "divider":
                      return DividerSettings(
                        key: key,
                        settings: e,
                        onUpdate: (block) {
                          settings['fields'][i] = block;
                          onUpdate?.call(settings);
                        },
                      );
                    case "text":
                    case "name":
                      return TextSettings(
                        key: key,
                        settings: e,
                        onUpdate: (block) {
                          settings['fields'][i] = block;
                          onUpdate?.call(settings);
                        },
                      );
                    case "banner":
                    case "background":
                      return BackdropSettings(
                        key: key,
                        settings: e,
                        onUpdate: (block) {
                          settings['fields'][i] = block;
                          onUpdate?.call(settings);
                        },
                      );
                    case "avatar":
                    case "image":
                      return ImageSettings(
                        key: key,
                        settings: e,
                        onUpdate: (block) {
                          settings['fields'][i] = block;
                          onUpdate?.call(settings);
                        },
                      );
                    case "contact":
                      return ContactSettings(
                        key: key,
                        settings: e,
                        onUpdate: (block) {
                          settings['fields'][i] = block;
                          onUpdate?.call(settings);
                        },
                      );
                    case "info":
                      return InfoSettings(
                        key: key,
                        settings: e,
                        onUpdate: (block) {
                          settings['fields'][i] = block;
                          onUpdate?.call(settings);
                        },
                      );
                    case "publicLinks":
                    case "links":
                      return LinksSettings(
                        key: key,
                        settings: e,
                        onUpdate: (block) {
                          settings['fields'][i] = block;
                          onUpdate?.call(settings);
                        },
                      );
                    case "button":
                      return ButtonSettings(
                        key: key,
                        settings: e,
                        onUpdate: (block) {
                          settings['fields'][i] = block;
                          onUpdate?.call(settings);
                        },
                      );
                    case "video":
                      return VideoSettings(
                        key: key,
                        settings: e,
                        onUpdate: (block) {
                          settings['fields'][i] = block;
                          onUpdate?.call(settings);
                        },
                      );
                    case "additional":
                      return AdditionalSettings(
                        key: key,
                        settings: e,
                        onUpdate: (block) {
                          settings['fields'][i] = block;
                          onUpdate?.call(settings);
                        },
                      );
                    case "actions":
                      return ActionsSettings(
                        key: key,
                        settings: e,
                        onUpdate: (block) {
                          settings['fields'][i] = block;
                          onUpdate?.call(settings);
                        },
                      );
                    default:
                      return SizedBox.shrink(key: key);
                  }
                },
              ),
              if (settings['primary'] == false)
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
