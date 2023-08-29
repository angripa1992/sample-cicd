import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/menu/data/models/modifier_request_model.dart';
import 'package:klikit/modules/menu/domain/entities/brands.dart';
import 'package:klikit/modules/menu/domain/usecase/update_item_snooze.dart';
import 'package:klikit/modules/menu/domain/usecase/update_menu_enabled.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../entities/menu/menu_data.dart';
import '../entities/menu/menu_out_of_stock.dart';
import '../entities/modifier/modifier_group.dart';
import '../entities/modifier/affected_modifier_response.dart';
import '../usecase/fetch_menus.dart';
import '../usecase/ftech_modifier_groups.dart';

abstract class MenuRepository {
  Future<Either<Failure, MenuBrands>> fetchMenuBrands(
    Map<String, dynamic> params,
  );

  Future<Either<Failure, MenuData>> fetchMenu(FetchMenuParams params);

  Future<Either<Failure, MenuOutOfStock>> updateItemSnooze(UpdateItemSnoozeParam params);

  Future<Either<Failure, ActionSuccess>> updateMenuEnabled(UpdateMenuParams params);

  Future<Either<Failure, List<ModifierGroup>>> fetchModifiersGroups(FetchModifierGroupParams params);

  Future<Either<Failure, ActionSuccess>> updateModifierEnabled(ModifierRequestModel params);

  Future<Either<Failure, AffectedModifierResponse>> disableModifier(
    ModifierRequestModel params,
  );
}
