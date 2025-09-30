import 'dart:async';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  Future<T> run<T>(Future<T> Function() action, {required T orElse}) async {
    // Cancel the previous timer if it exists
    _timer?.cancel();

    // Create a completer for the result
    final completer = Completer<T>();

    // Start a new timer
    _timer = Timer(Duration(milliseconds: milliseconds), () async {
      try {
        final result = await action();
        if (!completer.isCompleted) {
          completer.complete(result);
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }
    });

    return completer.future;
  }

  void dispose() {
    _timer?.cancel();
  }
}
