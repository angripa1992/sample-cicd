import 'package:klikit/modules/menu/domain/entities/price.dart';
import 'package:klikit/modules/menu/domain/entities/status.dart';

class Modifiers {
  final int modifierId;
  final String title;
  final int sequence;
  final bool defaultData;
  final List<Prices> prices;
  final List<Statuses> statuses;
  dynamic meta;

  Modifiers({
    required this.modifierId,
    required this.title,
    required this.sequence,
    required this.defaultData,
    required this.prices,
    required this.statuses,
    required this.meta,
  });
}
