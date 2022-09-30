import 'filter_observer.dart';

class ObserverTag{
  static const TOTAL_ORDER = "total_order";
  static const NEW_ORDER = "new_order";
  static const ONGOING_ORDER = "ongoing_order";
  static const ORDER_HISTORY = "order_history";
}

class FilterSubject {
  final Map<String,FilterObserver> _observers = {};

  void addObserver(FilterObserver observer,String tag){
    if(_observers.containsKey(tag)){
      _observers.remove(tag);
    }
    _observers[tag] = observer;
  }

  void applyBrandsFilter(List<int> ids) {
    _observers.forEach((key, value) {
      value.applyBrandsFilter(ids);
    });
  }

  void applyProviderFilter(List<int> ids) {
    _observers.forEach((key, value) {
      value.applyProviderFilter(ids);
    });
  }

}