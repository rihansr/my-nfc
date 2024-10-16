import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/theme_model.dart';
import '../../shared/constants.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../widgets/clipper_widget.dart';
import 'components.dart';

class LinksBlock extends StatelessWidget {
  final String path;
  final DashboardViewModel parent;
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  const LinksBlock(
    this.configs, {
    required this.path,
    required this.parent,
    this.sectionStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final key = parent.key('$path/');
    ThemeModel theme = Provider.of<DashboardViewModel>(context).theme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: parent.isSelected(key) ? selectedBorder : null,
      ),
      child: Wrap(
        key: key,
        spacing: 24,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        children: (configs['data']?['links'] as List?)
                ?.where((element) => element['id'] != null)
                .map((link) => GestureDetector(
                      onTap: openUrl(
                        url: Uri.parse(
                            'https://${link['link'] ?? ''}${link['id'] ?? ''}'),
                      ),
                      child: Clipper.circle(
                        border:
                            Border.all(color: theme.iconColor, width: 1),
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          '${link['name']}'.socialIcon,
                          size: 24,
                          color: theme.iconColor,
                        ),
                      ),
                    ))
                .toList() ??
            [],
      ),
    );
  }
}
