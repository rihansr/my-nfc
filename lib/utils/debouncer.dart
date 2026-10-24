import 'dart:async';

class Debouncer {
  final Duration duraction;
  Timer? _timer;

  Debouncer({required this.duraction});

  void run(void Function() action) {
    if (_timer != null) _timer?.cancel();
    _timer = Timer(duraction, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
