import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/theme_model.dart';
import '../../utils/extensions.dart';
import '../../shared/constants.dart';
import '../../viewmodels/design_viewmodel.dart';
import '../../widgets/clipper_widget.dart';
import 'components.dart';

class ActionsBlock extends StatelessWidget {
  final Map<String, dynamic>? sectionStyle;
  final Map<String, dynamic> configs;
  const ActionsBlock(this.configs, {this.sectionStyle, super.key});

  @override
  Widget build(BuildContext context) {
    ThemeModel theme = Provider.of<DesignViewModel>(context).theme;
    return Container(
      width: double.infinity,
      transform: transform(configs['style']?['spacing']?['margin']),
      margin: margin(configs['style']?['spacing']?['margin']),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {},
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
                  final style =
                      Map.from(configs['data']?['style']?['border'] ?? {});

                  return RoundedRectangleBorder(
                    side: BorderSide(
                      color: style['borderColor']?.toString().hexColor ??
                          theme.iconColor,
                      width: style['borderWidth']?.toDouble() ?? 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      style['borderRadius']?.toDouble() ?? 0,
                    ),
                  );
                }())),
              ),
              child: Text(
                'Button',
                style: textStyle(
                  context,
                  Map.from(configs['data']?['style']?['text'] ?? {}),
                  orElse: TextStyle(
                    color: configs['data']?['style']?['text']?['labelColor']
                            ?.toString()
                            .hexColor ??
                        Provider.of<DesignViewModel>(context).theme.iconColor,
                  ),
                ),
              ),
            ),
          ),
          ...[configs['data']?['primary'], configs['data']?['additional']]
              .where((element) => element != null)
              .map((link) => GestureDetector(
                    onTap: launchUrl(
                      url: Uri.parse(
                          'https://${link['link'] ?? ''}${link['id'] ?? ''}'),
                    ),
                    child: Clipper.circle(
                      border: Border.all(color: theme.iconColor, width: 1),
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        '${link['name']}'.socialIcon,
                        size: 24,
                        color: theme.iconColor,
                      ),
                    ),
                  ))
        ],
      ),
    );
  }
}
