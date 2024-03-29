import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_nfc/services/navigation_service.dart';
import 'package:my_nfc/shared/constants.dart';
import 'package:my_nfc/utils/extensions.dart';
import 'package:provider/provider.dart';
import '../../shared/strings.dart';
import '../../widgets/checkbox_widget.dart';
import '../../widgets/dropdown_widget.dart';
import 'components/expansion_settings_tile.dart';

class ActionsSettings extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  const ActionsSettings({
    super.key,
    required this.settings,
    this.onUpdate,
  });

  @override
  State<ActionsSettings> createState() => _ActionsSettingsState();
}

class _ActionsSettingsState extends State<ActionsSettings> {
  late Map<String, dynamic> additionalSettings;
  late List<Map<String, dynamic>> socialLinks;

  @override
  void initState() {
    Map<String, dynamic> data = Provider.of<Map<String, dynamic>>(navigator.context, listen: false);
    socialLinks = [];
    additionalSettings =
        Map.from(widget.settings['data']?['advancedSettings'] ?? {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ExpansionSettingsTile(
      widget.settings,
      icon: Icons.system_update_alt_outlined,
      onUpdate: widget.onUpdate,
      padding: const EdgeInsets.fromLTRB(12, 0, 22, 12),
      enableBoder: true,
      children: [
        Dropdown<Map<String, dynamic>>(
          title: string.primaryConnectButton,
          items: [...socialLinks, const {}],
          value: const {},
          maintainState: true,
          itemBuilder: (item) => Text.rich(
            TextSpan(
              style: theme.textTheme.bodySmall,
              children: [
                WidgetSpan(
                  child: Icon(
                    item['name']?.toString().socialIcon ??
                        Icons.remove_circle_outline,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  alignment: PlaceholderAlignment.middle,
                ),
                const TextSpan(text: "  "),
                TextSpan(
                  text: item['name'] == null
                      ? string.none
                      : '${'${item['name']}'.capitalizeFirstOfEach} - ${item['id'] ?? ''}',
                ),
              ],
            ),
          ),
          onSelected: (data) {},
        ),
        Dropdown<Map<String, dynamic>>(
          title: string.additionalConnectButtons,
          items: [...json.decode(kSocialLinks), const {}],
          value: const {},
          maintainState: true,
          itemBuilder: (item) => Text.rich(
            TextSpan(
              style: theme.textTheme.bodySmall,
              children: [
                WidgetSpan(
                  child: Icon(
                    item['name']?.toString().socialIcon ??
                        Icons.remove_circle_outline,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  alignment: PlaceholderAlignment.middle,
                ),
                const TextSpan(text: "  "),
                TextSpan(
                    text: item['name'] == null
                        ? string.none
                        : '${'${item['name']}'.capitalizeFirstOfEach} - ${item['id'] ?? ''}'),
              ],
            ),
          ),
          onSelected: (data) {},
        ),
        ExpansionSettingsTile(
          {'label': string.advancedSettings},
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
