import 'dart:async';

class Throttler {
  Throttler({required this.duration, required this.callback});

  final Duration duration;
  Timer? _timer;
  bool _isThrottling = false;

  void Function() callback;

  void run() {
    if (_isThrottling) {
      return;
    }

    callback();
    _isThrottling = true;

    _timer = Timer(duration, () {
      _isThrottling = false;
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}
