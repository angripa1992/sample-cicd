import 'filter_subject.dart';

abstract class FilterObserver {
  FilterSubject? filterSubject;

  void applyProviderFilter(List<int> providersID);

  void applyBrandsFilter(List<int> brandsID);

  void applyStatusFilter(List<int> status);
}