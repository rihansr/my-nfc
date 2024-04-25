import 'dart:convert';
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

// ignore: must_be_immutable
class ActionsSettings extends StatelessWidget {
  final Map<String, dynamic>? defaultBlock;
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  final Map<String, dynamic> advancedSettings;
  late Map<String, dynamic>? primary;
  late Map<String, dynamic>? additional;

  ActionsSettings({
    super.key,
    this.defaultBlock,
    required this.block,
    this.onUpdate,
  })  : primary = block['data']?['primary'],
        additional = block['data']?['additional'],
        advancedSettings = Map.from(block['settings']?['advanced'] ?? {});

  update(String key, MapEntry<String, dynamic> value) {
    Map<String, dynamic> settings = Map.from(block);
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
    onUpdate?.call(settings);
  }

  @override
  Widget build(BuildContext context) {
    ThemeModel defaultTheme =
        Provider.of<DesignViewModel>(context, listen: false).theme;
    ThemeData theme = Theme.of(context);
    List<Map<String, dynamic>> links =
        Provider.of<DesignViewModel>(context, listen: true)
            .designStructure
            .findBy('links')
          ..removeWhere((element) => element['id'] == null);

    return BlockExpansionTile.settings(
      block['settings'],
      key: Key('$key'),
      defaultStyle: defaultBlock?['style'],
      style: block['style'],
      icon: Icons.system_update_alt_outlined,
      label: block['label'],
      enableBorder: true,
      onUpdate: (key, entry) {
        block.addEntry(key, entry);
        onUpdate?.call(block);
      },
      onRemove: () => onUpdate?.call({}),
      padding: const EdgeInsets.fromLTRB(12, 0, 22, 12),
      children: [
        ...(() {
          final list = links.map((e) => jsonEncode(e));

          final primary =
              this.primary == null ? null : jsonEncode(this.primary);

          final additional =
              this.additional == null ? null : jsonEncode(this.additional);

          final primaryList = list.where(
              (element) => element != additional || !list.contains(element));

          final additionalList = list.where(
              (element) => element != primary || !list.contains(element));

          Widget dropdownItem(String? val) {
            final item =
                val == null ? null : Map<String, dynamic>.from(jsonDecode(val));
            return Text.rich(
              TextSpan(
                style: theme.textTheme.bodySmall,
                children: [
                  WidgetSpan(
                    child: Icon(
                      item?.icon ?? Icons.remove_circle_outline,
                      size: 16,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    alignment: PlaceholderAlignment.middle,
                  ),
                  const TextSpan(text: "  "),
                  TextSpan(text: item?.label ?? string.none),
                ],
              ),
            );
          }

          return [
            Dropdown<String?>(
              title: string.primaryConnectButton,
              items: [...primaryList, null],
              value: (() {
                if (primary?.isEmpty ?? true) {
                  return null;
                } else {
                  if (primaryList.isEmpty) {
                    this.primary = null;
                    update('data', const MapEntry('primary', null));
                    return null;
                  } else {
                    return primary;
                  }
                }
              }()),
              maintainState: true,
              itemBuilder: dropdownItem,
              onSelected: (data) {
                this.primary = data == null
                    ? null
                    : Map<String, dynamic>.from(jsonDecode(data));
                update('data', MapEntry('primary', this.primary));
              },
            ),
            Dropdown<String?>(
              title: string.additionalConnectButton,
              items: [...additionalList, null],
              value: (() {
                if (additional?.isEmpty ?? true) {
                  return null;
                } else {
                  if (additionalList.isEmpty) {
                    this.additional = null;
                    update('data', const MapEntry('additional', null));
                    return null;
                  } else {
                    return additional;
                  }
                }
              }()),
              maintainState: true,
              itemBuilder: dropdownItem,
              onSelected: (data) {
                this.additional = data == null
                    ? null
                    : Map<String, dynamic>.from(jsonDecode(data));
                update('data', MapEntry('additional', this.additional));
              },
            ),
          ];
        }()),
        BlockExpansionTile(
          label: string.buttonDesign,
          children: [
            ColourPicker(
              title: string.buttonColor,
              value: block['data']?['style']?['background']?['color']
                  ?.toString()
                  .hexColor,
              colors: kColors,
              onPick: (color) =>
                  update('background', MapEntry('color', color.toHex)),
            ),
            ...(() {
              final textStyle = Map<String, dynamic>.from(
                  block['data']?['style']?['text'] ?? {});
              return [
                Dropdown<String?>(
                  title: string.typography,
                  hint: string.selectOne,
                  items: const [null, ...kFontFamilys],
                  value: textStyle['typography'],
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
                  value: textStyle['fontSize'] ?? 16,
                  defaultValue: defaultBlock?['default']?['style']?['text']?['fontSize'],
                  min: 8,
                  max: 96,
                  onChanged: (size) =>
                      update('text', MapEntry('fontSize', size)),
                ),
                ColourPicker(
                  title: string.textColor,
                  value: textStyle['labelColor']?.toString().hexColor ??
                      defaultTheme.iconColor,
                  colors: kColors,
                  onPick: (color) =>
                      update('text', MapEntry('labelColor', color.toHex)),
                ),
                TabWidget(
                  title: string.fontWeight,
                  tabs: kFontWeights,
                  value: textStyle['fontWeight'] ?? 'regular',
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
              ];
            }()),
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
                    advancedSettings.addEntries([MapEntry(e.key, checked)]);
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

extension _MapExtensions on Map {
  IconData get icon =>
      this['name']?.toString().socialIcon ?? Icons.remove_circle_outline;

  String get label => this['name'] == null
      ? string.none
      : '${'${this['name']}'.capitalizeFirstOfEach} - ${this['id'] ?? ''}';
}
