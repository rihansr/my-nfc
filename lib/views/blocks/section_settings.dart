import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'components/expansion_settings_tile.dart';
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

  updateSettings(int i, Map<String, dynamic> data) {
    settings['fields'][i] = data;
    onUpdate?.call(settings);
  }

  @override
  Widget build(BuildContext context) {
    List fields = (settings['fields'] as List?) ?? [];
    return ExpansionSettingsTile(
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
                          onUpdate: (settings) => updateSettings(i, settings));
                    case "space":
                      return SpaceSettings(
                        key: key,
                        settings: e,
                        onUpdate: (settings) => updateSettings(i, settings),
                      );
                    case "divider":
                      return DividerSettings(
                        key: key,
                        settings: e,
                        onUpdate: (settings) => updateSettings(i, settings),
                      );
                    case "text":
                    case "name":
                      return TextSettings(
                        key: key,
                        settings: e,
                        onUpdate: (settings) => updateSettings(i, settings),
                      );
                    case "banner":
                    case "background":
                      return BackdropSettings(
                        key: key,
                        settings: e,
                        onUpdate: (settings) => updateSettings(i, settings),
                      );
                    case "avatar":
                    case "image":
                      return ImageSettings(
                        key: key,
                        settings: e,
                        onUpdate: (settings) => updateSettings(i, settings),
                      );
                    case "contact":
                      return ContactSettings(
                        key: key,
                        settings: e,
                        onUpdate: (settings) => updateSettings(i, settings),
                      );
                    case "info":
                      return InfoSettings(
                        key: key,
                        settings: e,
                        onUpdate: (settings) => updateSettings(i, settings),
                      );
                    case "publicLinks":
                    case "links":
                      return LinksSettings(
                        key: key,
                        settings: e,
                        onUpdate: (settings) => updateSettings(i, settings),
                      );
                    case "button":
                      return ButtonSettings(
                        key: key,
                        settings: e,
                        onUpdate: (settings) => updateSettings(i, settings),
                      );
                    case "video":
                      return VideoSettings(
                        key: key,
                        settings: e,
                        onUpdate: (settings) => updateSettings(i, settings),
                      );
                    case "additional":
                      return AdditionalSettings(
                        key: key,
                        settings: e,
                        onUpdate: (settings) => updateSettings(i, settings),
                      );
                    case "actions":
                      return ActionsSettings(
                        key: key,
                        settings: e,
                        onUpdate: (settings) => updateSettings(i, settings),
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
                        '${element['block']}'.icon,
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
