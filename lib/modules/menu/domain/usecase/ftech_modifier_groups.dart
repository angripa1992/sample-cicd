import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/menu/domain/entities/modifiers_group.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';

class FetchModifierGroups
    extends UseCase<List<ModifiersGroup>, Map<String, dynamic>> {
  final MenuRepository _repository;

  FetchModifierGroups(this._repository);

  @override
  Future<Either<Failure, List<ModifiersGroup>>> call(
      Map<String, dynamic> params) {
    return _repository.fetchModifiersGroups(params);
  }
}
