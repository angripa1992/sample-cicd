import 'filter_observer.dart';

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