import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/modules/add_order/data/datasource/add_order_datasource.dart';
import 'package:klikit/modules/menu/data/datasource/menu_remote_datasource.dart';

import '../../../app/session_manager.dart';
import '../../add_order/domain/entities/modifier/item_modifier_group.dart';
import '../../menu/domain/entities/menu/menu_branch_info.dart';
import '../../menu/domain/entities/menu/menu_item.dart';
import '../../menu/domain/usecase/fetch_menus.dart';
import '../domain/entities/cart.dart';

class OrderMenuItemProvider {
  static final _instance = OrderMenuItemProvider._internal();

  factory OrderMenuItemProvider() => _instance;

  OrderMenuItemProvider._internal();

  Future<MenuCategoryItem?> fetchMenuItem({
    required String itemId,
    required int brandId,
    required int branchId,
    required int providerId,
  }) async {
    try {
      final menusItemsResponse = await getIt.get<MenuRemoteDatasource>().fetchMenus(
            FetchMenuParams(
              menuV2Enabled: SessionManager().menuV2EnabledForKlikitOrder(),
              businessId: SessionManager().businessID(),
              branchId: branchId,
              brandId: brandId,
              providerID: providerId,
            ),
          );
      for (var section in menusItemsResponse.sections) {
        for (var category in section.categories) {
          for (var item in category.items) {
            if (item.id.toString() == itemId) {
              return item;
            }
          }
        }
      }
      return null;
    } on DioException {
      rethrow;
    }
  }

  Future<List<MenuItemModifierGroup>> fetchModifiers(
    CartV2 cartV2,
    MenuBranchInfo branchInfo,
    int type,
  ) async {
    try {
      final groups = await getIt.get<AddOrderDatasource>().fetchModifiers(
            itemID: int.parse(cartV2.id),
            branchInfo: branchInfo,
            type: type,
          );
      for (var modifierGroupOne in cartV2.modifierGroups) {
        final groupLevelOne = groups.firstWhereOrNull((element) => element.groupId.toString() == modifierGroupOne.id);
        for (var modifierOne in modifierGroupOne.modifiers) {
          final modifierLevelOne = groupLevelOne?.modifiers.firstWhereOrNull((element) => element.modifierId.toString() == modifierOne.id);
          if (modifierLevelOne != null) {
            modifierLevelOne.isSelected = true;
            modifierLevelOne.quantity = modifierOne.quantity;
          }
          for (var modifierGroupTwo in modifierOne.modifierGroups) {
            final groupLevelTwo = modifierLevelOne?.groups.firstWhereOrNull((element) => element.groupId.toString() == modifierGroupTwo.id);
            for (var modifierTwo in modifierGroupTwo.modifiers) {
              final modifierLevelTwo = groupLevelTwo?.modifiers.firstWhereOrNull((element) => element.modifierId.toString() == modifierTwo.id);
              if (modifierLevelTwo != null) {
                modifierLevelTwo.isSelected = true;
                modifierLevelTwo.quantity = modifierTwo.quantity;
              }
            }
          }
        }
      }
      return groups;
    } on Exception {
      rethrow;
    }
  }
}
