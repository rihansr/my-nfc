import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/extensions.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import 'components.dart';

class ButtonBlock extends StatelessWidget {
  final String path;
  final DashboardViewModel parent;
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  const ButtonBlock(
    this.configs, {
    required this.path,
    required this.parent,
    this.sectionStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final key = parent.key('$path/');

    return Container(
      key: key,
      width: configs['style']?['fullWidth'] == true ? double.infinity : null,
      decoration: BoxDecoration(
        border: parent.isSelected(key) ? selectedBorder : null,
      ),
      transform: transform(configs['style']?['spacing']?['margin']),
      margin: margin(configs['style']?['spacing']?['margin']),
      alignment: configs['style']?['fullWidth'] == true
          ? null
          : alignment(sectionStyle?['alignment']),
      child: TextButton(
        onPressed: openUrl(
            settings: configs['settings']?['advanced'],
            url: configs['data']?['link'] == null
                ? null
                : Uri.parse(configs['data']?['link'])),
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll((() {
            final style =
                Map.from(configs['data']?['style']?['background'] ?? {});
            return style['color'].toString().hexColor;
          }())),
          minimumSize: const WidgetStatePropertyAll(Size.zero),
          padding: WidgetStatePropertyAll(
              padding(configs['style']?['spacing']?['padding'])),
          shape: WidgetStatePropertyAll((() {
            final style = Map.from(configs['data']?['style']?['border'] ?? {});

            return RoundedRectangleBorder(
              side: BorderSide(
                color: style['borderColor']?.toString().hexColor ??
                    Provider.of<DashboardViewModel>(context).theme.iconColor,
                width: style['borderWidth']?.toDouble() ?? 1,
              ),
              borderRadius: BorderRadius.circular(
                style['borderRadius']?.toDouble() ?? 0,
              ),
            );
          }())),
        ),
        child: Text(
          configs['data']?['label']?['text'] ?? '',
          style: textStyle(
            context,
            Map.from(configs['data']?['style']?['text'] ?? {}),
          ).copyWith(
              color: configs['data']?['style']?['text']?['labelColor']
                      ?.toString()
                      .hexColor ??
                  Provider.of<DashboardViewModel>(context).theme.iconColor),
        ),
      ),
    );
  }
}
