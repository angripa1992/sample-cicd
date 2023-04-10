import 'package:klikit/modules/add_order/data/models/item_stock.dart';

class ItemStock {
  bool available;
  ItemSnooze snooze;

  ItemStock({required this.available, required this.snooze});

  ItemStockModel toModel() => ItemStockModel(
        available: available,
        snooze: snooze.toModel(),
      );
}

class ItemSnooze {
  String endTime;
  int duration;

  ItemSnooze({
    required this.endTime,
    required this.duration,
  });

  ItemSnoozeModel toModel() => ItemSnoozeModel(
        endTime: endTime,
        duration: duration,
      );
}
