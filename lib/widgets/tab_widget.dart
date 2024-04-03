import 'package:flutter/material.dart';
import 'clipper_widget.dart';

class TabWidget extends StatelessWidget {
  final String? title;
  final String? type;
  final TextStyle? titleStyle;
  final TextAlign titleAlign;
  final EdgeInsets titleSpacing;
  final EdgeInsets margin;
  final List<String> tabs;
  final String? value;
  final bool maintainState;
  final bool reselectable;
  final Function(String?)? onSelect;

  TabWidget({
    super.key,
    this.title,
    this.type,
    this.titleStyle,
    this.titleAlign = TextAlign.start,
    this.titleSpacing = const EdgeInsets.only(bottom: 10),
    this.margin = const EdgeInsets.symmetric(vertical: 12),
    this.tabs = const [],
    this.value,
    this.maintainState = true,
    this.reselectable = false,
    this.onSelect,
  }) : _selectedTab = ValueNotifier(value);

  final ValueNotifier<String?> _selectedTab;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title?.trim().isNotEmpty ?? false)
            Padding(
              padding: titleSpacing,
              child: Text(
                title ?? '',
                textAlign: titleAlign,
                style: titleStyle ??
                    theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          maintainState
              ? ValueListenableBuilder(
                  valueListenable: _selectedTab,
                  builder: (_, selectedTab, __) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...tabs.map(
                          (tab) => _TabItem(
                            isSelected: tab == selectedTab,
                            tab: tab,
                            onTap: (tab) {
                              if (reselectable) {
                                _selectedTab.value =
                                    _selectedTab.value == tab ? null : tab;
                              } else if (_selectedTab.value == tab) {
                                return;
                              } else {
                                _selectedTab.value = tab;
                              }
                              onSelect?.call(tab);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...tabs.map(
                      (tab) => _TabItem(
                        isSelected: tab == value,
                        tab: tab,
                        onTap: (tab) {
                          if (reselectable) {
                            onSelect
                                ?.call(_selectedTab.value == tab ? null : tab);
                          } else if (_selectedTab.value == tab) {
                            return;
                          } else {
                            onSelect?.call(tab);
                          }
                        },
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String tab;
  final bool isSelected;
  final Function(String)? onTap;
  const _TabItem({
    required this.tab,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color tint = isSelected ? theme.colorScheme.primary : theme.dividerColor;
    Color inverseTint =
        isSelected ? theme.dividerColor : theme.colorScheme.primary;

    return InkWell(
      radius: 6,
      highlightColor: inverseTint.withOpacity(0.25),
      onTap: () => onTap?.call(tab),
      child: Clipper(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
        border: Border.all(color: tint, width: 1),
        radius: 6,
        child: Text(
          tab,
          style: theme.textTheme.bodySmall?.copyWith(color: tint),
        ),
      ),
    );
  }
}
