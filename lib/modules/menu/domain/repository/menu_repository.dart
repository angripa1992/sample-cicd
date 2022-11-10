import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/menu/domain/entities/brands.dart';
import 'package:klikit/modules/menu/domain/entities/menues.dart';
import 'package:klikit/modules/menu/domain/entities/stock.dart';
import 'package:klikit/modules/menu/domain/usecase/update_item.dart';
import 'package:klikit/modules/menu/domain/usecase/update_menu.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../entities/modifiers_group.dart';
import '../usecase/fetch_menus.dart';

abstract class MenuRepository {
  Future<Either<Failure, MenuBrands>> fetchMenuBrands(
      Map<String, dynamic> params);

  Future<Either<Failure, MenusData>> fetchMenus(FetchMenuParams params);

  Future<Either<Failure, Stock>> updateItem(UpdateItemParam params);

  Future<Either<Failure, ActionSuccess>> updateMenu(UpdateMenuParams params);

  Future<Either<Failure, List<ModifiersGroup>>> fetchModifiersGroups(Map<String, dynamic> params);
}
