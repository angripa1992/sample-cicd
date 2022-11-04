import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/menu/domain/entities/brands.dart';

abstract class MenuRepository{
  Future<Either<Failure,MenuBrands>> fetchMenuBrands(Map<String,dynamic> params);
}