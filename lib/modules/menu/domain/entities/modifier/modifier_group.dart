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
}
