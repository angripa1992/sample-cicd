import 'package:klikit/modules/add_order/data/models/request/billing_item_modifier_group_request.dart';
import 'package:klikit/modules/add_order/data/models/request/billing_item_modifier_request.dart';

import '../../menu/domain/entities/menu/menu_item.dart';
import '../domain/entities/modifier/item_modifier_group.dart';
import 'order_entity_provider.dart';

class ModifierManager {
  static final _instance = ModifierManager._internal();

  factory ModifierManager() => _instance;

  ModifierManager._internal();

  void removeDisabledModifier(List<AddOrderItemModifierGroup> groups) {
    groups.removeWhere((element) => !element.enabled);
    for (var firstGroups in groups) {
      firstGroups.modifiers.removeWhere((element) => !element.enabled);
      for (var firstModifier in firstGroups.modifiers) {
        firstModifier.groups.removeWhere((element) => !element.enabled);
        for (var secondGroup in firstModifier.groups) {
          secondGroup.modifiers.removeWhere((element) => !element.enabled);
        }
      }
    }
  }

  Future<bool> verifyRules(List<AddOrderItemModifierGroup> groups) async {
    for (var groupLevelOne in groups) {
      int levelOneModifierQuantity = 0;
      for (var modifierLevelOne in groupLevelOne.modifiers) {
        //debugPrint("Level 1 -> ${modifierLevelOne.title} -> ${modifierLevelOne.isSelected} -> ${modifierLevelOne.quantity}");
        if (modifierLevelOne.isSelected) {
          levelOneModifierQuantity += modifierLevelOne.quantity;
          for (var groupLevelTwo in modifierLevelOne.groups) {
            int levelTwoModifierQuantity = 0;
            for (var modifierLevelTwo in groupLevelTwo.modifiers) {
              //debugPrint("Level 2 -> ${modifierLevelTwo.title} -> ${modifierLevelTwo.isSelected} -> ${modifierLevelTwo.quantity}");
              if (modifierLevelTwo.isSelected) {
                levelTwoModifierQuantity += modifierLevelTwo.quantity;
              }
            }
            if (!_checkRole(levelTwoModifierQuantity, groupLevelTwo)) {
              return false;
            }
          }
        }
      }
      if (!_checkRole(levelOneModifierQuantity, groupLevelOne)) {
        return false;
      }
    }
    return true;
  }

  bool _checkRole(int quantity, AddOrderItemModifierGroup group) {
    final rule = group.rule;
    // debugPrint('${group.title} ->  rule -> value = ${rule.value} -> min = ${rule.min} -> max = ${rule.max} -> quantity = $quantity');

    if (rule.min == rule.max && rule.max == quantity) {
      return true;
    } else if (rule.min <= quantity && rule.max >= quantity) {
      return true;
    } else {
      return false;
    }
  }

  Future<num> calculateModifiersPrice(
      List<AddOrderItemModifierGroup> groups) async {
    num price = 0;
    for (var groupLevelOne in groups) {
      for (var modifierLevelOne in groupLevelOne.modifiers) {
        if (modifierLevelOne.isSelected) {
          price += (modifierLevelOne.klikitPrice().price *
              modifierLevelOne.quantity);
          for (var groupLevelTwo in modifierLevelOne.groups) {
            for (var modifierLevelTwo in groupLevelTwo.modifiers) {
              if (modifierLevelTwo.isSelected) {
                price += (modifierLevelTwo.klikitPrice().price *
                    modifierLevelTwo.quantity);
              }
            }
          }
        }
      }
    }
    return price;
  }

  Future<String> allCsvModifiersName(
      List<AddOrderItemModifierGroup> groups) async {
    final modifiers = [];
    for (var groupLevelOne in groups) {
      for (var modifierLevelOne in groupLevelOne.modifiers) {
        if (modifierLevelOne.isSelected) {
          modifiers
              .add('${modifierLevelOne.quantity}x ${modifierLevelOne.title}');
          for (var groupLevelTwo in modifierLevelOne.groups) {
            for (var modifierLevelTwo in groupLevelTwo.modifiers) {
              if (modifierLevelTwo.isSelected) {
                modifiers.add(
                    '${modifierLevelTwo.quantity}x ${modifierLevelTwo.title}');
              }
            }
          }
        }
      }
    }
    return modifiers.join(' , ');
  }

  Future<String> generateCheckingId({
    required List<AddOrderItemModifierGroup> groups,
    required MenuCategoryItem item,
  }) async {
    var uniqueId = '${item.id}';
    for (var groupLevelOne in groups) {
      for (var modifierLevelOne in groupLevelOne.modifiers) {
        if (modifierLevelOne.isSelected) {
          uniqueId =
              '${uniqueId}_${modifierLevelOne.id}/${modifierLevelOne.quantity}';
          for (var groupLevelTwo in modifierLevelOne.groups) {
            for (var modifierLevelTwo in groupLevelTwo.modifiers) {
              if (modifierLevelTwo.isSelected) {
                uniqueId =
                    '${uniqueId}_${modifierLevelTwo.id}/${modifierLevelTwo.quantity}';
              }
            }
          }
        }
      }
    }
    return uniqueId;
  }

  Future<void> clearModifier(List<AddOrderItemModifierGroup> groups) async {
    for (var groupLevelOne in groups) {
      for (var modifierLevelOne in groupLevelOne.modifiers) {
        modifierLevelOne.isSelected = false;
        modifierLevelOne.quantity = 0;
        for (var groupLevelTwo in modifierLevelOne.groups) {
          for (var modifierLevelTwo in groupLevelTwo.modifiers) {
            modifierLevelTwo.isSelected = false;
            modifierLevelTwo.quantity = 0;
          }
        }
      }
    }
  }

  Future<List<BillingItemModifierGroupRequestModel>> billingItemModifiers(
      List<AddOrderItemModifierGroup> groups) async {
    final billingModifiersGroupsL1 = <BillingItemModifierGroupRequestModel>[];
    for (var groupLevelOne in groups) {
      final billingModifiersL1 = <BillingItemModifierRequestModel>[];
      for (var modifierLevelOne in groupLevelOne.modifiers) {
        if (modifierLevelOne.isSelected) {
          final billingModifiersGroupsL2 =
              <BillingItemModifierGroupRequestModel>[];
          for (var groupLevelTwo in modifierLevelOne.groups) {
            final billingModifiersL2 = <BillingItemModifierRequestModel>[];
            for (var modifierLevelTwo in groupLevelTwo.modifiers) {
              if (modifierLevelTwo.isSelected) {
                billingModifiersL2.add(OrderEntityProvider()
                    .cartToBillingModifier(modifierLevelTwo, []));
              }
            }
            if (billingModifiersL2.isNotEmpty) {
              billingModifiersGroupsL2.add(OrderEntityProvider()
                  .cartToBillingModifierGroup(
                      groupLevelTwo, billingModifiersL2));
            }
          }
          billingModifiersL1.add(OrderEntityProvider().cartToBillingModifier(
              modifierLevelOne, billingModifiersGroupsL2));
        }
      }
      if (billingModifiersL1.isNotEmpty) {
        billingModifiersGroupsL1.add(OrderEntityProvider()
            .cartToBillingModifierGroup(groupLevelOne, billingModifiersL1));
      }
    }
    return billingModifiersGroupsL1;
  }
}
