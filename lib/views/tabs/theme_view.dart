import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/constants.dart';
import '../../viewmodels/design_viewmodel.dart';
import '../../widgets/base_widget.dart';
import 'components/popup_view.dart';
import 'components/theme_item.dart';

class ThemeView extends StatelessWidget {
  final DesignViewModel designViewModel;
  final ScrollController scrollController;

  const ThemeView(
    this.designViewModel, {
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BaseWidget<DesignViewModel>(
      model: designViewModel,
      builder: (context, controller, child) => ModalBottomSheet(
        scrollController: scrollController,
        children: [
          SizedBox(
            height: 164,
            width: double.infinity,
            child: ListView.separated(
              itemCount: kThemes.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, i) => const SizedBox(width: 6),
              itemBuilder: (_, i) {
                return ThemeItem(
                  groupValue: kThemes[i],
                  value: controller.theme,
                  onSelected: (theme) => controller.theme = theme,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
