import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../../utils/extensions.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import 'components/expansion_settings_tile.dart';
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

class SectionSettings extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  const SectionSettings({
    super.key,
    required this.settings,
    this.onUpdate,
  });

  @override
  State<SectionSettings> createState() => _SectionSettingsState();
}

class _SectionSettingsState extends State<SectionSettings> {
  late List _fields;

  @override
  void initState() {
    _fields = widget.settings['fields'] ?? [];
    super.initState();
  }

  set fields(List list) {
    setState(() => _fields = list);
    widget.onUpdate?.call({...widget.settings, 'fields': list});
  }

  update(int i, Map<String, dynamic> data) => {
        _fields = data.isEmpty ? (_fields..removeAt(i)) : (_fields..[i] = data),
        widget.onUpdate?.call({...widget.settings, 'fields': _fields})
      };

  @override
  Widget build(BuildContext context) {
    return ExpansionSettingsTile(
      widget.settings,
      onUpdate: widget.onUpdate,
      children: [
        ReorderableListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          onReorder: (i, j) {
            if (widget.settings['settings']?['dragable'] != true) return;
            if (i < j) j--;
            final item = _fields.removeAt(i);
            _fields.insert(j, item);
            fields = _fields;
          },
          footer: _fields.isEmpty ||
                  widget.settings['settings']?['primary'] == false
              ? _AddButton(
                  onSelected: (block) {
                    block.addEntry(
                        'settings',
                        MapEntry('dragable',
                            widget.settings['settings']?['dragable'] ?? false));
                    fields = [..._fields, block];
                  },
                )
              : null,
          children: _fields.mapIndexed(
            (i, e) {
              Key key =
                  widget.key != null ? Key('${widget.key}/$i') : Key('$i');
              switch (e['block']) {
                case "section-parent":
                case "section":
                  return SectionSettings(
                    key: key,
                    settings: e,
                    onUpdate: (settings) => update(i, settings),
                  );
                case "space":
                  return SpaceSettings(
                    key: key,
                    settings: e,
                    onUpdate: (settings) => update(i, settings),
                  );
                case "divider":
                  return DividerSettings(
                    key: key,
                    settings: e,
                    onUpdate: (settings) => update(i, settings),
                  );
                case "text":
                case "name":
                  return TextSettings(
                    key: key,
                    settings: e,
                    onUpdate: (settings) => update(i, settings),
                  );
                case "banner":
                case "background":
                  return BackdropSettings(
                    key: key,
                    settings: e,
                    onUpdate: (settings) => update(i, settings),
                  );
                case "avatar":
                case "image":
                  return ImageSettings(
                    key: key,
                    settings: e,
                    onUpdate: (settings) => update(i, settings),
                  );
                case "contact":
                  return ContactSettings(
                    key: key,
                    settings: e,
                    onUpdate: (settings) => update(i, settings),
                  );
                case "info":
                  return InfoSettings(
                    key: key,
                    settings: e,
                    onUpdate: (settings) => update(i, settings),
                  );
                case "publicLinks":
                case "links":
                  return LinksSettings(
                    key: key,
                    settings: e,
                    onUpdate: (settings) => update(i, settings),
                  );
                case "button":
                  return ButtonSettings(
                    key: key,
                    settings: e,
                    onUpdate: (settings) => update(i, settings),
                  );
                case "video":
                  return VideoSettings(
                    key: key,
                    settings: e,
                    onUpdate: (settings) => update(i, settings),
                  );
                case "additional":
                  return AdditionalSettings(
                    key: key,
                    settings: e,
                    onUpdate: (settings) => update(i, settings),
                  );
                case "actions":
                  return ActionsSettings(
                    key: key,
                    settings: e,
                    onUpdate: (settings) => update(i, settings),
                  );
                default:
                  return SizedBox.shrink(key: key);
              }
            },
          ).toList(),
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
          return kAdditionalBlocks
              .mapIndexed(
                (i, e) => PopupMenuItem<Map<String, dynamic>>(
                  value: e,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text.rich(
                    TextSpan(
                      style: theme.textTheme.bodySmall,
                      children: [
                        WidgetSpan(
                          child: Icon(
                            '${e['block']}'.icon,
                            size: 16,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                          alignment: PlaceholderAlignment.middle,
                        ),
                        const TextSpan(text: "  "),
                        TextSpan(text: e['label'] ?? ""),
                      ],
                    ),
                  ),
                ),
              )
              .toList();
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
