import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/data/models/modifier_request_model.dart';
import 'package:klikit/modules/menu/domain/entities/modifier_disabled_response.dart';

import '../../../../app/app_preferences.dart';
import '../../../../core/provider/order_information_provider.dart';
import '../../domain/usecase/check_affected.dart';

class CheckAffectedCubit extends Cubit<ResponseState> {
  final CheckAffected _checkAffected;
  final OrderInformationProvider _informationProvider;
  final AppPreferences _preferences;

  CheckAffectedCubit(
      this._checkAffected, this._informationProvider, this._preferences)
      : super(Empty());

  void checkAffect({
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
      branchId: _preferences.getUser().userInfo.brandId,
      groupId: groupId,
      modifierId: modifierId,
      providerIds: await _informationProvider.getProvidersIds(),
    );
    final response = await _checkAffected(param);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        emit(Success<ModifierDisabledResponse>(data));
      },
    );
  }
}
