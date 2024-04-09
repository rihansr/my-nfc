import 'package:flutter/material.dart';
import 'package:my_nfc/utils/extensions.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/constants.dart';
import '../../models/theme_model.dart';
import '../../viewmodels/design_viewmodel.dart';
import 'components.dart';

class ContactBlock extends StatelessWidget {
  final Map<String, dynamic> configs;
  const ContactBlock(this.configs, {super.key});

  @override
  Widget build(BuildContext context) {
    ThemeModel defaultTheme = Provider.of<DesignViewModel>(context).theme;
    List entries = (configs['data'] as Map).entries.where((element) {
      List items = List.from(element.value ?? []);
      return items.any((element) => element?['content'] != null);
    }).toList();
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      itemCount: entries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        MapEntry entry = entries[index];
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  '${entry.key}'.contactIcon,
                  size: 32,
                  color: defaultTheme.iconColor,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: (entry.value as List)
                    .where((element) => element?['content'] != null)
                    .map(
                      (e) => GestureDetector(
                        onTap: {
                              'phoneNumbers': () async => await launchUrl(
                                    Uri(
                                      scheme: 'tel',
                                      path:
                                          '${e?['prefix'] ?? ''}-${e?['content'] ?? ''}',
                                    ),
                                  ),
                              'emails': () async => await launchUrl(
                                    Uri(
                                      scheme: 'mailto',
                                      path: e?['content'] ?? '',
                                      queryParameters: {
                                        'subject': '',
                                        'body': ''
                                      },
                                    ),
                                  ),
                              'addresses': () async => await launchUrl(
                                    Uri.https(
                                      'www.google.com',
                                      '/maps/search/',
                                      {
                                        'api': '1',
                                        'query': e?['content'] ?? ''
                                      },
                                    ),
                                  ),
                              'websites': () async => await launchUrl(
                                    Uri.parse('https://${e['content'] ?? ''}'),
                                  )
                            }[entry.key] ??
                            () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${e?['label'] ?? 'other'}'
                                    .capitalizeFirstOfEach,
                                style: textStyle(
                                  context,
                                  {'fontWeight': 'regular', 'fontSize': 10},
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
