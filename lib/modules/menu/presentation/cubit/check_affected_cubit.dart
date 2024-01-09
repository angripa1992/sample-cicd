import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/data/models/modifier_request_model.dart';
import 'package:klikit/modules/menu/domain/entities/modifier/affected_modifier_response.dart';

import '../../../../app/session_manager.dart';
import '../../../../core/network/error_handler.dart';
import '../../../common/business_information_provider.dart';
import '../../domain/usecase/check_affected.dart';

class CheckAffectedCubit extends Cubit<ResponseState> {
  final CheckAffected _checkAffected;

  CheckAffectedCubit(this._checkAffected) : super(Empty());

  Future<Either<Failure, AffectedModifierResponse>> checkAffect({
    required int menuVersion,
    required int type,
    required bool enabled,
    required int brandId,
    required int branchID,
    required int groupId,
    int? modifierId,
  }) async {
    final allProviders = await getIt.get<BusinessInformationProvider>().findProvidersIds();
    final param = ModifierRequestModel(
      menuVersion: menuVersion,
      type: type,
      isEnabled: enabled,
      brandId: brandId,
      branchId: branchID,
      groupId: groupId,
      modifierId: modifierId,
      providerIds: allProviders,
      businessId: SessionManager().businessID(),
    );
    return _checkAffected(param);
  }
}
