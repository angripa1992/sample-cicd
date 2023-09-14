import 'package:dio/dio.dart';
import 'package:klikit/app/extensions.dart';

import '../../../app/session_manager.dart';
import '../domain/entities/provider.dart';
import '../domain/repository/order_info_provider_repo.dart';

class AggregatorProvider {
  final OrderInfoProviderRepo _orderRepository;
  final _emptyProvider = Provider(ZERO, EMPTY, EMPTY, EMPTY);
  List<Provider> _providers = [];

  AggregatorProvider(this._orderRepository);

  Future<List<Provider>> fetchProviders() async {
    if (_providers.isEmpty) {
      final ids = ListParam<int>(
        SessionManager().user()!.countryIds,
        ListFormat.csv,
      );
      final response = await _orderRepository.fetchProvider({"filterByCountry": ids});
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
    try {
      if (_providers.isEmpty) {
        final providers = await fetchProviders();
        _providers = providers;
        return extractProviderById(providers, id);
      } else {
        return extractProviderById(_providers, id);
      }
    } catch (e) {
      return Provider(ZERO, EMPTY, EMPTY, EMPTY);
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
    try {
      return providers.firstWhere((element) => element.id == id);
    } catch (e) {
      return _emptyProvider;
    }
  }

  void clear() {
    _providers.clear();
  }
}
