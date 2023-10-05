import 'package:klikit/app/session_manager.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_branch_info.dart';

import 'data/business_info_provider_repo.dart';
import 'entities/branch_info.dart';

class BranchInfoProvider {
  final BusinessInfoProviderRepo _orderRepository;
  BusinessBranchInfo? _branchInfo;

  BranchInfoProvider(this._orderRepository);

  Future<BusinessBranchInfo?> getBranchInfo() async {
    if (_branchInfo != null) return _branchInfo;
    final response = await _orderRepository.fetchBranchDetails(SessionManager().branchId());
    return response.fold(
      (failure) {
        return null;
      },
      (data) {
        return data;
      },
    );
  }

  Future<MenuBranchInfo?> getMenuBranchInfo() async {
    final businessBranch = await getBranchInfo();
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
    _branchInfo = null;
  }
}
