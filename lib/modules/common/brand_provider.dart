import 'package:dio/dio.dart';
import 'package:klikit/modules/common/branch_info_provider.dart';

import 'data/business_info_provider_repo.dart';
import 'entities/brand.dart';

class BrandProvider {
  final BusinessInfoProviderRepo _orderRepository;
  final BranchInfoProvider _branchInfoProvider;
  final List<Brand> _brands = [];

  BrandProvider(this._orderRepository, this._branchInfoProvider);

  Future<List<Brand>> fetchBrands() async {
    if (_brands.isNotEmpty) return _brands;
    final branches = await _branchInfoProvider.branches();
    final branchIDs = branches.map((e) => e.id).toList();
    final response = await _orderRepository.fetchBrand({
      'filterByBranch': ListParam<int>(branchIDs, ListFormat.csv),
      'page': 1,
      'size': 1000,
    });
    return response.fold((failure) {
      return [];
    }, (data) {
      _brands.clear();
      _brands.addAll(data.brands);
      return _brands;
    });
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

  void clear() {
    _brands.clear();
  }
}
