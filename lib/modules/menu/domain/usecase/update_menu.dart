import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

class UpdateMenuParams {
  final int id;
  final int branchId;
  final int brandId;
  final int type;
  final bool enabled;

  UpdateMenuParams({
    required this.id,
    required this.branchId,
    required this.brandId,
    required this.type,
    required this.enabled,
  });
}

class UpdateMenu extends UseCase<ActionSuccess, UpdateMenuParams> {
  final MenuRepository _repository;

  UpdateMenu(this._repository);

  @override
  Future<Either<Failure, ActionSuccess>> call(UpdateMenuParams params) {
    return _repository.updateMenu(params);
  }
}
