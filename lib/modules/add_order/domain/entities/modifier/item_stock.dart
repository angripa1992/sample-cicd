import 'package:klikit/modules/add_order/data/models/modifier/item_stock_model.dart';

class AddOrderModifierItemOos {
  bool available;
  AddOrderItemSnooze snooze;

  AddOrderModifierItemOos({required this.available, required this.snooze});

  AddOrderItemStockModel toModel() => AddOrderItemStockModel(
        available: available,
        snooze: snooze.toModel(),
      );
}

class AddOrderItemSnooze {
  String endTime;
  int duration;

  AddOrderItemSnooze({
    required this.endTime,
    required this.duration,
  });

  AddOrderItemSnoozeModel toModel() => AddOrderItemSnoozeModel(
        endTime: endTime,
        duration: duration,
      );
}
