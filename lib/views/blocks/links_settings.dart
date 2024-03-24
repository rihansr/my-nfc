import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import '../../utils/debug.dart';
import '../../utils/extensions.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import 'components/expansion_settings_tile.dart';

class LinksSettings extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Function(Map<String, dynamic>)? onUpdate;

  const LinksSettings({
    super.key,
    required this.settings,
    this.onUpdate,
  });

  @override
  State<LinksSettings> createState() => _LinksSettingsState();
}

class _LinksSettingsState extends State<LinksSettings> {
  late List _links;

  @override
  void initState() {
    _links = widget.settings['data']?['links'] ?? [];
    super.initState();
  }

  set links(List list) {
    _links = list;
    widget.settings.addEntry('data', MapEntry('links', list));
    widget.onUpdate?.call(widget.settings);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ExpansionSettingsTile(
      widget.settings,
      maintainState: true,
      icon: Icons.group_outlined,
      enableBoder: true,
      children: [
        ReorderableListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: _links.mapIndexed(
            (i, e) {
              Key key =
                  widget.key != null ? Key('${widget.key}/$i') : Key('$i');
              return ListTile(
                key: key,
                contentPadding: const EdgeInsets.only(right: 12),
                minLeadingWidth: 28,
                horizontalTitleGap: 0,
                title: Theme(
                  data: ThemeData(),
                  child: TextField(
                    controller: TextEditingController(text: e?['id']),
                    onChanged: (value) {
                      _links[i] = {}
                        ..addAll(e)
                        ..addEntries(
                          [
                            MapEntry('id', value.isEmpty ? null : value),
                          ],
                        );
                      links = _links;
                    },
                    maxLines: 1,
                    style: theme.textTheme.bodySmall,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    decoration: InputDecoration(
                      hintText: e['hint'],
                      hintStyle: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          e['link'],
                          maxLines: 1,
                          style: theme.textTheme.bodySmall?.copyWith(
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 8, minHeight: 0),
                      prefixStyle: theme.textTheme.bodySmall,
                      enabledBorder: extension.inputBorder(theme.hintColor),
                      border: extension.inputBorder(theme.hintColor),
                      focusedBorder: extension.inputBorder(theme.primaryColor),
                      contentPadding: const EdgeInsets.fromLTRB(0, 10, 6, 10),
                      isDense: true,
                    ),
                  ),
                ),
                leading: Icon(
                  '${e['name']}'.socialIcon,
                  size: 20,
                  color: theme.iconTheme.color,
                ),
                trailing: SizedBox.square(
                  dimension: 40,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: theme.iconTheme.color,
                    ),
                    onPressed: () {
                      _links.removeAt(i);
                      links = _links;
                      setState(() => {});
                    },
                  ),
                ),
              );
            },
          ).toList(),
          onReorder: (i, j) {
            if (widget.settings['dragable'] != true) return;
            if (i < j) j--;
            final item = _links.removeAt(i);
            _links.insert(j, item);
            links = _links;
            setState(() => {});
          },
        ),
        PopupMenuButton<Map<String, dynamic>>(
          itemBuilder: (context) {
            return kSocialLinks.mapIndexed((index, element) {
              return PopupMenuItem<Map<String, dynamic>>(
                value: element,
                child: Text.rich(
                  TextSpan(
                    style: theme.textTheme.bodySmall,
                    children: [
                      WidgetSpan(
                        child: Icon(
                          '${element['name']}'.socialIcon,
                          size: 16,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                        alignment: PlaceholderAlignment.middle,
                      ),
                      const TextSpan(text: "  "),
                      TextSpan(
                        text: '${element['name']}'.capitalizeFirstOfEach,
                      ),
                    ],
                  ),
                ),
              );
            }).toList();
          },
          color: theme.scaffoldBackgroundColor,
          elevation: 2,
          onSelected: (item) {
            _links.add(item);
            links = _links;
            setState(() => {});
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
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
                  TextSpan(text: string.addANewLink),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
