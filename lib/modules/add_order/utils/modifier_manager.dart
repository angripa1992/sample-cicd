import 'package:klikit/modules/add_order/data/models/billing_item_modifier.dart';
import 'package:klikit/modules/add_order/data/models/billing_item_modifier_group.dart';

import '../../../app/constants.dart';
import '../../menu/domain/entities/items.dart';
import '../domain/entities/item_modifier_group.dart';
import '../domain/entities/item_price.dart';
import 'order_entity_provider.dart';

class ModifierManager {
  static final _instance = ModifierManager._internal();

  factory ModifierManager() => _instance;

  ModifierManager._internal();

  void removeDisabledModifier(List<ItemModifierGroup> groups) {
    groups.removeWhere((element) => !element.statuses
        .firstWhere((element) => element.providerId == ProviderID.KLIKIT)
        .enabled);
    for (var firstGroups in groups) {
      firstGroups.modifiers.removeWhere((element) => !element.statuses
          .firstWhere((element) => element.providerId == ProviderID.KLIKIT)
          .enabled);
      for (var firstModifier in firstGroups.modifiers) {
        firstModifier.groups.removeWhere((element) => !element.statuses
            .firstWhere((element) => element.providerId == ProviderID.KLIKIT)
            .enabled);
        for (var secondGroup in firstModifier.groups) {
          secondGroup.modifiers.removeWhere((element) => !element.statuses
              .firstWhere((element) => element.providerId == ProviderID.KLIKIT)
              .enabled);
        }
      }
    }
  }

  Future<bool> verifyRules(List<ItemModifierGroup> groups) async {
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

  bool _checkRole(int quantity, ItemModifierGroup group) {
    final rule = group.rule;
    // debugPrint('${group.title} ->  rule -> value = ${rule.value} -> min = ${rule.min} -> max = ${rule.max} -> quantity = $quantity');

    if (rule.value > 0 && rule.value == quantity) {
      return true;
    } else if (rule.value == 0 &&
        rule.min <= quantity &&
        rule.max >= quantity) {
      return true;
    } else {
      return false;
    }
  }

  Future<num> calculateModifiersPrice(List<ItemModifierGroup> groups) async {
    num price = 0;
    for (var groupLevelOne in groups) {
      for (var modifierLevelOne in groupLevelOne.modifiers) {
        if (modifierLevelOne.isSelected) {
          price += (_klikitPrice(modifierLevelOne.prices) *
              modifierLevelOne.quantity);
          for (var groupLevelTwo in modifierLevelOne.groups) {
            for (var modifierLevelTwo in groupLevelTwo.modifiers) {
              if (modifierLevelTwo.isSelected) {
                price += (_klikitPrice(modifierLevelTwo.prices) *
                    modifierLevelTwo.quantity);
              }
            }
          }
        }
      }
    }
    return price;
  }

  Future<String> allCsvModifiersName(List<ItemModifierGroup> groups) async {
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
    required List<ItemModifierGroup> groups,
    required MenuItems item,
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

  num _klikitPrice(List<ItemPrice> prices) {
    return prices
        .firstWhere((element) => element.providerId == ProviderID.KLIKIT)
        .price;
  }

  Future<void> clearModifier(List<ItemModifierGroup> groups) async {
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

  Future<List<BillingItemModifierGroup>> billingItemModifiers(
      List<ItemModifierGroup> groups) async {
    final billingModifiersGroupsL1 = <BillingItemModifierGroup>[];
    for (var groupLevelOne in groups) {
      final billingModifiersL1 = <BillingItemModifier>[];
      for (var modifierLevelOne in groupLevelOne.modifiers) {
        if (modifierLevelOne.isSelected) {
          final billingModifiersGroupsL2 = <BillingItemModifierGroup>[];
          for (var groupLevelTwo in modifierLevelOne.groups) {
            final billingModifiersL2 = <BillingItemModifier>[];
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
