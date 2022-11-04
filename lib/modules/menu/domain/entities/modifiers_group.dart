import 'package:klikit/modules/menu/domain/entities/status.dart';

import 'modifiers.dart';

class ModifiersGroup {
  final int groupId;
  final String title;
  final bool defaultData;
  final List<Statuses> statuses;
  final List<Modifiers> modifiers;

  ModifiersGroup({
    required this.groupId,
    required this.title,
    required this.defaultData,
    required this.statuses,
    required this.modifiers,
  });
}