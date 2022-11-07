import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/menu/domain/entities/brands.dart';
import 'package:klikit/modules/menu/domain/entities/menues.dart';

abstract class MenuRepository{
  Future<Either<Failure,MenuBrands>> fetchMenuBrands(Map<String,dynamic> params);
  Future<Either<Failure,MenusData>> fetchMenus(int brandID);
}