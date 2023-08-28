import 'package:klikit/app/extensions.dart';

import '../../../../app/constants.dart';
import '../../../../app/session_manager.dart';
import '../../domain/entities/modifier/grouped_modifier_item.dart';
import '../../domain/entities/modifier/modifier_group.dart';
import '../../domain/entities/modifier/modifier_visibility.dart';
import '../models/modifier/modifier_v2_data.dart';
import '../models/v2_common_data_model.dart';

List<ModifierGroup> mapModifierV2ToModifier(List<V2ModifierGroupModel>? data) {
  return data?.map((e) => _v2ToModifierGroup(e)).toList() ?? [];
}

ModifierGroup _v2ToModifierGroup(V2ModifierGroupModel data) {
  final businessID = data.businessID ?? SessionManager().businessID();
  return ModifierGroup(
    menuVersion: MenuVersion.v2,
    id: data.id.orZero(),
    businessID: businessID,
    title: data.title?.en ?? EMPTY,
    description: data.description?.en ?? EMPTY,
    isEnabled: data.isEnabled.orFalse(),
    modifiers: data.groupedModifiers
            ?.map((e) => _v2ToModifier(e, businessID))
            .toList() ??
        [],
    visibilities:
        data.visibilities?.map((e) => _v2ToVisibility(e)).toList() ?? [],
  );
}

GroupedModifierItem _v2ToModifier(
  V2GroupedModifiersModel data,
  int businessID,
) {
  return GroupedModifierItem(
    menuVersion: MenuVersion.v2,
    id: data.id.orZero(),
    businessID: businessID,
    title: data.title?.en ?? EMPTY,
    description: data.description?.en ?? EMPTY,
    sequence: data.sequence.orZero(),
    isEnabled: data.isEnabled.orFalse(),
    visibilities:
        data.visibilities?.map((e) => _v2ToVisibility(e)).toList() ?? [],
  );
}

ModifierVisibility _v2ToVisibility(V2VisibilityModel data) {
  return ModifierVisibility(
    providerID: data.providerID.orZero(),
    isVisible: data.status.orFalse(),
  );
}
