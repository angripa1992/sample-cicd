import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/menu/domain/entities/brands.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';

class FetchMenuBrands extends UseCase<MenuBrands, Map<String, dynamic>> {
  final MenuRepository _repository;

  FetchMenuBrands(this._repository);

  @override
  Future<Either<Failure, MenuBrands>> call(Map<String, dynamic> params) {
    return _repository.fetchMenuBrands(params);
  }
}
