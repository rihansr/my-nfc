import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import '../../shared/styles.dart';
import '../../utils/extensions.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import '../../widgets/popup_button.dart';
import 'components/block_expansion_tile.dart';

class LinksSettings extends StatefulWidget {
  final Map<String, dynamic>? defaultBlock;
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  const LinksSettings({
    super.key,
    this.defaultBlock,
    required this.block,
    this.onUpdate,
  });

  @override
  State<LinksSettings> createState() => _LinksSettingsState();
}

class _LinksSettingsState extends State<LinksSettings> {
  late List _links;

  @override
  void initState() {
    _links = widget.block['data']?['links'] ?? [];
    super.initState();
  }

  set links(List list) {
    _links = list;
    widget.block.addEntry('data', MapEntry('links', list));
    widget.onUpdate?.call(widget.block);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlockExpansionTile.settings(
      widget.block['settings'],
      key: GlobalKey(debugLabel: '${widget.key}'),
      defaultStyle: widget.defaultBlock?['style'],
      style: widget.block['style'],
      icon: Icons.group_outlined,
      label: widget.block['label'],
      enableBorder: true,
      onUpdate: (key, entry) {
        widget.block.addEntry(key, entry);
        widget.onUpdate?.call(widget.block);
      },
      onRemove: () => widget.onUpdate?.call({}),
      children: [
        (() {
          var children = _links.mapIndexed(
            (i, e) {
              Key key =
                  widget.key != null ? GlobalKey(debugLabel:  '${widget.key}/$i') : GlobalKey(debugLabel:  '$i');
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
                      enabledBorder: style.inputBorder(theme.hintColor),
                      border: style.inputBorder(theme.hintColor),
                      focusedBorder: style.inputBorder(theme.primaryColor),
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
          ).toList();

          return widget.block['settings']?['dragable'] == true
              ? ReorderableListView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  buildDefaultDragHandles: true,
                  shrinkWrap: true,
                  children: children,
                  onReorder: (i, j) {
                    if (widget.block['settings']?['dragable'] != true) return;
                    if (i < j) j--;
                    final item = _links.removeAt(i);
                    _links.insert(j, item);
                    links = _links;
                    setState(() => {});
                  },
                )
              : ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  children: children,
                );
        }()),
        PopupButton(
          items: json.decode(kSocialLinks),
          label: string.addANewLink,
          icon: (item) => '${item['name']}'.socialIcon,
          name: (item) => '${item['name']}'.capitalizeFirstOfEach,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          onSelected: (item) {
            _links.add(item);
            links = _links;
            setState(() => {});
          },
        ),
      ],
    );
  }
}
