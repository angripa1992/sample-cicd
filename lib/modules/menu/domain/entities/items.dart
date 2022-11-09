
import 'package:klikit/modules/menu/domain/entities/price.dart';
import 'package:klikit/modules/menu/domain/entities/status.dart';
import 'package:klikit/modules/menu/domain/entities/stock.dart';
import 'package:klikit/modules/menu/domain/entities/v2_data.dart';


class Items {
  final int id;
  final String title;
  final List<Prices> prices;
  final int vat;
  final String description;
  final String image;
  final bool enabled;
  final bool hidden;
  final List<Statuses> statuses;
  final int sequence;
  final int defaultItemId;
  Stock stock;
  final TitleV2 titleV2;
  final DescriptionV2 descriptionV2;

  Items({
    required this.id,
    required this.title,
    required this.prices,
    required this.vat,
    required this.description,
    required this.image,
    required this.enabled,
    required this.hidden,
    required this.statuses,
    required this.sequence,
    required this.defaultItemId,
    required this.stock,
    required this.titleV2,
    required this.descriptionV2,
  });
}