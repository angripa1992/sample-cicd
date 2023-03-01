import 'package:klikit/modules/orders/domain/entities/provider.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/modules/orders/provider/source_provider.dart';

import '../domain/entities/brand.dart';
import '../domain/entities/source.dart';
import 'aggregrator_provider.dart';
import 'brand_provider.dart';

class OrderInformationProvider {
  final OrderRepository _orderRepository;
  late BrandProvider _brandProvider;
  late AggregatorProvider _aggregatorProvider;
  late SourceProvider _sourceProvider;

  OrderInformationProvider(this._orderRepository) {
    _brandProvider = BrandProvider(_orderRepository);
    _aggregatorProvider = AggregatorProvider(_orderRepository);
    _sourceProvider = SourceProvider(_orderRepository);
  }

  ///brands
  Future<List<Brand>> fetchBrands() => _brandProvider.fetchBrands();

  Future<List<int>> findBrandsIds() => _brandProvider.findBrandsIds();

  Future<Brand?> findBrandById(int id) => _brandProvider.findBrandById(id);

  Future<List<int>> extractBrandsIds(List<Brand> brands) =>
      _brandProvider.extractBrandsIds(brands);

  ///provider
  Future<List<Provider>> fetchProviders() =>
      _aggregatorProvider.fetchProviders();

  Future<List<int>> findProvidersIds() =>
      _aggregatorProvider.findProvidersIds();

  Future<Provider> findProviderById(int id) =>
      _aggregatorProvider.findProviderById(id);

  Future<List<int>> extractProvidersIds(List<Provider> providers) =>
      _aggregatorProvider.extractProvidersIds(providers);

  Future<Provider> extractProviderById(List<Provider> providers, int id) =>
      _aggregatorProvider.extractProviderById(providers, id);

  ///Source
  Future<List<Source>> fetchSources() => _sourceProvider.fetchSources();

  Future<Source> findSourceById(int sourceId) =>
      _sourceProvider.findSourceById(sourceId);

  ///clear data after logout
  void clearData() {
    _brandProvider.clear();
    _aggregatorProvider.clear();
    _sourceProvider.clear();
  }
}
