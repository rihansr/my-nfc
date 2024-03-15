import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final T model;
  final Widget? child;
  final Function(T)? onInit;
  final Function(T)? onDispose;

  const BaseWidget({
    super.key,
    required this.model,
    required this.builder,
    this.child,
    this.onInit,
    this.onDispose,
  });
  @override
  State<BaseWidget<T>> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends ChangeNotifier> extends State<BaseWidget<T>> {
  late T model;

  @override
  void initState() {
    model = widget.model;
    widget.onInit?.call(model);
    super.initState();
  }

  @override
  void dispose() {
    model = widget.model;
    widget.onDispose?.call(model);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
