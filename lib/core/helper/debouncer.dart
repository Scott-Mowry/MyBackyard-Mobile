import 'dart:async';

class Debouncer {
  final int milliseconds;
  var isRunning = false;

  Debouncer({required this.milliseconds});

  Future<T> run<T>(Future<T> Function() action, {T? orElse}) async {
    try {
      if (isRunning) return Future<T>.value(orElse);
      isRunning = true;
      final result = await action();
      return result;
    } finally {
      isRunning = false;
    }
  }
}
