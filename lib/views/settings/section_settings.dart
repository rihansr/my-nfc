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
import 'contact_settings.dart';
import 'divider_settings.dart';
import 'image_settings.dart';
import 'info_settings.dart';
import 'links_settings.dart';
import 'space_settings.dart';
import 'text_settings.dart';
import 'video_settings.dart';

class SectionSettings extends StatefulWidget {
  final Map<String, dynamic>? defaultBlock;
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  const SectionSettings({
    super.key,
    this.defaultBlock,
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

        Map<String, dynamic>? defaultBlock = ((){
          final fields = widget.defaultBlock?['data']?['fields'] ?? [];
          return fields.contains(i) ? Map<String, dynamic>.from(fields[i]) : null;
        }());
        
        Map<String, dynamic> block = Map.from(e);
        switch (e['block']) {
          case "section":
            return SectionSettings(
              key: key,
              defaultBlock: defaultBlock,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "space":
            return SpaceSettings(
              key: key,
              defaultBlock: defaultBlock,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "divider":
            return DividerSettings(
              key: key,
              defaultBlock: defaultBlock,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "text":
            return TextSettings(
              key: key,
              defaultBlock: defaultBlock,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "image":
            return ImageSettings(
              key: key,
              defaultBlock: defaultBlock,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "contact":
            return ContactSettings(
              key: key,
              defaultBlock: defaultBlock,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "info":
            return InfoSettings(
              key: key,
              defaultBlock: defaultBlock,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "links":
            return LinksSettings(
              key: key,
              defaultBlock: defaultBlock,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "button":
            return ButtonSettings(
              key: key,
              defaultBlock: defaultBlock,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "video":
            return VideoSettings(
              key: key,
              defaultBlock: defaultBlock,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "additional":
            return AdditionalSettings(
              key: key,
              defaultBlock: defaultBlock,
              block: block,
              onUpdate: (settings) => update(i, settings),
            );
          case "actions":
            return ActionsSettings(
              key: key,
              defaultBlock: defaultBlock,
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
      defaultStyle: widget.defaultBlock?['style'],
      style: widget.block['style'],
      label: widget.block['label'],
      onUpdate: (key, entry) {
        widget.block.addEntry(key, entry);
        widget.onUpdate?.call(widget.block);
      },
      onRemove: () => widget.onUpdate?.call({}),
      onExpansionChanged: (expanded) {
        if (!expanded) setState(() => {});
      },
      children: [
        if (widget.block['settings']?['dragable'] == true)
          ReorderableListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            buildDefaultDragHandles: true,
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
