import 'package:flutter/material.dart';
import 'package:my_nfc/viewmodels/design_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../utils/extensions.dart';
import 'components.dart';

class ButtonBlock extends StatelessWidget {
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  const ButtonBlock(this.configs, {this.sectionStyle, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: configs['style']?['fullWidth'] == true ? double.infinity : null,
      transform: transform(configs['style']?['spacing']?['margin']),
      margin: margin(configs['style']?['spacing']?['margin']),
      alignment: configs['style']?['fullWidth'] == true
          ? null
          : alignment(sectionStyle?['alignment']),
      child: TextButton(
        onPressed: launchUrl(
            settings: configs['settings']?['advanced'],
            url: configs['data']?['link'] == null
                ? null
                : Uri.parse(configs['data']?['link'])),
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll((() {
            final style =
                Map.from(configs['data']?['style']?['background'] ?? {});
            return style['color'].toString().hexColor;
          }())),
          minimumSize: const MaterialStatePropertyAll(Size.zero),
          padding: MaterialStatePropertyAll(
              padding(configs['style']?['spacing']?['padding'])),
          shape: MaterialStatePropertyAll((() {
            final style = Map.from(configs['data']?['style']?['border'] ?? {});

            return RoundedRectangleBorder(
              side: BorderSide(
                color: style['borderColor']?.toString().hexColor ??
                    Provider.of<DesignViewModel>(context).theme.iconColor,
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
          style: textStyle(context, Map.from(configs['data']?['style']?['text'] ?? {})),
        ),
      ),
    );
  }
}
