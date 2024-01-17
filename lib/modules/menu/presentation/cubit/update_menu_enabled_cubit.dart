import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/domain/usecase/update_menu_enabled.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../../../app/constants.dart';
import '../../../../app/di.dart';
import '../../../../app/session_manager.dart';
import '../../../../app/user_permission_manager.dart';
import '../../../common/business_information_provider.dart';

class UpdateMenuEnabledCubit extends Cubit<ResponseState> {
  final UpdateMenuEnabled _updateMenu;

  UpdateMenuEnabledCubit(this._updateMenu) : super(Empty());

  void updateMenu({
    required int menuVersion,
    required int brandId,
    required int branchId,
    required int id,
    required int type,
    required bool enabled,
  }) async {
    emit(Loading());
    final branch = await getIt.get<BusinessInformationProvider>().branchByID(branchId);
    final version = UserPermissionManager().isBizOwner() ? (branch?.menuVersion ?? MenuVersion.v2) : menuVersion;
    final response = await _updateMenu(
      UpdateMenuParams(
        menuVersion: version,
        businessId: SessionManager().businessID(),
        branchId: branchId,
        brandId: brandId,
        enabled: enabled,
        id: id,
        type: type,
      ),
    );
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        emit(Success<ActionSuccess>(data));
      },
    );
  }
}
