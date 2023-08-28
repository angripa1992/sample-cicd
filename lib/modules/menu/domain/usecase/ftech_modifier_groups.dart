import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';

import '../entities/modifier/modifier_group.dart';

class FetchModifierGroupParams {
  final int branchID;
  final int brandID;
  final int businessID;
  final int? providerID;

  FetchModifierGroupParams({
    required this.branchID,
    required this.brandID,
    required this.businessID,
    this.providerID,
  });
}

class FetchModifierGroups
    extends UseCase<List<ModifierGroup>, FetchModifierGroupParams> {
  final MenuRepository _repository;

  FetchModifierGroups(this._repository);

  @override
  Future<Either<Failure, List<ModifierGroup>>> call(
    FetchModifierGroupParams params,
  ) {
    return _repository.fetchModifiersGroups(params);
  }
}
