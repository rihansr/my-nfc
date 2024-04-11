import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../../shared/strings.dart';
import '../../shared/constants.dart';
import '../../utils/extensions.dart';
import '../../widgets/popup_button.dart';
import 'components/block_expansion_tile.dart';
import 'actions_settings.dart';
import 'additional_settings.dart';
import 'button_settings.dart';
import 'components/block_style.dart';
import 'contact_settings.dart';
import 'divider_settings.dart';
import 'image_settings.dart';
import 'info_settings.dart';
import 'links_settings.dart';
import 'space_settings.dart';
import 'text_settings.dart';
import 'video_settings.dart';

class SectionSettings extends StatefulWidget {
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  const SectionSettings({
    super.key,
    required this.block,
    this.onUpdate,
  });

  @override
  State<SectionSettings> createState() => _SectionSettingsState();
}

class _SectionSettingsState extends State<SectionSettings> {
  late List _fields;

  @override
  void initState() {
    _fields = widget.block['data']?['fields'] ?? [];
    super.initState();
  }

  set fields(List list) {
    _fields = list;
    widget.block.addEntry('data', MapEntry('fields', _fields));
    widget.onUpdate?.call(widget.block);
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
        Map<String, dynamic> block = Map.from(e);
        switch (e['block']) {
          case "section":
          case "section-secure":
            return SectionSettings(
              key: key,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "space":
            return SpaceSettings(
              key: key,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "divider":
            return DividerSettings(
              key: key,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "text":
          case "name":
            return TextSettings(
              key: key,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "avatar":
          case "image":
            return ImageSettings(
              key: key,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "contact":
            return ContactSettings(
              key: key,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "info":
            return InfoSettings(
              key: key,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "links-public":
          case "links":
            return LinksSettings(
              key: key,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "button":
            return ButtonSettings(
              key: key,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "video":
            return VideoSettings(
              key: key,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "additional":
            return AdditionalSettings(
              key: key,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "actions":
            return ActionsSettings(
              key: key,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          default:
            return SizedBox.shrink(key: key);
        }
      },
    ).toList();

    Widget? footer = _fields.isEmpty ||
            widget.block['settings']?['primary'] == false
        ? PopupButton(
            items: json.decode(kAdditionalBlocks),
            label: string.addANewBlock,
            icon: (item) => '${item['block']}'.icon,
            name: (item) => item['label'],
            margin: const EdgeInsets.only(left: 4, right: 28),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            onSelected: (item) =>
                setState(() => fields = [..._fields, Map.from(item)]),
          )
        : null;

    return BlockExpansionTile.settings(
      widget.block['settings'],
      key: Key('${widget.key}'),
      label: widget.block['label'],
      onUpdate: (entry) {
        widget.block.addEntry('settings', entry);
        widget.onUpdate?.call(widget.block);
      },
      onRemove: () => widget.onUpdate?.call({}),
      onExpansionChanged: (expanded) {
        if (!expanded) setState(() => {});
      },
      child: widget.block.containsKey('style') || widget.block['settings']?['advanced'] != null
          ? BlockStyle(
              widget.block['style'],
              settings: widget.block['settings']?['advanced'],
              onUpdate: (settings) {
                widget.block['style'] = settings;
                widget.onUpdate?.call(widget.block);
              },
              onSettingsUpdate: (settings) {
                widget.block
                    .addEntry('settings', MapEntry('advanced', settings));
                widget.onUpdate?.call(widget.block);
              },
            )
          : null,
      children: [
        if (widget.block['settings']?['dragable'] == true)
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
