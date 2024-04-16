import 'package:flutter/material.dart';

class Clipper<T> extends StatelessWidget {
  final Widget? child;
  final T? shape;
  final double? height;
  final double? width;
  final double? size;
  final Color? color;
  final Clip? clipBehavior;
  final double? radius;
  final Matrix4? transform;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadows;
  final Gradient? gradient;
  final DecorationImage? backdrop;
  final Color? overlayColor;
  final double? overlayOpacity;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;

  const Clipper({
    super.key,
    this.child,
    this.shape,
    this.height,
    this.width,
    this.size,
    this.color,
    this.clipBehavior,
    this.radius,
    this.transform,
    this.margin,
    this.padding,
    this.border,
    this.borderRadius,
    this.shadows,
    this.gradient,
    this.backdrop,
    this.overlayColor,
    this.overlayOpacity,
    this.alignment,
    this.constraints,
  });

  const Clipper.rectangle({
    super.key,
    this.child,
    this.height,
    this.width,
    this.size,
    this.color,
    this.clipBehavior,
    this.radius,
    this.transform,
    this.margin,
    this.padding,
    this.border,
    this.borderRadius,
    this.shadows,
    this.gradient,
    this.backdrop,
    this.overlayColor,
    this.overlayOpacity,
    this.alignment,
    this.constraints,
  }) : shape = BoxShape.rectangle as T;

  const Clipper.circle({
    super.key,
    this.child,
    this.height,
    this.width,
    this.size,
    this.color,
    this.clipBehavior,
    this.radius,
    this.transform,
    this.margin,
    this.padding,
    this.border,
    this.shadows,
    this.gradient,
    this.backdrop,
    this.overlayColor,
    this.overlayOpacity,
    this.alignment,
    this.constraints,
  })  : shape = BoxShape.circle as T,
        borderRadius = null;

  const Clipper.square({
    super.key,
    this.child,
    this.size,
    this.shape,
    this.clipBehavior,
    this.color,
    this.radius,
    this.transform,
    this.margin,
    this.padding,
    this.border,
    this.borderRadius,
    this.shadows,
    this.gradient,
    this.backdrop,
    this.overlayColor,
    this.overlayOpacity,
    this.alignment,
    this.constraints,
  })  : height = size,
        width = size;

  const Clipper.expand({
    super.key,
    this.child,
    this.shape,
    this.clipBehavior,
    this.color,
    this.radius,
    this.transform,
    this.margin,
    this.padding,
    this.border,
    this.borderRadius,
    this.shadows,
    this.gradient,
    this.backdrop,
    this.overlayColor,
    this.overlayOpacity,
    this.alignment,
    this.constraints,
  })  : size = double.infinity,
        height = double.infinity,
        width = double.infinity;

  @override
  Widget build(BuildContext context) {
    BorderRadius? kBorderRadius = borderRadius ??
        (radius != null ? BorderRadius.circular(radius!) : null);

    return Container(
      height: height ?? size,
      width: width ?? size,
      transform: transform,
      margin: margin,
      padding: padding,
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      alignment: alignment,
      constraints: constraints,
      foregroundDecoration: overlayColor != null &&
              overlayColor != Colors.transparent
          ? shape == null
              ? BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: kBorderRadius,
                  color: overlayColor?.withOpacity(overlayOpacity ?? 0.0),
                )
              : shape is BoxShape
                  ? BoxDecoration(
                      shape: shape as BoxShape,
                      borderRadius:
                          shape == BoxShape.circle ? null : kBorderRadius,
                      color: overlayColor?.withOpacity(overlayOpacity ?? 0.0),
                    )
                  : ShapeDecoration(
                      shape: shape as ShapeBorder,
                      color: overlayColor?.withOpacity(overlayOpacity ?? 0.0),
                    )
          : null,
      decoration: shape == null
          ? BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: kBorderRadius,
              border: border,
              color: color,
              boxShadow: shadows,
              image: backdrop,
              gradient: gradient,
            )
          : shape is BoxShape
              ? BoxDecoration(
                  shape: shape as BoxShape,
                  borderRadius: shape == BoxShape.circle ? null : kBorderRadius,
                  border: border,
                  color: color,
                  boxShadow: shadows,
                  image: backdrop,
                  gradient: gradient,
                )
              : ShapeDecoration(
                  shape: shape as ShapeBorder,
                  color: color,
                  shadows: shadows,
                  image: backdrop,
                  gradient: gradient,
                ),
      child: child,
    );
  }
}
