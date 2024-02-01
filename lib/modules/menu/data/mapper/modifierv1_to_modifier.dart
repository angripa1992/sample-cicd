import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/menu/data/mapper/price_mapper.dart';

import '../../../../app/constants.dart';
import '../../../../app/session_manager.dart';
import '../../domain/entities/modifier/grouped_modifier_item.dart';
import '../../domain/entities/modifier/modifier_group.dart';
import '../../domain/entities/modifier/modifier_visibility.dart';
import '../models/modifier/modifier_v1_data.dart';

List<ModifierGroup> mapModifierV1ToModifier(List<V1ModifierGroupModel>? data) {
  return data?.map((e) => _v1ToModifierGroup(e)).toList() ?? [];
}

ModifierGroup _v1ToModifierGroup(V1ModifierGroupModel data) {
  return ModifierGroup(
    menuVersion: MenuVersion.v1,
    id: data.groupId.orZero(),
    businessID: SessionManager().businessID(),
    title: data.title.orEmpty(),
    description: EMPTY,
    isEnabled: data.statuses?[0].enabled ?? true,
    modifiers: data.modifiers?.map((e) => _v1ToModifier(e)).toList() ?? [],
    visibilities: data.statuses?.map((e) => _v1ToVisibility(e)).toList() ?? [],
  );
}

GroupedModifierItem _v1ToModifier(V1GroupedModifierItemModel data) {
  return GroupedModifierItem(
    menuVersion: MenuVersion.v1,
    id: data.modifierId.orZero(),
    businessID: SessionManager().businessID(),
    title: data.title.orEmpty(),
    description: EMPTY,
    sequence: data.sequence.orZero(),
    isEnabled: data.statuses?[0].enabled ?? true,
    visibilities: data.statuses?.map((e) => _v1ToVisibility(e)).toList() ?? [],
    prices: data.prices?.map((e) => v1PriceToItemPrice(e)).toList() ?? [],
  );
}

ModifierVisibility _v1ToVisibility(V1StatusesModel data) {
  return ModifierVisibility(
    providerID: data.providerId.orZero(),
    isVisible: !data.hidden.orFalse(),
  );
}
