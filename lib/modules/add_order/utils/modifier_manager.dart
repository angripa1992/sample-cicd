import 'package:flutter/material.dart';

import '../../../app/constants.dart';
import '../domain/entities/item_modifier_group.dart';
import '../domain/entities/item_price.dart';

class ModifierManager{
  static final _instance = ModifierManager._internal();
  factory ModifierManager() => _instance;
  ModifierManager._internal();

  Future<bool> verifyRules(List<ItemModifierGroup> groups) async {
    for (var groupLevelOne in groups) {
      int levelOneModifierQuantity = 0;
      for (var modifierLevelOne in groupLevelOne.modifiers) {
        debugPrint("Level 1 -> ${modifierLevelOne.title} -> ${modifierLevelOne.isSelected} -> ${modifierLevelOne.quantity}");
        if (modifierLevelOne.isSelected) {
          levelOneModifierQuantity += modifierLevelOne.quantity;
          for (var groupLevelTwo in modifierLevelOne.groups) {
            int levelTwoModifierQuantity = 0;
            for (var modifierLevelTwo in groupLevelTwo.modifiers) {
              debugPrint("Level 2 -> ${modifierLevelTwo.title} -> ${modifierLevelTwo.isSelected} -> ${modifierLevelTwo.quantity}");
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
    debugPrint(
        '${group.title} ->  rule -> value = ${rule.value} -> min = ${rule.min} -> max = ${rule.max} -> quantity = $quantity');

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
          price += (_klikitPrice(modifierLevelOne.prices) * modifierLevelOne.quantity);
          for (var groupLevelTwo in modifierLevelOne.groups) {
            for (var modifierLevelTwo in groupLevelTwo.modifiers) {
              if (modifierLevelTwo.isSelected) {
                price += (_klikitPrice(modifierLevelTwo.prices) * modifierLevelTwo.quantity);
              }
            }
          }
        }
      }
    }
    return price;
  }

  num _klikitPrice(List<ItemPrice> prices){
    return prices.firstWhere((element) => element.providerId == ProviderID.KLIKIT).price;
  }
}