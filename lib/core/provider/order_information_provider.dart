import 'package:dio/dio.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/modules/orders/data/request_models/brand_request_model.dart';
import 'package:klikit/modules/orders/domain/entities/provider.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';

import '../../modules/orders/domain/entities/brand.dart';

class OrderInformationProvider {
  final OrderRepository _orderRepository;
  final AppPreferences _preferences;
  static Brands _brands = Brands([]);
  static List<Provider> _providers = [];

  OrderInformationProvider(this._orderRepository, this._preferences);

  Future<int> getBranchId() async {
    return _preferences.getUser().userInfo.branchId;
  }

  Future<Brands> getBrands() async {
    if (_brands.brands.isEmpty) {
      final requestModel = BrandRequestModel(
          filterByBranch: _preferences.getUser().userInfo.branchId);
      final response = await _orderRepository.fetchBrand(requestModel);
      if (response.isRight()) {
        final brands = response.getOrElse(() => Brands([]));
        _brands = brands;
        return _brands;
      } else {
        return Brands([]);
      }
    } else {
      return _brands;
    }
  }

  Future<List<int>> getBrandsIds() async {
    if (_brands.brands.isEmpty) {
      final brands = await getBrands();
      return await extractBrandsIds(brands.brands);
    } else {
      return await extractBrandsIds(_brands.brands);
    }
  }

  Future<List<int>> extractBrandsIds(List<Brand> brands) async {
    final ids = <int>[];
    for (var brand in brands) {
      ids.add(brand.id);
    }
    return ids;
  }

  Future<List<Provider>> getProviders() async {
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

  Future<List<int>> getProvidersIds() async {
    if (_providers.isEmpty) {
      final providers = await getProviders();
      return extractProvidersIds(providers);
    } else {
      return extractProvidersIds(_providers);
    }
  }

  Future<Provider> getProviderById(int id) async {
    if (_providers.isEmpty) {
      final providers = await getProviders();
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
}
