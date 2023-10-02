import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../../../app/session_manager.dart';
import '../../../common/business_information_provider.dart';
import '../../data/models/modifier_request_model.dart';
import '../../domain/usecase/update_modifier_enabled.dart';

class UpdateModifierEnabledCubit extends Cubit<ResponseState> {
  final UpdateModifierEnabled _updateModifier;
  final BusinessInformationProvider _informationProvider;

  UpdateModifierEnabledCubit(this._updateModifier, this._informationProvider)
      : super(Empty());

  void updateModifier({
    required int menuVersion,
    required int type,
    required bool enabled,
    required int brandId,
    required int groupId,
    int? modifierId,
  }) async {
    emit(Loading());
    final param = ModifierRequestModel(
      menuVersion: menuVersion,
      type: type,
      isEnabled: enabled,
      brandId: brandId,
      branchId: SessionManager().branchId(),
      businessId: SessionManager().businessID(),
      groupId: groupId,
      modifierId: modifierId,
      providerIds: await _informationProvider.findProvidersIds(),
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
