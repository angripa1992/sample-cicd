import 'package:klikit/modules/common/payment_info_provider.dart';
import 'package:klikit/modules/common/source_provider.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_branch_info.dart';

import 'aggregrator_provider.dart';
import 'branch_info_provider.dart';
import 'brand_provider.dart';
import 'data/business_info_provider_repo.dart';
import 'entities/branch.dart';
import 'entities/brand.dart';
import 'entities/payment_info.dart';
import 'entities/provider.dart';
import 'entities/source.dart';

class BusinessInformationProvider {
  final BusinessInfoProviderRepo _orderRepository;
  late BrandProvider _brandProvider;
  late AggregatorProvider _aggregatorProvider;
  late SourceProvider _sourceProvider;
  late PaymentInfoProvider _paymentInfoProvider;
  late BranchInfoProvider _branchInfoProvider;

  BusinessInformationProvider(this._orderRepository) {
    _branchInfoProvider = BranchInfoProvider(_orderRepository);
    _brandProvider = BrandProvider(_orderRepository,_branchInfoProvider);
    _aggregatorProvider = AggregatorProvider(_orderRepository);
    _sourceProvider = SourceProvider(_orderRepository);
    _paymentInfoProvider = PaymentInfoProvider(_orderRepository);
  }

  ///brands
  Future<List<Brand>> fetchBrands() => _brandProvider.fetchBrands();

  Future<List<int>> fetchBrandsIds() => _brandProvider.fetchBrandsIds();

  Future<Brand?> findBrandById(int id) => _brandProvider.findBrandById(id);

  Future<List<int>> extractBrandsIds(List<Brand> brands) => _brandProvider.extractBrandsIds(brands);

  ///provider
  Future<List<Provider>> fetchProviders() => _aggregatorProvider.fetchProviders();

  Future<List<int>> findProvidersIds() => _aggregatorProvider.findProvidersIds();

  Future<Provider> findProviderById(int id) => _aggregatorProvider.findProviderById(id);

  Future<List<int>> extractProvidersIds(List<Provider> providers) => _aggregatorProvider.extractProvidersIds(providers);

  Future<Provider> extractProviderById(List<Provider> providers, int id) => _aggregatorProvider.extractProviderById(providers, id);

  ///Source
  Future<List<Source>> fetchSources() => _sourceProvider.fetchSources();

  Future<Source> findSourceById(int sourceId) => _sourceProvider.findSourceById(sourceId);

  ///payment
  Future<List<PaymentStatus>> fetchPaymentStatues() => _paymentInfoProvider.fetchStatuses();

  Future<List<PaymentMethod>> fetchPaymentMethods() => _paymentInfoProvider.fetchMethods();

  Future<PaymentStatus> fetchPaymentStatus(int id) => _paymentInfoProvider.findStatusById(id);

  Future<PaymentMethod> fetchPaymentMethod(int id) => _paymentInfoProvider.findMethodById(id);

  ///branch
  Future<List<Branch>> getBranches() => _branchInfoProvider.branches();

  Future<Branch?> branchByID(int branchID) => _branchInfoProvider.branchByID(branchID);

  Future<MenuBranchInfo?> menuBranchInfo(int branchID) => _branchInfoProvider.menuBranchByID(branchID);

  ///clear data after logout
  void clearData() {
    _brandProvider.clear();
    _aggregatorProvider.clear();
    _sourceProvider.clear();
    _paymentInfoProvider.clear();
    _branchInfoProvider.clear();
  }
}
