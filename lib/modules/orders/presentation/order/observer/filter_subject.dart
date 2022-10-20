import 'filter_observer.dart';

class FilterSubject {
  final Map<String,FilterObserver> _observers = {};
  List<int>? _providers;
  List<int>? _brands;
  List<int>? _status;

  void addObserver(FilterObserver observer,String tag){
    if(_observers.containsKey(tag)){
      _observers.remove(tag);
    }
    _observers[tag] = observer;
  }

  void removeObserver(String tag){
    if(_observers.containsKey(tag)){
      _observers.remove(tag);
    }
  }

  List<int>? getBrands() => _brands;

  List<int>? getProviders() => _providers;

  List<int>? getStatus() => _status;

  void setBrands(List<int> brands){
    _brands = brands;
  }

  void setProviders(List<int> providers){
    _providers = providers;
  }
  
 void setStatus(List<int> status){
    _status = status;
  }

  void applyBrandsFilter(List<int> ids) {
    _brands = ids;
    _observers.forEach((key, value) {
      value.applyBrandsFilter(ids);
    });
  }

  void applyProviderFilter(List<int> ids) {
    _providers = ids;
    _observers.forEach((key, value) {
      value.applyProviderFilter(ids);
    });
  }

  void applyStatusFilter(List<int> ids) {
    _status = ids;
    _observers.forEach((key, value) {
      value.applyStatusFilter(ids);
    });
  }

}