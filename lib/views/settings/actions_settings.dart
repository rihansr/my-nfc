import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/theme_model.dart';
import '../../shared/constants.dart';
import '../../utils/extensions.dart';
import '../../shared/strings.dart';
import '../../viewmodels/design_viewmodel.dart';
import '../../widgets/checkbox_widget.dart';
import '../../widgets/colour_picker_widget.dart';
import '../../widgets/dropdown_widget.dart';
import '../../widgets/seekbar_widget.dart';
import '../../widgets/tab_widget.dart';
import '../blocks/components.dart';
import 'components/block_expansion_tile.dart';

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
  late Map<String, dynamic> advancedSettings;
  late Map<dynamic, dynamic>? primary;
  late Map<dynamic, dynamic>? additional;

  update(String key, MapEntry<String, dynamic> value) {
    Map<String, dynamic> settings = Map.from(widget.block);
    switch (key) {
      case 'data':
      case 'style':
        settings.addEntry(key, value);
      case 'text':
      case 'background':
        settings['data'] ??= {};
        settings['data']['style'] ??= {};
        (settings['data']['style'] as Map<String, dynamic>)
            .addEntry(key, value);
      case 'advanced':
        settings['settings'] ??= {};
        (settings['settings'] as Map<String, dynamic>).addEntry(key, value);
      default:
        settings['data'] ??= {};
        (settings['data'] as Map<String, dynamic>).addEntry(key, value);
    }
    widget.onUpdate?.call(settings);
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
    advancedSettings = Map.from(widget.block['settings']?['advanced'] ?? {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeModel defaultTheme =
        Provider.of<DesignViewModel>(context, listen: false).theme;
    ThemeData theme = Theme.of(context);
    List<Map<dynamic, dynamic>> links = findLinks(
        Provider.of<DesignViewModel>(context, listen: true).designData);

    return BlockExpansionTile.settings(
      widget.block['settings'],
      key: Key('${widget.key}'),
      icon: Icons.system_update_alt_outlined,
      label: widget.block['label'],
      enableBorder: true,
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
                update('data', const MapEntry('primary', null));
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
            update('data', MapEntry('primary', data));
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
                update('data', const MapEntry('additional', null));
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
            update('data', MapEntry('additional', data));
          },
        ),
        BlockExpansionTile(
          label: string.buttonDesign,
          children: [
            ColourPicker(
              title: string.buttonColor,
              value: widget.block['data']?['style']?['background']?['color']
                  ?.toString()
                  .hexColor,
              colors: kColors,
              onPick: (color) =>
                  update('background', MapEntry('color', color.toHex)),
            ),
            Dropdown<String?>(
              title: string.typography,
              hint: string.selectOne,
              items: const [null, ...kFontFamilys],
              value: widget.block['data']?['style']?['text']?['typography'],
              selectedItemBuilder: (item) =>
                  Text(item ?? string.fromThemeSettings),
              itemBuilder: (item) => Text(
                item ?? string.fromThemeSettings,
                style: item == null
                    ? null
                    : GoogleFonts.getFont(
                        item,
                        textStyle: Theme.of(context).textTheme.bodySmall,
                      ),
              ),
              onSelected: (String? font) =>
                  update('text', MapEntry('typography', font)),
            ),
            Seekbar(
              title: string.fontSize,
              value: widget.block['data']?['style']?['text']?['fontSize'] ?? 16,
              min: 8,
              max: 96,
              onChanged: (size) => update('text', MapEntry('fontSize', size)),
            ),
            ColourPicker(
              title: string.textColor,
              value: widget.block['data']?['style']?['text']?['textColor']
                      ?.toString()
                      .hexColor ??
                  defaultTheme.iconColor,
              colors: kColors,
              onPick: (color) =>
                  update('text', MapEntry('textColor', color.toHex)),
            ),
            TabWidget(
              title: string.fontWeight,
              tabs: kFontWeights,
              value:
                  widget.block['data']?['style']?['text']?['fontWeight'] ?? 'regular',
              itemBuilder: (item, isSelected) => Text(
                item,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.dividerColor,
                    fontWeight: fontWeight(item)),
              ),
              onSelect: (weight) =>
                  update('text', MapEntry('fontWeight', weight)),
            ),
          ],
        ),
        BlockExpansionTile(
          label: string.advancedSettings,
          children: advancedSettings.entries
              .map(
                (e) => CheckboxWidget.expand(
                  value: e.value ?? false,
                  label: e.key.camelToNormal,
                  onChanged: (checked) {
                    advancedSettings[e.key] = checked;
                    update('advanced', MapEntry(e.key, checked));
                  },
                ),
              )
              .toList(),
        )
      ],
    );
  }
}
