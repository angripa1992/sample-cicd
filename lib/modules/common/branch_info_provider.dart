import 'package:collection/collection.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_branch_info.dart';

import 'data/business_info_provider_repo.dart';
import 'entities/branch.dart';

class BranchInfoProvider {
  final BusinessInfoProviderRepo _orderRepository;
  final List<Branch> _branches = [];

  BranchInfoProvider(this._orderRepository);

  Future<Branch?> branchByID(int branchID) async {
    final data = await branches();
    return data.firstWhereOrNull((element) => element.id == branchID);
  }

  Future<List<Branch>> branches() async {
    if (_branches.isNotEmpty) return _branches;
    final businessID = SessionManager().businessID();
    final response = await _orderRepository.fetchBranches({
      'filterByBusiness': businessID,
      'page': 1,
      'size': 500,
    });
    return response.fold((failure) {
      return [];
    }, (data) {
      _branches.clear();
      _branches.addAll(data);
      return _branches;
    });
  }

  Future<MenuBranchInfo?> menuBranchByID(int branchID) async {
    final businessBranch = await branchByID(branchID);
    if (businessBranch != null) {
      return MenuBranchInfo(
        businessID: businessBranch.businessId,
        brandID: businessBranch.brandIds.first,
        branchID: businessBranch.id,
        countryID: businessBranch.countryId,
        currencyID: businessBranch.currencyId,
        startTime: 0,
        endTime: 0,
        availabilityMask: businessBranch.availabilityMask,
        providerIDs: '',
        languageCode: businessBranch.languageCode,
        currencyCode: businessBranch.currencyCode,
        currencySymbol: businessBranch.currencySymbol,
      );
    }
    return null;
  }

  void clear() {
    _branches.clear();
  }
}
