import 'package:dio/dio.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/modules/orders/data/request_models/brand_request_model.dart';
import 'package:klikit/modules/orders/domain/entities/provider.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';

import '../../modules/orders/domain/entities/brand.dart';
import '../../modules/orders/domain/entities/source.dart';

class OrderInformationProvider {
  final OrderRepository _orderRepository;
  final AppPreferences _preferences;
  List<Brand> _brands = [];
  List<Provider> _providers = [];
  List<Source> _sources = [];

  OrderInformationProvider(this._orderRepository, this._preferences);

  void loadAllInformation() async {
    await fetchSources();
  }

  ///branch info
  Future<int> findBranchId() async {
    return _preferences.getUser().userInfo.branchId;
  }

  ///brands info
  Future<List<Brand>> fetchBrands() async {
    if (_brands.isEmpty) {
      final requestModel = BrandRequestModel(
          filterByBranch: _preferences.getUser().userInfo.branchId);
      final response = await _orderRepository.fetchBrand(requestModel);
      if (response.isRight()) {
        final brands = response.getOrElse(() => Brands([]));
        _brands = brands.brands;
        print('----------------------brands ${_brands.length}');
        return _brands;
      } else {
        return [];
      }
    } else {
      return _brands;
    }
  }

  Future<List<int>> findBrandsIds() async {
    if (_brands.isEmpty) {
      final brands = await fetchBrands();
      return await extractBrandsIds(brands);
    } else {
      return await extractBrandsIds(_brands);
    }
  }

  Future<Brand?> findBrandById(int id) async {
    try {
      if (_brands.isEmpty) {
        final brands = await fetchBrands();
        return brands.firstWhere((element) => element.id == id);
      } else {
        return _brands.firstWhere((element) => element.id == id);
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<int>> extractBrandsIds(List<Brand> brands) async {
    final ids = <int>[];
    for (var brand in brands) {
      ids.add(brand.id);
    }
    return ids;
  }

  ///provider info
  Future<List<Provider>> fetchProviders() async {
    if (_providers.isEmpty) {
      final ids = ListParam<int>(
          _preferences.getUser().userInfo.countryIds, ListFormat.csv);
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

  ///Source info
  Future<List<Source>> fetchSources() async {
    if (_providers.isEmpty) {
      final response = await _orderRepository.fetchSources();
      if (response.isRight()) {
        final sources = response.getOrElse(() => []);
        final data = <Source>[];
        for (var source in sources) {
          data.addAll(source.sources);
        }
        _sources = data;
        return _sources;
      } else {
        return [];
      }
    } else {
      return _sources;
    }
  }

  Future<Source> findSourceById(int sourceId) async {
    if (_sources.isEmpty) {
      final sources = await fetchSources();
      _sources = sources;
    }
    return _sources.firstWhere((element) => element.id == sourceId);
  }

  ///clear data after logout
  void clearData() {
    _brands.clear();
    _providers.clear();
  }
}
