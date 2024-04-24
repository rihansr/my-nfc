import 'dart:convert';
import 'package:flutter/material.dart';
import '../../shared/constants.dart';
import '../../services/navigation_service.dart';
import '../../utils/debug.dart';
import '../../utils/extensions.dart';
import '../../shared/strings.dart';
import '../../widgets/dropdown_widget.dart';
import '../../widgets/input_field_widget.dart';
import 'components/block_expansion_tile.dart';

class ContactSettings extends StatefulWidget {
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  const ContactSettings({
    super.key,
    required this.block,
    this.onUpdate,
  });

  @override
  State<ContactSettings> createState() => _ContactSettingsState();
}

class _ContactSettingsState extends State<ContactSettings> {
  late Map<String, dynamic> _data;

  @override
  void initState() {
    _data = Map.from(widget.block['data'] ?? {});
    super.initState();
  }

  update(String key, List value) {
    _data[key] = value;
    widget.block.addEntries([MapEntry('data', _data)]);
    debug.print(json.encode(widget.block));
    widget.onUpdate?.call(widget.block);
  }

  openCustomField(Function(String) onUpdate) => showDialog(
        context: navigator.context,
        builder: (context) {
          TextEditingController controller = TextEditingController();
          TextStyle? buttonStyle = Theme.of(context).textTheme.titleLarge;
          return AlertDialog(
            title: Text(string.customLabelName),
            content: InputField(
              controller: controller,
              autoFocus: true,
              textCapitalization: TextCapitalization.words,
              onAction: (val) {
                String text = val.trim();
                if (text.isNotEmpty) {
                  onUpdate.call(text.trim());
                  Navigator.pop(context);
                }
              },
              margin: const EdgeInsets.only(top: 8),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  String text = controller.text.trim();
                  if (text.isNotEmpty) onUpdate.call(text);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(textStyle: buttonStyle),
                child: Text(string.confirm),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(textStyle: buttonStyle),
                child: Text(string.cancel),
              ),
            ],
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlockExpansionTile.settings(
      widget.block['settings'],
      key: Key('${widget.key}'),
      style: widget.block['style'],
      icon: Icons.group_outlined,
      label: widget.block['label'],
      enableBorder: true,
      onUpdate: (key, entry) {
        widget.block.addEntry(key, entry);
        widget.onUpdate?.call(widget.block);
      },
      onRemove: () => widget.onUpdate?.call({}),
      padding: const EdgeInsets.fromLTRB(12, 0, 2, 0),
      children: _data.entries.map(
        (e) {
          List<Map<String, dynamic>> items = List.from(e.value ?? []);
          List<String> types = e.key.contactLabels;
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              e.key.camelToNormal,
              style: theme.textTheme.bodySmall,
            ),
            subtitle: Column(
              children: [
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    Map<String, dynamic> item = items[i];
                    String label = item['label'] ?? types.first;
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Dropdown<String>(
                                hint: string.selectOne,
                                items: types,
                                value: types.contains(label) ? label : 'custom',
                                margin: const EdgeInsets.only(top: 12),
                                itemBuilder: (item) => Text(
                                  item.capitalizeFirstOfEach,
                                ),
                                selectedItemBuilder: (item) => Text(
                                  (item == 'custom' ? label : item)
                                      .capitalizeFirstOfEach,
                                ),
                                onSelected: (label) {
                                  if (label == 'custom') {
                                    openCustomField((text) {
                                      items[i].addEntries(
                                          [MapEntry('label', text)]);
                                      setState(() => update(e.key, items));
                                    });
                                  } else {
                                    items[i]
                                        .addEntries([MapEntry('label', label)]);
                                    update(e.key, items);
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: theme.iconTheme.color,
                              ),
                              padding: const EdgeInsets.only(top: 12),
                              onPressed: () {
                                items.removeAt(i);
                                setState(() => update(e.key, items));
                              },
                            ),
                          ],
                        ),
                        InputField(
                          controller:
                              TextEditingController(text: item['content']),
                          margin: const EdgeInsets.only(top: 8, right: 18),
                          keyboardType: e.key.keyboardType,
                          padding: e.key == 'phoneNumbers'
                              ? const EdgeInsets.only(right: 8)
                              : const EdgeInsets.fromLTRB(8, 12, 8, 12),
                          prefix: e.key == 'phoneNumbers'
                              ? Dropdown<Map<String, dynamic>>(
                                  isExpanded: false,
                                  borderFocusable: false,
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 9, 4, 9),
                                  margin: const EdgeInsets.all(0),
                                  value: kCountryCodes.firstWhere(
                                    (element) =>
                                        element['code'] == item['prefix'],
                                    orElse: () => kCountryCodes.first,
                                  ),
                                  items: kCountryCodes,
                                  itemBuilder: (value) => Text(
                                    '${value['iso'] ?? ''} ${value['code'] ?? ''}'
                                        .trim(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  selectedItemBuilder: (value) =>
                                      Text(value['code'] ?? ''),
                                  onSelected: (value) {
                                    items[i].addEntries(
                                        [MapEntry('prefix', value?['code'])]);
                                    update(e.key, items);
                                  },
                                )
                              : null,
                          onTyping: (text) {
                            items[i].addEntries(
                              [MapEntry('content', text.isEmpty ? null : text)],
                            );
                            update(e.key, items);
                          },
                        ),
                      ],
                    );
                  },
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(0, 24, 18, 12),
                  ),
                  onPressed: () {
                    items.add({
                      'label': types.first,
                      'prefix': e.key == 'phoneNumbers'
                          ? kCountryCodes.first['code']
                          : null
                    });
                    setState(() => update(e.key, items));
                  },
                  icon: Icon(
                    Icons.add,
                    size: 16,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                  label: Text(
                    string.addANewRow,
                    style: theme.textTheme.titleMedium,
                  ),
                )
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
