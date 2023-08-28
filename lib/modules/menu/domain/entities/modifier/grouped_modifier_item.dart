import 'modifier_visibility.dart';

class GroupedModifierItem{
  final int menuVersion;
  final int id;
  final int businessID;
  final String title;
  final String description;
  final int sequence;
  final List<ModifierVisibility> visibilities;
  bool isEnabled;

  GroupedModifierItem({
    required this.menuVersion,
    required this.id,
    required this.businessID,
    required this.title,
    required this.description,
    required this.sequence,
    required this.isEnabled,
    required this.visibilities,
  });
}