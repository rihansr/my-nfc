import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_nfc/widgets/negative_padding.dart';
import '../../../shared/constants.dart';
import '../../../shared/strings.dart';
import '../../../widgets/input_field_widget.dart';

class AspectRatioSelector extends StatefulWidget {
  final String? aspectRatio;
  final Function(String) onSelected;
  const AspectRatioSelector(
    this.aspectRatio, {
    super.key,
    required this.onSelected,
  });

  @override
  State<AspectRatioSelector> createState() => _AspectRatioSelectorState();
}

class _AspectRatioSelectorState extends State<AspectRatioSelector> {
  Timer? _debounce;
  late List<String> _aspectRatios;
  late String _aspectRatio;
  late TextEditingController _widthController;
  late TextEditingController _heightController;

  set selectedAspectRatio(String ratio) => setState(() => _aspectRatio = ratio);

  generateRatio() {
    Object width = _widthController.text.trim();
    Object height = _heightController.text.trim();
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    } else if ('$width'.isEmpty || '$width'.isEmpty) {
      return;
    }
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        width = int.parse('$width').abs();
        height = int.parse('$height').abs();
        if (width == 0 && height == 0) return;
        widget.onSelected.call("$width:$height");
      },
    );
  }

  @override
  void initState() {
    _aspectRatios = List.from(kAspectRatios);
    bool ratioExist = _aspectRatios.contains(widget.aspectRatio);
    _aspectRatios.add(
        widget.aspectRatio == null || ratioExist ? '0:0' : widget.aspectRatio!);

    _aspectRatio = widget.aspectRatio ?? '0:0';
    List<String> splitRatio = _aspectRatio.split(':');
    _widthController =
        TextEditingController(text: ratioExist ? splitRatio[0] : '');
    _heightController =
        TextEditingController(text: ratioExist ? splitRatio[1] : '');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            string.aspectRatio,
            textAlign: TextAlign.start,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          NegativePadding(
            padding: const EdgeInsets.only(left: 12, right: 20),
            child: SizedBox(
              width: double.infinity,
              height: 64,
              child: ListView.separated(
                itemCount: _aspectRatios.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 12, right: 20),
                separatorBuilder: (context, index) => const SizedBox(width: 24),
                itemBuilder: (context, i) {
                  {
                    String ratio = _aspectRatios[i];
                    List<String> splitRatio = ratio.split(':');
                    int width = int.parse(splitRatio[0]);
                    int height = int.parse(splitRatio[1]);
                    bool isCustom = i == (_aspectRatios.length - 1);
                    Color selectedColor = _aspectRatio == ratio
                        ? theme.colorScheme.primary
                        : theme.iconTheme.color!;

                    return InkWell(
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        selectedAspectRatio = ratio;
                        isCustom
                            ? generateRatio()
                            : widget.onSelected.call(ratio);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isCustom)
                            SizedBox.square(
                              dimension: 32,
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: width / height,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: selectedColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (!isCustom) const SizedBox(height: 4),
                          Center(
                            widthFactor: 1,
                            heightFactor: isCustom ? 2 : 1,
                            child: Text(
                              isCustom
                                  ? string.custom
                                  : string.ratio(width, height),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(color: selectedColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          if (_aspectRatio == _aspectRatios.last) ...[
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  string.width,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InputField(
                    controller: _widthController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    margin: const EdgeInsets.all(0),
                    onTyping: (text) => generateRatio(),
                  ),
                ),
                const SizedBox(width: 24),
                Text(
                  string.height,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InputField(
                    controller: _heightController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    margin: const EdgeInsets.all(0),
                    onTyping: (text) => generateRatio(),
                  ),
                ),
                const Spacer(),
              ],
            )
          ]
        ],
      ),
    );
  }
}
