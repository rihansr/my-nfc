import 'package:flutter/material.dart';

import '../../../models/theme_model.dart';
import '../../../shared/drawables.dart';
import '../../../shared/strings.dart';
import '../../../widgets/clipper_widget.dart';
import '../../../widgets/vertical_devider.dart';

class ThemeItem extends StatelessWidget {
  final ThemeModel groupValue;
  final ThemeModel value;
  final Function(ThemeModel)? onSelected;
  final bool _isSelected;

  const ThemeItem({
    super.key,
    required this.groupValue,
    required this.value,
    this.onSelected,
  }) : _isSelected = groupValue == value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isSelected ? null : () => onSelected?.call(groupValue),
      child: Clipper(
        width: 140,
        radius: 12,
        shadows: [
          BoxShadow(
            color: _isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.12)
                : Colors.black12,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
        margin: const EdgeInsets.symmetric(vertical: 2),
        border: Border.all(
          color:
              _isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          width: 1,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        gradient: groupValue.background,
        alignment: Alignment.bottomCenter,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    drawable.imagePlaceholder,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 58,
                  ),
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox.square(
                          dimension: 32,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: Theme.of(context).disabledColor,
                              size: 32,
                            ),
                          ),
                        ),
                        LineBreak(
                            size: 5,
                            color: groupValue.textColor,
                            indent: 42,
                            top: 10),
                        LineBreak(
                            size: 2,
                            color: groupValue.textColor,
                            indent: 54,
                            top: 8),
                        LineBreak(
                            size: 2,
                            color: groupValue.textColor,
                            indent: 54,
                            top: 6),
                        LineBreak(
                            top: 6, color: groupValue.dividerColor, bottom: 2),
                        Wrap(
                          spacing: 6,
                          children: List.generate(
                            4,
                            (_) => Icon(
                              Icons.circle_outlined,
                              size: 14,
                              color: groupValue.iconColor,
                            ),
                          ),
                        ),
                        LineBreak(top: 1, color: groupValue.dividerColor),
                        Transform.translate(
                          offset: const Offset(0, 10),
                          child: Wrap(
                            runSpacing: 7,
                            children: List.generate(
                              2,
                              (index) => Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Clipper.rectangle(
                                    color: groupValue.textColor,
                                    width: 8,
                                    height: 5.5,
                                  ),
                                  const Spacer(flex: 1),
                                  Expanded(
                                    flex: 2,
                                    child: Clipper.rectangle(
                                      color: groupValue.textColor,
                                      width: double.infinity,
                                      height: 5.5,
                                    ),
                                  ),
                                  const Spacer(flex: 2),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isSelected)
              Positioned(
                bottom: 18,
                child: Clipper(
                  shape: const StadiumBorder(),
                  color: Colors.black54,
                  padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                  child: Text(
                    string.current,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
