import 'package:klikit/core/widgets/filter/filter_data.dart';

abstract class FilterObserver {
  void applyFilter(OniFilteredData? filteredData);
}

class OniFilterManager {
  final Map<String, FilterObserver> _observers = {};
  OniFilteredData? _oniFilteredData;

  void addObserver(FilterObserver observer, String tag) {
    if (_observers.containsKey(tag)) {
      _observers.remove(tag);
    }
    _observers[tag] = observer;
  }

  void removeObserver(String tag) {
    if (_observers.containsKey(tag)) {
      _observers.remove(tag);
    }
  }

  OniFilteredData? filteredData() => _oniFilteredData;

  void setFilterData(OniFilteredData? data) {
    _oniFilteredData = data;
  }

  void applyFilter(OniFilteredData? data) {
    _oniFilteredData = data;
    _observers.forEach((key, value) {
      value.applyFilter(data);
    });
  }
}
