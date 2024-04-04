import 'package:flutter/material.dart';

class LineBreak extends StatelessWidget {
  final double top;
  final double bottom;
  final double indent;
  final double size;
  final Color color;
  const LineBreak({
    super.key,
    this.top = 0,
    this.bottom = 0,
    this.indent = 6,
    this.size = 1,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: bottom),
      child: Divider(
        height: 1,
        thickness: size,
        indent: indent,
        endIndent: indent,
        color: color,
      ),
    );
  }
}
