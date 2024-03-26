import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../../utils/extensions.dart';
import 'components/add_block_button.dart';
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
    return ExpansionSettingsTile(
      settings,
      onUpdate: onUpdate,
      maintainState: settings['block'] != 'section-parent',
      children: [
        _FieldsWidget(
          settings: settings,
          onUpdate: (list) {
            Map<String, dynamic> data = Map.from(settings);
            data.addEntry('data', MapEntry('fields', list));
            onUpdate?.call(data);
          },
        ),
      ],
    );
  }
}

class _FieldsWidget extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Function(List)? onUpdate;
  const _FieldsWidget({
    required this.settings,
    this.onUpdate,
  });

  @override
  State<_FieldsWidget> createState() => __FieldsWidgetState();
}

class __FieldsWidgetState extends State<_FieldsWidget> {
  late List _fields;

  @override
  void initState() {
    _fields = widget.settings['data']?['fields'] ?? [];
    super.initState();
  }

  set fields(List list) {
    setState(() => _fields = list);
    widget.onUpdate?.call(_fields);
  }

  update(int i, Map<String, dynamic> data) {
    _fields = data.isEmpty ? (_fields..removeAt(i)) : (_fields..[i] = data);
    if (data.isEmpty) setState(() => {});
    widget.onUpdate?.call(_fields);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = _fields.mapIndexed(
      (i, e) {
        Key key = widget.key != null ? Key('${widget.key}/$i') : Key('$i');
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
    ).toList();
    Widget? footer =
        _fields.isEmpty || widget.settings['settings']?['primary'] == false
            ? AddBlockButton(
                onSelected: (block) {
                  block.addEntry(
                      'settings',
                      MapEntry('dragable',
                          widget.settings['settings']?['dragable'] ?? false));
                  fields = [..._fields, block];
                },
              )
            : null;
    return widget.settings['settings']?['dragable'] == true
        ? ReorderableListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            onReorder: (i, j) {
              if (i < j) j--;
              final item = _fields.removeAt(i);
              _fields.insert(j, item);
              fields = _fields;
            },
            footer: footer,
            children: children,
          )
        : ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              ...children,
              footer ?? const SizedBox.shrink(),
            ],
          );
  }
}
