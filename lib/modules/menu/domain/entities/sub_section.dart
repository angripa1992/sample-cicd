import 'package:klikit/modules/menu/domain/entities/status.dart';
import 'package:klikit/modules/menu/domain/entities/v2_data.dart';

import 'items.dart';

class SubSections {
  final int id;
  final String title;
  final String description;
  final bool hidden;
  final bool alcBeverages;
  final List<Statuses> statuses;
  final int sequence;
  final TitleV2 titleV2;
  final DescriptionV2 descriptionV2;
  bool enabled;
  List<MenuItems> items;

  SubSections({
    required this.id,
    required this.title,
    required this.description,
    required this.enabled,
    required this.hidden,
    required this.alcBeverages,
    required this.statuses,
    required this.sequence,
    required this.titleV2,
    required this.descriptionV2,
    required this.items,
  });
}
