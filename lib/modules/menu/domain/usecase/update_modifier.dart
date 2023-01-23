import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/menu/data/models/modifier_request_model.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

class UpdateModifier extends UseCase<ActionSuccess, ModifierRequestModel> {
  final MenuRepository _repository;

  UpdateModifier(this._repository);

  @override
  Future<Either<Failure, ActionSuccess>> call(ModifierRequestModel params) {
    return _repository.enableModifier(params);
  }
}
