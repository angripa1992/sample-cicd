import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../../../app/app_preferences.dart';
import '../../../../core/provider/order_information_provider.dart';
import '../../data/models/modifier_request_model.dart';
import '../../domain/usecase/update_modifier.dart';

class UpdateModifierCubit extends Cubit<ResponseState> {
  final UpdateModifier _updateModifier;
  final OrderInformationProvider _informationProvider;
  final AppPreferences _preferences;

  UpdateModifierCubit(
      this._updateModifier, this._informationProvider, this._preferences)
      : super(Empty());

  void updateModifier({
    required int type,
    required bool enabled,
    required int brandId,
    required int groupId,
    int? modifierId,
  }) async {
    emit(Loading());
    final param = ModifierRequestModel(
      type: type,
      isEnabled: enabled,
      brandId: brandId,
      branchId: _preferences.getUser().userInfo.branchId,
      groupId: groupId,
      modifierId: modifierId,
      providerIds: await _informationProvider.getProvidersIds(),
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
