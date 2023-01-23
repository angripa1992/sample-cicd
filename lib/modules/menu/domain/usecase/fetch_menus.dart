import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';

import '../entities/menues.dart';

class FetchMenus extends UseCase<MenusData, FetchMenuParams> {
  final MenuRepository _repository;

  FetchMenus(this._repository);

  @override
  Future<Either<Failure, MenusData>> call(FetchMenuParams params) {
    return _repository.fetchMenus(params);
  }
}

class FetchMenuParams {
  final int branchId;
  final int brandId;
  final String providerID;

  FetchMenuParams(
      {required this.branchId,
      required this.brandId,
      this.providerID = 'undefine'});
}
