import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/data/models/modifier_request_model.dart';
import 'package:klikit/modules/menu/domain/entities/modifier_disabled_response.dart';

import '../../../../app/session_manager.dart';
import '../../../../core/network/error_handler.dart';
import '../../../orders/provider/order_information_provider.dart';
import '../../domain/usecase/check_affected.dart';

class CheckAffectedCubit extends Cubit<ResponseState> {
  final CheckAffected _checkAffected;
  final OrderInformationProvider _informationProvider;

  CheckAffectedCubit(this._checkAffected, this._informationProvider)
      : super(Empty());

  Future<Either<Failure, ModifierDisabledResponse>> checkAffect({
    required int type,
    required bool enabled,
    required int brandId,
    required int groupId,
    int? modifierId,
  }) async {
    final param = ModifierRequestModel(
      type: type,
      isEnabled: enabled,
      brandId: brandId,
      branchId: SessionManager().currentUserBranchId(),
      groupId: groupId,
      modifierId: modifierId,
      providerIds: await _informationProvider.findProvidersIds(),
    );
    return _checkAffected(param);
  }
}
