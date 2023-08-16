import 'package:klikit/modules/add_order/data/models/modifier/item_stock_model.dart';

class MenuItemModifierOutOfStock {
  bool available;
  MenuItemSnooze snooze;

  MenuItemModifierOutOfStock({required this.available, required this.snooze});

  MenuItemOutOfStockModel toModel() => MenuItemOutOfStockModel(
        available: available,
        snooze: snooze.toModel(),
      );
}

class MenuItemSnooze {
  String endTime;
  int duration;

  MenuItemSnooze({
    required this.endTime,
    required this.duration,
  });

  MenuItemSnoozeModel toModel() => MenuItemSnoozeModel(
        endTime: endTime,
        duration: duration,
      );
}
