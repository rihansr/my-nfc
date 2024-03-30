import 'package:flutter/material.dart';
import '../../../shared/strings.dart';
import '../../../widgets/input_field_widget.dart';
import '../../../widgets/checkbox_widget.dart';
import '../../../widgets/mask_text_field.dart';
import 'expansion_settings_tile.dart';

class VideoConfigs extends StatelessWidget {
  final Map<String, dynamic>? configs;
  final Function(MapEntry<String, dynamic>)? onUpdate;
  const VideoConfigs({
    super.key,
    this.configs,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionSettingsTile(
      label: string.videoSetting,
      titlePadding: const EdgeInsets.all(0),
      padding: const EdgeInsets.fromLTRB(0, 0, 22, 8),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            CheckboxWidget(
              value: configs?['autoPlay'],
              label: string.autoPlay,
              onChanged: (checked) =>
                  onUpdate?.call(MapEntry('autoPlay', checked)),
            ),
            CheckboxWidget(
              value: configs?['loop'],
              label: string.loop,
              onChanged: (checked) => onUpdate?.call(MapEntry('loop', checked)),
            ),
            CheckboxWidget(
              value: configs?['showControls'],
              label: string.showControls,
              onChanged: (checked) =>
                  onUpdate?.call(MapEntry('showControls', checked)),
            ),
            CheckboxWidget(
              value: configs?['mute'],
              label: string.mute,
              onChanged: (checked) => onUpdate?.call(MapEntry('mute', checked)),
            ),
            CheckboxWidget(
              value: configs?['allowFullScreen'],
              label: string.allowFullscreen,
              onChanged: (checked) =>
                  onUpdate?.call(MapEntry('allowFullScreen', checked)),
            ),
            _DurationField(
              string.start,
              duration: configs?['startAt'],
              onAction: (duration) =>
                  onUpdate?.call(MapEntry('startAt', duration)),
            ),
            _DurationField(
              string.end,
              duration: configs?['endAt'],
              onAction: (duration) =>
                  onUpdate?.call(MapEntry('endAt', duration)),
            ),
          ],
        ),
      ],
    );
  }
}

class _DurationField extends StatelessWidget {
  final String label;
  final String? duration;
  final Function(String)? onAction;
  const _DurationField(
    this.label, {
    this.duration,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return RichText(
      text: TextSpan(
        text: label,
        style: theme.textTheme.titleMedium,
        children: [
          const TextSpan(text: ' '),
          WidgetSpan(
            child: SizedBox(
              width: 72,
              child: InputField(
                controller: TextEditingController(text: duration ?? ''),
                maxLines: 1,
                hint: string.durationHint,
                textStyle: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(4),
                onTyping: (value) {
                  if (value.trim().length < 8) return;
                  onAction?.call(value);
                },
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: '##:##:##',
                    filter: {"#": RegExp(r'[0-9]')},
                    type: MaskAutoCompletionType.lazy,
                  ),
                ],
              ),
            ),
            alignment: PlaceholderAlignment.middle,
          )
        ],
      ),
    );
  }
}
