import 'package:flutter/material.dart';
import 'package:my_nfc/utils/extensions.dart';
import 'package:provider/provider.dart';
import '../../shared/constants.dart';
import '../../models/theme_model.dart';
import '../../viewmodels/design_viewmodel.dart';
import 'components.dart';

class ContactBlock extends StatelessWidget {
  final Map<String, dynamic> configs;
  const ContactBlock(this.configs, {super.key});

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<DesignViewModel>(context).theme;
    return Column(
      children: (configs['data'] as Map).entries.where((element) {
        List items = List.from(element.value ?? []);
        return items.any((element) => element?['content'] != null);
      }).map((entry) {
        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.all(0),
          leading: Icon(
            '${entry.key}'.contactIcon,
            size: 32,
            color: theme.iconColor,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: (entry.value as List)
                .where((element) => element?['content'] != null)
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${e?['label'] ?? 'other'}'.capitalizeFirstOfEach,
                          style: textStyle(
                            context,
                            {'fontWeight': 'regular', 'fontSize': 10},
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text.rich(
                          TextSpan(
                            text:
                                e?['prefix'] != null ? '${e?['prefix']}-' : '',
                            children: [
                              TextSpan(text: e?['content'] ?? ''),
                            ],
                          ),
                          style: textStyle(
                            context,
                            {'fontWeight': 'medium', 'fontSize': 14},
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        );
      }).toList(),
    );
  }
}
