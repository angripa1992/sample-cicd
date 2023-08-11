import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';

import '../../domain/entities/modifier/item_modifier.dart';
import '../../domain/entities/modifier/item_modifier_group.dart';
import '../../domain/entities/modifier/item_price.dart';
import '../../domain/entities/modifier/item_visibility.dart';
import '../../domain/entities/modifier/modifier_rule.dart';
import '../models/modifier/item_modifier_group_model.dart';
import '../models/modifier/item_modifier_model.dart';
import '../models/modifier/item_price_model.dart';
import '../models/modifier/item_status_model.dart';
import '../models/modifier/modifier_rule.dart';

List<AddOrderItemModifierGroup> mapAddOrderV1ModifierToModifier(List<AddOrderItemModifierGroupModel>? data){
  return data?.map((e) => _v1ToModifierGroup(e)).toList() ?? [];
}

AddOrderItemModifierGroup _v1ToModifierGroup(
  AddOrderItemModifierGroupModel data
) {
  return AddOrderItemModifierGroup(
    groupId: data.groupId.orZero(),
    title: data.title.orEmpty(),
    label: data.label.orEmpty(),
    brandId: data.brandId.orZero(),
    sequence: data.sequence.orZero(),
    enabled: _enabled(data.statuses),
    visibilities:
        data.statuses?.map((e) => _v1ToModifierVisibility(e)).toList() ?? [],
    rule: _v1ToModifierRule(data.rule),
    modifiers: data.modifiers?.map((e) => _v1ToModifierItem(e)).toList() ?? [],
  );
}

AddOrderItemModifier _v1ToModifierItem(AddOrderItemModifierModel data) {
  return AddOrderItemModifier(
    id: data.id.orZero(),
    modifierId: data.modifierId.orZero(),
    immgId: data.immgId.orZero(),
    title: data.title.orEmpty(),
    sequence: data.sequence.orZero(),
    enabled: _enabled(data.statuses),
    visibilities:
        data.statuses?.map((e) => _v1ToModifierVisibility(e)).toList() ?? [],
    prices: data.prices?.map((e) => _v1ToItemPrice(e)).toList() ?? [],
    groups: data.groups?.map((e) => _v1ToModifierGroup(e)).toList() ?? [],
  );
}

AddOrderModifierItemVisibility _v1ToModifierVisibility(
  AddOrderItemStatusModel data,
) {
  return AddOrderModifierItemVisibility(
    providerId: data.providerId.orZero(),
    visibility: !data.hidden.orFalse(),
  );
}

AddOrderItemModifierRule _v1ToModifierRule(ModifierRuleModel? data) {
  return AddOrderItemModifierRule(
    id: data?.id ?? ZERO,
    title: data?.title ?? EMPTY,
    typeTitle: data?.typeTitle ?? EMPTY,
    value: data?.value ?? ZERO,
    brandId: data?.brandId ?? ZERO,
    min: data?.min ?? ZERO,
    max: data?.max ?? ZERO,
  );
}

AddOrderModifierItemPrice _v1ToItemPrice(AddOrderItemPriceModel data) {
  return AddOrderModifierItemPrice(
    providerId: data.providerId.orZero(),
    currencyId: data.currencyId.orZero(),
    code: data.code.orEmpty(),
    symbol: data.symbol.orEmpty(),
    price: data.price ?? 0,
  );
}

bool _enabled(List<AddOrderItemStatusModel>? data) {
  if (data != null) {
    for (var element in data) {
      if (element.providerId == ProviderID.KLIKIT) {
        return element.enabled ?? true;
      }
    }
  }
  return true;
}
