import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/extensions.dart';
import '../../shared/strings.dart';
import '../../shared/constants.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../widgets/gradient_picker_widget.dart';
import '../../widgets/colour_picker_widget.dart';
import '../../widgets/dropdown_widget.dart';
import '../../widgets/seekbar_widget.dart';
import 'components/popup_view.dart';
import 'components/theme_item.dart';

class ThemeView extends StatelessWidget {
  final DashboardViewModel parentController;
  final ScrollController? scrollController;

  const ThemeView(
    this.parentController, {
    super.key,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ChangeNotifierProvider<DashboardViewModel>.value(
      value: parentController,
      child: Consumer<DashboardViewModel>(
        builder: (context, controller, _) => (() {
          final children = [
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
                  onSelected: (theme) => controller
                    ..designStructure.modify(
                      {
                        'textColor': theme.textColor.toHex,
                        'borderColor': theme.iconColor.toHex,
                        'labelColor': theme.iconColor.toHex,
                        'dividerColor': theme.dividerColor.toHex,
                      },
                    )
                    ..theme = theme.inheritFrom(controller.theme),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ColourPicker(
              title: string.textColor,
              value: controller.theme.textColor,
              colors: kColors,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              onPick: (color) => controller
                ..designStructure.modify({'textColor': color.toHex})
                ..theme = controller.theme.copyWith(textColor: color),
            ),
            ColourPicker(
              title: string.iconColor,
              value: controller.theme.iconColor,
              colors: kColors,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              onPick: (color) => controller
                ..designStructure.modify(
                  {
                    'borderColor': color.toHex,
                    'labelColor': color.toHex,
                  },
                )
                ..theme = controller.theme.copyWith(iconColor: color),
            ),
            GradientPicker(
              title: string.backgroundColor,
              value: controller.theme.background,
              gradientColors: kThemes.map((e) => e.background).toList(),
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              onPick: (gradient) => controller.theme =
                  controller.theme.copyWith(colors: gradient.colors, stops: gradient.stops),
            ),
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
              value: controller.theme.fontFamily,
              maintainState: false,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              selectedItemBuilder: (item) =>
                  Text(item ?? string.fromThemeSettings),
              itemBuilder: (item) => Text(
                item ?? string.fromThemeSettings,
                style: item == null
                    ? null
                    : GoogleFonts.getFont(
                        item,
                        textStyle: Theme.of(context).textTheme.bodySmall,
                      ),
              ),
              onSelected: (String? font) => controller
                ..designStructure.modify(
                  {
                    'typography': font,
                  },
                )
                ..theme = controller.theme.copyWith(fontFamily: font),
            ),
            ColourPicker(
              title: string.lineBreakColor,
              value: controller.theme.dividerColor,
              colors: kColors,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              onPick: (color) => controller
                ..designStructure.modify(
                  {
                    'dividerColor': color.toHex,
                  },
                )
                ..theme = controller.theme.copyWith(dividerColor: color),
            ),
          ];
          return scrollController != null
              ? ModalBottomSheet(
                  scrollController: scrollController!,
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 16),
                  children: children,
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(0, 32, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
                );
        }()),
      ),
    );
  }
}
