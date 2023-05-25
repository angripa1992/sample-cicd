import 'package:collection/collection.dart';
import 'package:klikit/modules/orders/domain/entities/cart.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import 'grab_order_update_request_model.dart';

class EditingManager {
  static final _instance = EditingManager._internal();

  factory EditingManager() => _instance;

  EditingManager._internal();

  List<List<CartV2>> extractCartItems(Order order) {
    final brandSpecificCarts = <List<CartV2>>[];
    for (var brand in order.brands) {
      final cartItems = order.cartV2
          .where((element) => element.cartBrand.id == brand.id)
          .toList();
      brandSpecificCarts.add(cartItems);
    }
    return brandSpecificCarts;
  }

  String allCsvModifiersName(List<ModifierGroups> groups) {
    final modifiers = [];
    for (var groupLevelOne in groups) {
      for (var modifierLevelOne in groupLevelOne.modifiers) {
        modifiers.add('${modifierLevelOne.quantity}x ${modifierLevelOne.name}');
        for (var groupLevelTwo in modifierLevelOne.modifierGroups) {
          for (var modifierLevelTwo in groupLevelTwo.modifiers) {
            modifiers
                .add('${modifierLevelTwo.quantity}x ${modifierLevelTwo.name}');
          }
        }
      }
    }
    return modifiers.join(' , ');
  }

  bool enabledButton(Order originalOrder, Order modifiedOrder) {
    if (originalOrder.cartV2.isNotEmpty && modifiedOrder.cartV2.isEmpty) {
      return false;
    } else if (originalOrder.cartV2.length == modifiedOrder.cartV2.length) {
      bool flag = false;
      for (int i = 0; i < originalOrder.cartV2.length; i++) {
        final originalCartItem = originalOrder.cartV2[i];
        final modifiedCartItem = modifiedOrder.cartV2[i];
        if ((originalCartItem.id == modifiedCartItem.id &&
                originalCartItem.externalId == originalCartItem.externalId) &&
            originalCartItem.quantity != modifiedCartItem.quantity) {
          flag = true;
        }
      }
      return flag;
    } else {
      return true;
    }
  }

  GrabOrderUpdateRequestModel createRequestModel(
      Order originalOrder, Order modifiedOrder) {
    final items = <GrabItem>[];
    for (var originalItem in originalOrder.cartV2) {
      final modifiedItem = modifiedOrder.cartV2.firstWhereOrNull((element) =>
          element.id == originalItem.id &&
          element.externalId == originalItem.externalId);
      if (modifiedItem == null) {
        items.add(
          GrabItem(
            id: originalItem.id,
            externalId: originalItem.externalId,
            quantity: originalItem.quantity,
            status: 'DELETED',
            unitPrice: num.parse(originalItem.unitPrice),
          ),
        );
      } else if (originalItem.quantity != modifiedItem.quantity) {
        items.add(
          GrabItem(
            id: modifiedItem.id,
            externalId: modifiedItem.externalId,
            quantity: modifiedItem.quantity,
            status: 'UPDATED',
            unitPrice: num.parse(modifiedItem.unitPrice),
          ),
        );
      } else {
        items.add(
          GrabItem(
            id: originalItem.id,
            externalId: originalItem.externalId,
            quantity: originalItem.quantity,
            status: '',
            unitPrice: num.parse(originalItem.unitPrice),
          ),
        );
      }
    }
    return GrabOrderUpdateRequestModel(
      id: modifiedOrder.id,
      externalId: modifiedOrder.externalId,
      items: items,
    );
  }
}
