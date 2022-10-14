
import 'package:klikit/modules/orders/domain/entities/cart.dart';

import '../../modules/orders/domain/entities/order.dart';

class ModifierGroupInfo{
  final String name;
  final List<ModifierInfo> modifiers;

  ModifierGroupInfo(this.name, this.modifiers);
}

class ModifierInfo{
  final int quantity;
  final String name;

  ModifierInfo(this.quantity, this.name);
}

class ModifierProvider{
  void orderDetails(Order order){
    final List<ModifierGroupInfo> levelOne = [];
    final List<ModifierGroupInfo> levelTwo = [];
    for(var cart in order.cartV2){
      for(var mg in cart.modifierGroups){
        for(var m in mg.modifiers){
          //levelTwo.add(_getModifierGroupInfo(m.modifierGroups));
        }
      }
    }
  }
  ModifierGroupInfo _getModifierGroupInfo(ModifierGroups modifierGroups){
    final modifiers = <ModifierInfo>[];
    for(var modifier in modifierGroups.modifiers){
      modifiers.add(_getModifierInfo(modifier));
    }
    return ModifierGroupInfo(modifierGroups.name, modifiers);
  }

  ModifierInfo _getModifierInfo(Modifiers modifiers){
    return ModifierInfo(modifiers.quantity, modifiers.name);
  }
}
