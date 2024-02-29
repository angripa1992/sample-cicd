

class NotificationQueue {
  final _queue = <Function>[];
  bool _processing = false;

  void add(Function function) {
    _queue.add(function);
    if (!_processing) {
      _processQueue();
    }
  }

  Future<void> _processQueue() async {
    _processing = true;
    while (_queue.isNotEmpty) {
      final function = _queue.removeAt(0);
      await function();
    }
    _processing = false;
  }
}