import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/extensions.dart';
import '../../shared/strings.dart';
import '../../shared/constants.dart';
import '../../viewmodels/design_viewmodel.dart';
import 'components.dart';

class ActionsBlock extends StatelessWidget {
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  final Map<String, dynamic> settings;
  final Map<String, dynamic> primary;
  final Map<String, dynamic> additional;

  ActionsBlock(this.configs, {this.sectionStyle, super.key})
      : settings =
            Map<String, dynamic>.from(configs['settings']?['advanced'] ?? {}),
        primary = Map<String, dynamic>.from(configs['data']?['primary'] ?? {}),
        additional =
            Map<String, dynamic>.from(configs['data']?['additional'] ?? {});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      minimumSize: const MaterialStatePropertyAll(Size.zero),
      padding: MaterialStatePropertyAll(
          padding(configs['style']?['spacing']?['padding'])),
      shape: const MaterialStatePropertyAll((StadiumBorder())),
    );

    return Container(
      width: double.infinity,
      transform: transform(configs['style']?['spacing']?['margin']),
      margin: margin(configs['style']?['spacing']?['margin']),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (settings['showSaveToPhoneButton'] == true)
            Expanded(
              child: TextButton(
                onPressed: () {
                  DesignViewModel designViewModel =
                      Provider.of<DesignViewModel>(context, listen: false);
                },
                style: buttonStyle.copyWith(
                  backgroundColor: MaterialStatePropertyAll((() {
                    final style = Map<String, dynamic>.from(
                        configs['data']?['style']?['background'] ?? {});
                    return style['color'].toString().hexColor;
                  }())),
                ),
                child: Text(
                  configs['data']?['label']?['text'],
                  style: textStyle(
                    context,
                    Map<String, dynamic>.from(
                        configs['data']?['style']?['text'] ?? {}),
                  ).copyWith(
                      color: configs['data']?['style']?['text']?['labelColor']
                              ?.toString()
                              .hexColor ??
                          Provider.of<DesignViewModel>(context).theme.iconColor,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          if (settings['showPrimaryContactButton'] == true &&
              primary.isNotEmpty)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: settings['showSaveToPhoneButton'] == true ? 8 : 0),
                child: TextButton.icon(
                  onPressed: openUrl(
                    url: Uri.parse(
                        'https://${primary['link'] ?? ''}${primary['id'] ?? ''}'),
                  ),
                  style: buttonStyle.copyWith(
                    backgroundColor: MaterialStatePropertyAll(
                        '${primary['name']}'.socialIconColor),
                  ),
                  icon: Transform.scale(
                    scale: 1.5,
                    child: Icon(
                      '${primary['name']}'.socialIcon,
                      size: (configs['data']?['style']?['text']?['fontSize'] ??
                              14)
                          .toDouble(),
                      color: Colors.white,
                    ),
                  ),
                  label: Text(
                    string.connect,
                    style: textStyle(
                      context,
                      Map.from(configs['data']?['style']?['text'] ?? {}),
                    ).copyWith(
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          if (settings['showAdditionalContactButton'] == true &&
              additional.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                  left: settings['showSaveToPhoneButton'] == true ||
                          (settings['showPrimaryContactButton'] == true &&
                              primary.isNotEmpty)
                      ? 8
                      : 0),
              child: IconButton.filled(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        '${additional['name']}'.socialIconColor)),
                onPressed: openUrl(
                  url: Uri.parse(
                      'https://${additional['link'] ?? ''}${additional['id'] ?? ''}'),
                ),
                padding: const EdgeInsets.all(22),
                icon: Transform.scale(
                  scale: 1.75,
                  child: Icon(
                    '${additional['name']}'.socialIcon,
                    size:
                        (configs['data']?['style']?['text']?['fontSize'] ?? 14)
                            .toDouble(),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
