import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';

import '../entities/menues.dart';

class FetchMenus extends UseCase<MenusData,int>{
  final MenuRepository _repository;

  FetchMenus(this._repository);

  @override
  Future<Either<Failure, MenusData>> call(int params) {
   return _repository.fetchMenus(params);
  }

}