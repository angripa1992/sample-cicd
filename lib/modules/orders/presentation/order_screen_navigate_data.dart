class OrderScreenNavigateDataHandler {
  static final _instance = OrderScreenNavigateDataHandler._internal();
  static Map<String, dynamic>? _navData;

  factory OrderScreenNavigateDataHandler() => _instance;

  OrderScreenNavigateDataHandler._internal();

  void setData(Map<String, dynamic>? data) {
    _navData = data;
  }

  Map<String, dynamic>? getData() {
    return _navData;
  }

  void clearData() {
    _navData = null;
  }
}
