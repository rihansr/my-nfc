import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/extensions.dart';
import '../../shared/constants.dart';
import '../../models/theme_model.dart';
import '../../viewmodels/design_viewmodel.dart';
import 'components.dart';

class ContactBlock extends StatelessWidget {
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  const ContactBlock(this.configs, {this.sectionStyle, super.key});

  @override
  Widget build(BuildContext context) {
    ThemeModel defaultTheme = Provider.of<DesignViewModel>(context).theme;
    List entries = (configs['data'] as Map).entries.where((element) {
      List items = List.from(element.value ?? []);
      return items.any((element) => element?['content'] != null);
    }).toList();
    return ListView.separated(
      key: GlobalKey(debugLabel: '$key'),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      itemCount: entries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        MapEntry entry = entries[index];
        return Row(
          children: [
            (() {
              final icon = Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  '${entry.key}'.contactIcon,
                  size: 32,
                  color: defaultTheme.iconColor,
                ),
              );
              return sectionStyle?['fullWidth'] == false
                  ? SizedBox(width: 104, child: icon)
                  : Expanded(flex: 1, child: icon);
            }()),
            Expanded(
              flex: 2,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                runSpacing: 4,
                children: (entry.value as List)
                    .where((element) => element?['content'] != null)
                    .map(
                      (e) => GestureDetector(
                        onTap: {
                          'phoneNumbers': openUrl(
                            url: Uri(
                              scheme: 'tel',
                              path:
                                  '${e?['prefix'] ?? ''}${e?['content'] ?? ''}',
                            ),
                          ),
                          'emails': openUrl(
                            url: Uri(
                              scheme: 'mailto',
                              path: e?['content'] ?? '',
                              queryParameters: {'subject': '', 'body': ''},
                            ),
                          ),
                          'addresses': openUrl(
                            url: Uri.https(
                              'www.google.com',
                              '/maps/search/',
                              {'api': '1', 'query': e?['content'] ?? ''},
                            ),
                          ),
                          'websites': openUrl(
                            url: Uri.parse(e['content']),
                          )
                        }[entry.key],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${e?['label'] ?? 'other'}'.capitalizeFirstOfEach,
                              style: textStyle(
                                context,
                                {'fontWeight': 'regular', 'fontSize': 11},
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text.rich(
                              TextSpan(
                                text: e?['prefix'] != null
                                    ? '${e?['prefix']}-'
                                    : '',
                                children: [
                                  TextSpan(text: e?['content'] ?? ''),
                                ],
                              ),
                              style: textStyle(
                                context,
                                {'fontWeight': 'semi-bold', 'fontSize': 14},
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        );
      },
    );
  }
}
