import 'package:flutter/material.dart';

class Glassmorphism extends StatelessWidget {
  final Widget child;
  final Color color;
  final BorderRadiusGeometry? borderRadius;
  const Glassmorphism({
    super.key,
    required this.child,
    required this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(.7),
            color.withOpacity(.8),
          ],
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
        ),
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
