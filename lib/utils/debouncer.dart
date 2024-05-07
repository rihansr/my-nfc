import 'dart:async';

class Debouncer {
  final Duration duraction;
  Timer? _timer;

  Debouncer({required this.duraction});

  run(void Function() action) {
    if (_timer != null) _timer?.cancel();
    _timer = Timer(duraction, action);
  }

  dispose() {
    _timer?.cancel();
  }
}
