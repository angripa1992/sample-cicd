import 'package:collection/collection.dart';
import 'package:docket_design_template/utils/constants.dart';

import 'grouped_modifier_item.dart';
import 'modifier_visibility.dart';

class ModifierGroup {
  final int menuVersion;
  final int id;
  final int businessID;
  final String title;
  final String description;
  final List<ModifierVisibility> visibilities;
  List<GroupedModifierItem> modifiers;
  bool isEnabled;

  ModifierGroup({
    required this.menuVersion,
    required this.id,
    required this.businessID,
    required this.title,
    required this.description,
    required this.isEnabled,
    required this.modifiers,
    required this.visibilities,
  });

  bool visible() {
    if (visibilities.isEmpty) return true;
    final itemVisibility = visibilities.firstWhereOrNull((element) => element.providerID == ProviderID.KLIKIT);
    return itemVisibility?.isVisible ?? true;
  }
}
