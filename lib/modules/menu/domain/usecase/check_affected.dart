import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/menu/data/models/modifier_request_model.dart';
import 'package:klikit/modules/menu/domain/entities/modifier/affected_modifier_response.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';

class CheckAffected
    extends UseCase<AffectedModifierResponse, ModifierRequestModel> {
  final MenuRepository _repository;

  CheckAffected(this._repository);

  @override
  Future<Either<Failure, AffectedModifierResponse>> call(
      ModifierRequestModel params) {
    return _repository.disableModifier(params);
  }
}
