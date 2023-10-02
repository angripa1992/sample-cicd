import 'package:klikit/app/session_manager.dart';

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

  void clear() {
    _branchInfo = null;
  }
}
