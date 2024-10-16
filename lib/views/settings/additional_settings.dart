import 'package:flutter/material.dart';
import '../../shared/constants.dart';
import '../../shared/strings.dart';
import '../../utils/extensions.dart';
import '../../widgets/input_field_widget.dart';
import '../../widgets/tab_widget.dart';
import 'components/block_expansion_tile.dart';

// ignore: must_be_immutable
class AdditionalSettings extends StatelessWidget {
  final String path;
  final Map<String, dynamic>? defaultBlock;
  final Map<String, dynamic> block;
  final Function(Map<String, dynamic>)? onUpdate;

  AdditionalSettings({
    super.key,
    required this.path,
    this.defaultBlock,
    required this.block,
    this.onUpdate,
  }) : fields = ValueNotifier(block['data']?['fields'] ?? []);

  late ValueNotifier<List> fields;

  update(String key, MapEntry<String, dynamic> value) {
    Map<String, dynamic> settings = Map.from(block);
    switch (key) {
      case 'data':
        settings.addEntry(key, value);
      case 'alignment':
        settings.addEntry(key, value);
        settings['data'] ??= {};
        settings['data']['style'] ??= {};
        (settings['data']['style'] as Map<String, dynamic>)
            .addEntry(key, value);
      default:
        settings['data'] ??= {};
        (settings['data'] as Map<String, dynamic>).addEntry(key, value);
    }
    onUpdate?.call(settings);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    
    return BlockExpansionTile.settings(
      block['settings'],
      key: Key('$path/'),
      defaultStyle: defaultBlock?['style'],
      style: block['style'],
      icon: Icons.playlist_add_outlined,
      label: block['label'],
      enableBorder: true,
      padding: const EdgeInsets.fromLTRB(12, 0, 2, 0),
      maintainState: true,
      onUpdate: (key, entry) {
        block.addEntry(key, entry);
        onUpdate?.call(block);
      },
      onRemove: () => onUpdate?.call({}),
      children: [
        TabWidget(
          title: string.alignment,
          tabs: kHorizontalAlignments,
          value: block['data']?['style']?['alignment']?['horizontal'],
          reselectable: true,
          margin: const EdgeInsets.all(12),
          onSelect: (alignment) =>
              update('alignment', MapEntry('horizontal', alignment)),
        ),
        ValueListenableBuilder<List>(
          valueListenable: fields,
          builder: (context, items, _) {
            return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (context, i) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                GlobalKey key = this.key != null
                    ? GlobalKey(debugLabel: '${this.key}/$i')
                    : GlobalKey(debugLabel: '$i');
                Map<dynamic, dynamic> item = items[i];

                return ListTile(
                  key: key,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  minLeadingWidth: 28,
                  horizontalTitleGap: 0,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InputField(
                          controller:
                              TextEditingController(text: item['title']),
                          title: string.title(i + 1),
                          hint: block['data']?['style']?['hints']?['title'],
                          margin: const EdgeInsets.all(0),
                          minLines: 1,
                          maxLines: 2,
                          textCapitalization: TextCapitalization.sentences,
                          onTyping: (value) {
                            items[i].addEntries(
                              [
                                MapEntry('title', value.isEmpty ? null : value),
                              ],
                            );
                            fields.value = items;
                            update('data', MapEntry('fields', items));
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: theme.iconTheme.color,
                        ),
                        padding: const EdgeInsets.only(top: 24),
                        onPressed: () {
                          items.removeAt(i);
                          fields.value = items;
                          update('data', MapEntry('fields', items));
                        },
                      ),
                    ],
                  ),
                  subtitle: InputField(
                    controller:
                        TextEditingController(text: item['description']),
                    title: string.description(i + 1),
                    hint: block['data']?['style']?['hints']?['description'],
                    margin: const EdgeInsets.only(top: 14, right: 12),
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 2,
                    maxLines: 8,
                    onTyping: (value) {
                      items[i].addEntries(
                        [MapEntry('description', value.isEmpty ? null : value)],
                      );
                      fields.value = items;
                      update('data', MapEntry('fields', items));
                    },
                  ),
                );
              },
            );
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () {
              fields.value = [...fields.value, {}];
              update('data', MapEntry('fields', fields.value));
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            ),
            icon: Icon(
              Icons.add,
              size: 16,
              color: theme.iconTheme.color,
            ),
            label: Text(
              string.addANewRow,
              style: theme.textTheme.bodySmall,
            ),
          ),
        )
      ],
    );
  }
}
