import 'package:flutter/material.dart';
import 'clipper_widget.dart';

class TabWidget extends StatefulWidget {
  final String? title;
  final String? type;
  final TextStyle? titleStyle;
  final TextAlign titleAlign;
  final EdgeInsets titleSpacing;
  final EdgeInsets margin;
  final List<String> tabs;
  final String? value;
  final Function(String)? onSelect;

  const TabWidget({
    super.key,
    this.title,
    this.type,
    this.titleStyle,
    this.titleAlign = TextAlign.start,
    this.titleSpacing = const EdgeInsets.only(bottom: 10),
    this.margin = const EdgeInsets.symmetric(vertical: 12),
    this.tabs = const [],
    this.value,
    this.onSelect,
  });

  @override
  State<TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> {
  late String? _selectedTab;

  @override
  void initState() {
    _selectedTab = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title?.trim().isNotEmpty ?? false)
            Padding(
              padding: widget.titleSpacing,
              child: Text(
                widget.title ?? '',
                textAlign: widget.titleAlign,
                style: widget.titleStyle ??
                    theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...widget.tabs.map(
                (tab) => _TabItem(
                  isSelected: tab == _selectedTab,
                  tab: tab,
                  onTap: (tab) {
                    setState(() => _selectedTab = tab);
                    widget.onSelect?.call(tab);
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
