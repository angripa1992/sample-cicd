import 'package:klikit/modules/orders/presentation/order/observer/filter_subject.dart';

abstract class FilterObserver {
  FilterSubject? filterSubject;
  void applyProviderFilter(List<int> providersID);
  void applyBrandsFilter(List<int> brandsID);
}