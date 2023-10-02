import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/data/models/modifier_request_model.dart';
import 'package:klikit/modules/menu/domain/entities/modifier/affected_modifier_response.dart';

import '../../../../app/session_manager.dart';
import '../../../../core/network/error_handler.dart';
import '../../../common/business_information_provider.dart';
import '../../domain/usecase/check_affected.dart';

class CheckAffectedCubit extends Cubit<ResponseState> {
  final CheckAffected _checkAffected;
  final BusinessInformationProvider _informationProvider;

  CheckAffectedCubit(this._checkAffected, this._informationProvider)
      : super(Empty());

  Future<Either<Failure, AffectedModifierResponse>> checkAffect({
    required int menuVersion,
    required int type,
    required bool enabled,
    required int brandId,
    required int groupId,
    int? modifierId,
  }) async {
    final param = ModifierRequestModel(
      menuVersion: menuVersion,
      type: type,
      isEnabled: enabled,
      brandId: brandId,
      branchId: SessionManager().branchId(),
      groupId: groupId,
      modifierId: modifierId,
      providerIds: await _informationProvider.findProvidersIds(),
      businessId: SessionManager().businessID(),
    );
    return _checkAffected(param);
  }
}
