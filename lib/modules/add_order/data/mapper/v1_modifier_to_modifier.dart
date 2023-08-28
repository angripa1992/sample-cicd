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

List<MenuItemModifierGroup> mapAddOrderV1ModifierToModifier(
    List<MenuItemModifierGroupModel>? data) {
  return data?.map((e) => _v1ToModifierGroup(e)).toList() ?? [];
}

MenuItemModifierGroup _v1ToModifierGroup(
  MenuItemModifierGroupModel data,
) {
  return MenuItemModifierGroup(
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

MenuItemModifier _v1ToModifierItem(MenuItemModifierModel data) {
  return MenuItemModifier(
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

MenuItemModifierVisibility _v1ToModifierVisibility(
  MenuItemStatusModel data,
) {
  return MenuItemModifierVisibility(
    providerId: data.providerId.orZero(),
    visibility: !data.hidden.orFalse(),
  );
}

MenuItemModifierRule _v1ToModifierRule(MenuItemModifierRuleModel? data) {
  final type = data?.typeTitle ?? EMPTY;
  final value = data?.value ?? ZERO;
  final min = data?.min ?? ZERO;
  final max = data?.max ?? ZERO;
  return MenuItemModifierRule(
    min: type == RuleType.exact ? value : min,
    max: type == RuleType.exact ? value : max,
    id: data?.id ?? ZERO,
    title: data?.title ?? EMPTY,
    typeTitle: data?.typeTitle ?? EMPTY,
    value: data?.value ?? ZERO,
    brandId: data?.brandId ?? ZERO,
  );
}

MenuItemModifierPrice _v1ToItemPrice(MenuItemPriceModel data) {
  return MenuItemModifierPrice(
    providerId: data.providerId.orZero(),
    currencyId: data.currencyId.orZero(),
    code: data.code.orEmpty(),
    symbol: data.symbol.orEmpty(),
    price: data.price ?? 0,
  );
}

bool _enabled(List<MenuItemStatusModel>? data) {
  if (data != null) {
    for (var element in data) {
      if (element.providerId == ProviderID.KLIKIT) {
        return element.enabled ?? true;
      }
    }
  }
  return true;
}
