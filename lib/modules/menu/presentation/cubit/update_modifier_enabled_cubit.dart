import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../../../app/di.dart';
import '../../../../app/session_manager.dart';
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
    final param = ModifierRequestModel(
      menuVersion: menuVersion,
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
