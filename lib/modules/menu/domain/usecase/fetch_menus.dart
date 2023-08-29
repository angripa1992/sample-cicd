import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';

import '../entities/menu/menu_data.dart';

class FetchMenus extends UseCase<MenuData, FetchMenuParams> {
  final MenuRepository _repository;

  FetchMenus(this._repository);

  @override
  Future<Either<Failure, MenuData>> call(FetchMenuParams params) {
    return _repository.fetchMenu(params);
  }
}

class FetchMenuParams {
  final bool menuV2Enabled;
  final int businessId;
  final int branchId;
  final int brandId;
  final int? providerID;

  FetchMenuParams( {
    required this.menuV2Enabled,
    required this.businessId,
    required this.branchId,
    required this.brandId,
    required this.providerID,
  });
}
