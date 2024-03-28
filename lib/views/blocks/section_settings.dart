import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../../shared/strings.dart';
import '../../shared/constants.dart';
import '../../utils/extensions.dart';
import '../../widgets/popup_button.dart';
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
    _fields = widget.settings['data']?['fields'] ?? [];
    super.initState();
  }

  set fields(List list) {
    _fields = list;
    widget.settings.addEntry('data', MapEntry('fields', _fields));
    widget.onUpdate?.call(widget.settings);
  }

  update(int i, Map<String, dynamic> data) {
    fields = data.isEmpty ? (_fields..removeAt(i)) : (_fields..[i] = data);
    if (data.isEmpty) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = _fields.mapIndexed(
      (i, e) {
        Key key = widget.key != null ? Key('${widget.key}/$i') : Key('$i');
        Map<String, dynamic> blockSettings =
            Map.from(e);
        switch (e['block']) {
          case "section-parent":
          case "section":
            return SectionSettings(
              key: key,
              settings: blockSettings,
              onUpdate: (settings) => update(i, settings),
            );
          case "space":
            return SpaceSettings(
              key: key,
              settings: blockSettings,
              onUpdate: (settings) => update(i, settings),
            );
          case "divider":
            return DividerSettings(
              key: key,
              settings: blockSettings,
              onUpdate: (settings) => update(i, settings),
            );
          case "text":
          case "name":
            return TextSettings(
              key: key,
              settings: blockSettings,
              onUpdate: (settings) => update(i, settings),
            );
          case "banner":
          case "background":
            return BackdropSettings(
              key: key,
              settings: blockSettings,
              onUpdate: (settings) => update(i, settings),
            );
          case "avatar":
          case "image":
            return ImageSettings(
              key: key,
              settings: blockSettings,
              onUpdate: (settings) => update(i, settings),
            );
          case "contact":
            return ContactSettings(
              key: key,
              settings: blockSettings,
              onUpdate: (settings) => update(i, settings),
            );
          case "info":
            return InfoSettings(
              key: key,
              settings: blockSettings,
              onUpdate: (settings) => update(i, settings),
            );
          case "publicLinks":
          case "links":
            return LinksSettings(
              key: key,
              settings: blockSettings,
              onUpdate: (settings) => update(i, settings),
            );
          case "button":
            return ButtonSettings(
              key: key,
              settings: blockSettings,
              onUpdate: (settings) => update(i, settings),
            );
          case "video":
            return VideoSettings(
              key: key,
              settings: blockSettings,
              onUpdate: (settings) => update(i, settings),
            );
          case "additional":
            return AdditionalSettings(
              key: key,
              settings: blockSettings,
              onUpdate: (settings) => update(i, settings),
            );
          case "actions":
            return ActionsSettings(
              key: key,
              settings: blockSettings,
              onUpdate: (settings) => update(i, settings),
            );
          default:
            return SizedBox.shrink(key: key);
        }
      },
    ).toList();

    Widget? footer = _fields.isEmpty ||
            widget.settings['settings']?['primary'] == false
        ? PopupButton(
            items: json.decode(kAdditionalBlocks),
            label: string.addANewBlock,
            icon: (item) => '${item['block']}'.icon,
            name: (item) => item['label'],
            margin: const EdgeInsets.only(left: 4, right: 28),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            onSelected: (item) => setState(() => fields = [..._fields, Map.from(item)]),
          )
        : null;

    return ExpansionSettingsTile(
      widget.settings,
      onUpdate: widget.onUpdate,
      onExpansionChanged: (expanded) {
        if (!expanded) setState(() => {});
      },
      children: [
        if (widget.settings['settings']?['dragable'] == true)
          ReorderableListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            onReorder: (i, j) {
              if (i < j) j--;
              final item = _fields.removeAt(i);
              _fields.insert(j, item);
              setState(() => fields = _fields);
            },
            footer: footer,
            children: children,
          )
        else if (footer != null) ...[
          ...children,
          footer,
        ] else
          ...children,
      ],
    );
  }
}
