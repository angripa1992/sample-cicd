import 'package:dio/dio.dart';

import '../../../app/session_manager.dart';
import '../domain/entities/provider.dart';
import '../domain/repository/orders_repository.dart';

class AggregatorProvider {
  final OrderRepository _orderRepository;
  List<Provider> _providers = [];

  AggregatorProvider(this._orderRepository);

  Future<List<Provider>> fetchProviders() async {
    if (_providers.isEmpty) {
      final ids = ListParam<int>(
        SessionManager().currentUser().countryIds,
        ListFormat.csv,
      );
      final response =
          await _orderRepository.fetchProvider({"filterByCountry": ids});
      if (response.isRight()) {
        final data = response.getOrElse(() => []);
        _providers = data;
        return _providers;
      } else {
        return [];
      }
    } else {
      return _providers;
    }
  }

  Future<List<int>> findProvidersIds() async {
    if (_providers.isEmpty) {
      final providers = await fetchProviders();
      return extractProvidersIds(providers);
    } else {
      return extractProvidersIds(_providers);
    }
  }

  Future<Provider> findProviderById(int id) async {
    if (_providers.isEmpty) {
      final providers = await fetchProviders();
      _providers = providers;
      return extractProviderById(providers, id);
    } else {
      return extractProviderById(_providers, id);
    }
  }

  Future<List<int>> extractProvidersIds(List<Provider> providers) async {
    final ids = <int>[];
    for (var provider in providers) {
      ids.add(provider.id);
    }
    return ids;
  }

  Future<Provider> extractProviderById(List<Provider> providers, int id) async {
    return providers.firstWhere((element) => element.id == id);
  }

  void clear() {
    _providers.clear();
  }
}
