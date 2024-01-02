import '../../../app/session_manager.dart';
import 'model/brand_request_model.dart';
import 'entities/brand.dart';
import 'data/business_info_provider_repo.dart';

class BrandProvider {
  final BusinessInfoProviderRepo _orderRepository;
  List<Brand> _brands = [];

  BrandProvider(this._orderRepository);

  Future<List<Brand>> fetchBrands() async {
    if (_brands.isEmpty) {
      final requestModel = BrandRequestModel(
        filterByBranch: SessionManager().branchId(),
      );
      final response = await _orderRepository.fetchBrand(requestModel);
      if (response.isRight()) {
        final brands = response.getOrElse(() => Brands([]));
        _brands = brands.brands;
        return _brands;
      } else {
        return [];
      }
    } else {
      return _brands;
    }
  }

  Future<List<int>> fetchBrandsIds() async {
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
