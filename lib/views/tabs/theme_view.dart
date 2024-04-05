import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/extensions.dart';
import '../../shared/strings.dart';
import '../../shared/constants.dart';
import '../../viewmodels/design_viewmodel.dart';
import '../../widgets/clipper_widget.dart';
import '../../widgets/colour_picker_widget.dart';
import '../../widgets/dropdown_widget.dart';
import '../../widgets/seekbar_widget.dart';
import 'components/popup_view.dart';
import 'components/theme_item.dart';

class ThemeView extends StatelessWidget {
  final DesignViewModel parentController;
  final ScrollController scrollController;

  const ThemeView(
    this.parentController, {
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ChangeNotifierProvider<DesignViewModel>.value(
      value: parentController,
      child: Consumer<DesignViewModel>(
        builder: (context, controller, _) => ModalBottomSheet(
          scrollController: scrollController,
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                string.theme,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 164,
              width: double.infinity,
              child: ListView.separated(
                itemCount: kThemes.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                separatorBuilder: (_, i) => const SizedBox(width: 10),
                itemBuilder: (_, i) => ThemeItem(
                  groupValue: kThemes[i],
                  value: controller.theme,
                  onSelected: (theme) {
                    controller.designData.modify({
                      'textColor': theme.textColor.toHex,
                      'borderColor': theme.iconColor.toHex,
                      'dividerColor': theme.dividerColor.toHex,
                      'typography': theme.typography,
                    });
                    controller.theme = theme.inheritFrom(controller.theme);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            ColourPicker(
              title: string.textColor,
              value: controller.theme.textColor,
              colors: kColors,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              onPick: (color) {
                controller.designData.modify({'textColor': color.toHex});
                controller.theme = controller.theme.copyWith(textColor: color);
              },
            ),
            ColourPicker(
              title: string.iconColor,
              value: controller.theme.iconColor,
              colors: kColors,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              onPick: (color) {
                controller.designData.modify({'borderColor': color.toHex});
                controller.theme = controller.theme.copyWith(iconColor: color);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                string.theme,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kThemes.map(
                  (theme) {
                    bool isSelected =
                        controller.theme.background == theme.background;
                    return InkWell(
                      radius: 34,
                      onTap: () => controller.theme = controller.theme
                          .copyWith(background: theme.background),
                      child: Clipper.circle(
                        gradient: theme.background,
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).disabledColor,
                          width: 2,
                          strokeAlign: isSelected
                              ? BorderSide.strokeAlignOutside
                              : BorderSide.strokeAlignInside,
                        ),
                        size: 34,
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Seekbar(
              title: string.horizontalPadding,
              type: 'px',
              defaultValue: 20,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              value: controller.theme.horizontalPadding,
              maintainState: false,
              onChanged: (val) => controller.theme =
                  controller.theme.copyWith(horizontalPadding: val.toDouble()),
            ),
            Dropdown<String?>(
              title: string.typography,
              hint: string.selectOne,
              items: kFontFamilys,
              value: controller.theme.typography,
              maintainState: false,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              itemBuilder: (item) =>
                  Text(item?.replaceAll('_', ' ') ?? string.fromThemeSettings),
              onSelected: (String? font) {
                controller.designData.modify({'typography': font});
                controller.theme = controller.theme.copyWith(fontFamily: font);
              },
            ),
            ColourPicker(
              title: string.lineBreakColor,
              value: controller.theme.iconColor,
              colors: kColors,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              onPick: (color) {
                controller.designData.modify({'dividerColor': color.toHex});
                controller.theme =
                    controller.theme.copyWith(dividerColor: color);
              },
            ),
          ],
        ),
      ),
    );
  }
}
