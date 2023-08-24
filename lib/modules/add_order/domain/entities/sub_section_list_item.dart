import '../../../menu/domain/entities/avilable_times.dart';
import '../../../menu/domain/entities/sub_section.dart';

class SubSectionListItem {
  final AvailableTimes availableTimes;
  final SubSections subSections;

  SubSectionListItem(this.availableTimes, this.subSections);
}
