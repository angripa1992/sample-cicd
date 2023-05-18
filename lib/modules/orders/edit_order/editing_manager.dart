import 'package:klikit/modules/orders/domain/entities/cart.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

class EditingManager{
  static final _instance = EditingManager._internal();
  factory EditingManager() => _instance;
  EditingManager._internal();

  List<List<CartV2>> extractCartItems(Order order){
    final brandSpecificCarts = <List<CartV2>>[];
    for (var brand in order.brands) {
      final cartItems = order.cartV2.where((element) => element.cartBrand.id == brand.id).toList();
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
            modifiers.add('${modifierLevelTwo.quantity}x ${modifierLevelTwo.name}');
          }
        }
      }
    }
    return modifiers.join(' , ');
  }

}