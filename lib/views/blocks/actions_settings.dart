import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/constants.dart';
import '../../utils/extensions.dart';
import '../../shared/strings.dart';
import '../../viewmodels/design_viewmodel.dart';
import '../../widgets/checkbox_widget.dart';
import '../../widgets/dropdown_widget.dart';
import 'components/expansion_settings_tile.dart';

class ActionsSettings extends StatefulWidget {
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  const ActionsSettings({
    super.key,
    required this.block,
    this.onUpdate,
  });

  @override
  State<ActionsSettings> createState() => _ActionsSettingsState();
}

class _ActionsSettingsState extends State<ActionsSettings> {
  late Map<String, dynamic> additionalSettings;
  late Map<dynamic, dynamic>? primary;
  late Map<dynamic, dynamic>? additional;

  update(String key, Map<dynamic, dynamic>? data) {
    widget.block.addEntry('data', MapEntry(key, data));
    widget.onUpdate?.call(widget.block);
  }

  List<Map<dynamic, dynamic>> findLinks(dynamic data) {
    List<Map<dynamic, dynamic>> links = [];

    if (data is Map) {
      data.forEach((key, value) {
        if (key == "links") {
          if (value is List) {
            links.addAll(value
                .where(
                  (item) => links
                      .where((element) =>
                          item['id'] == null || '$element' == '$item')
                      .isEmpty,
                )
                .map((link) => link as Map<dynamic, dynamic>));
          }
        } else {
          links.addAll(findLinks(value));
        }
      });
    } else if (data is List) {
      for (var item in data) {
        links.addAll(findLinks(item));
      }
    }

    return links..removeWhere((element) => element['id'] == null);
  }

  @override
  void initState() {
    primary = widget.block['data']?['primary'];
    additional = widget.block['data']?['additional'];
    additionalSettings =
        Map.from(widget.block['settings']?['additional'] ?? {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Map<dynamic, dynamic>> links = findLinks(
        Provider.of<DesignViewModel>(context, listen: true).designData);

    return ExpansionSettingsTile.settings(
      widget.block['settings'],
      key: Key('${widget.key}'),
      icon: Icons.system_update_alt_outlined,
      label: widget.block['label'],
      enableBoder: true,
      onUpdate: (entry) {
        widget.block.addEntry('settings', entry);
        widget.onUpdate?.call(widget.block);
      },
      onRemove: () => widget.onUpdate?.call({}),
      padding: const EdgeInsets.fromLTRB(12, 0, 22, 12),
      children: [
        Dropdown<Map<dynamic, dynamic>?>(
          title: string.primaryConnectButton,
          items: [...links, null],
          value: (() {
            if (primary == null) {
              return null;
            } else {
              if (links.where((element) => '$element' == '$primary').isEmpty) {
                primary = null;
                update('primary', null);
                return null;
              } else {
                return primary;
              }
            }
          }()),
          maintainState: true,
          itemBuilder: (item) => Text.rich(
            TextSpan(
              style: theme.textTheme.bodySmall,
              children: [
                WidgetSpan(
                  child: Icon(
                    item?['name']?.toString().socialIcon ??
                        Icons.remove_circle_outline,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  alignment: PlaceholderAlignment.middle,
                ),
                const TextSpan(text: "  "),
                TextSpan(
                  text: item?['name'] == null
                      ? string.none
                      : '${'${item!['name']}'.capitalizeFirstOfEach} - ${item['id'] ?? ''}',
                ),
              ],
            ),
          ),
          onSelected: (data) {
            primary = data;
            update('primary', data);
          },
        ),
        Dropdown<Map<dynamic, dynamic>?>(
          title: string.additionalConnectButtons,
          items: [...links, null],
          value: (() {
            if (additional == null) {
              return null;
            } else {
              if (links
                  .where((element) => '$element' == '$additional')
                  .isEmpty) {
                additional = null;
                update('additional', null);
                return null;
              } else {
                return additional;
              }
            }
          }()),
          maintainState: true,
          itemBuilder: (item) => Text.rich(
            TextSpan(
              style: theme.textTheme.bodySmall,
              children: [
                WidgetSpan(
                  child: Icon(
                    item?['name']?.toString().socialIcon ??
                        Icons.remove_circle_outline,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  alignment: PlaceholderAlignment.middle,
                ),
                const TextSpan(text: "  "),
                TextSpan(
                    text: item?['name'] == null
                        ? string.none
                        : '${'${item!['name']}'.capitalizeFirstOfEach} - ${item['id'] ?? ''}'),
              ],
            ),
          ),
          onSelected: (data) {
            additional = data;
            update('additional', data);
          },
        ),
        ExpansionSettingsTile(
          label: string.advancedSettings,
          padding: const EdgeInsets.all(0),
          titlePadding: const EdgeInsets.all(0),
          maintainState: true,
          children: additionalSettings.entries
              .map(
                (e) => CheckboxWidget.expand(
                  value: e.value ?? false,
                  label: e.key.camelToNormal,
                  onChanged: (checked) {
                    additionalSettings[e.key] = checked;
                  },
                ),
              )
              .toList(),
        )
      ],
    );
  }
}
