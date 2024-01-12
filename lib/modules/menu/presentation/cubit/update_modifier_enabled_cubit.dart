import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../../../app/constants.dart';
import '../../../../app/di.dart';
import '../../../../app/session_manager.dart';
import '../../../../app/user_permission_manager.dart';
import '../../../common/business_information_provider.dart';
import '../../data/models/modifier_request_model.dart';
import '../../domain/usecase/update_modifier_enabled.dart';

class UpdateModifierEnabledCubit extends Cubit<ResponseState> {
  final UpdateModifierEnabled _updateModifier;

  UpdateModifierEnabledCubit(this._updateModifier) : super(Empty());

  void updateModifier({
    required int menuVersion,
    required int type,
    required bool enabled,
    required int brandId,
    required int branchID,
    required int groupId,
    int? modifierId,
  }) async {
    emit(Loading());
    final allProviders = await getIt.get<BusinessInformationProvider>().findProvidersIds();
    final branch = await getIt.get<BusinessInformationProvider>().branchByID(brandId);
    final version = UserPermissionManager().isBizOwner() ? (branch?.menuVersion ?? MenuVersion.v2) : menuVersion;
    final param = ModifierRequestModel(
      menuVersion: version,
      type: type,
      isEnabled: enabled,
      brandId: brandId,
      branchId: branchID,
      businessId: SessionManager().businessID(),
      groupId: groupId,
      modifierId: modifierId,
      providerIds: allProviders,
    );
    final response = await _updateModifier(param);
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
