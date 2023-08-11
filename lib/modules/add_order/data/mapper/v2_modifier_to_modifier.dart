import 'package:klikit/app/extensions.dart';

import '../../../menu/data/models/v2_common_data_model.dart';
import '../../domain/entities/modifier/item_modifier.dart';
import '../../domain/entities/modifier/item_modifier_group.dart';
import '../../domain/entities/modifier/item_price.dart';
import '../../domain/entities/modifier/item_visibility.dart';
import '../../domain/entities/modifier/modifier_rule.dart';
import '../models/modifier/item_modifier_v2_data_model.dart';

AddOrderItemModifierGroup _v2ToModifierGroup(
  V2ItemModifierGroupModel data,
  int brandID,
) {
  return AddOrderItemModifierGroup(
    groupId: data.id.orZero(),
    title: data.title?.en ?? EMPTY,
    label: data.description?.en ?? EMPTY,
    brandId: brandID,
    sequence: data.sequence.orZero(),
    enabled: data.enabled ?? true,
    visibilities:
        data.visibilities?.map((e) => _v2ToModifierVisibility(e)).toList() ??
            [],
    rule: _v2ToModifierRule(
      data.max.orZero(),
      data.min.orZero(),
      brandID,
    ),
    modifiers:
        data.modifiers?.map((e) => _v1ToModifierItem(e, brandID)).toList() ??
            [],
  );
}

AddOrderItemModifier _v1ToModifierItem(V2ItemModifierModel data, int brandID) {
  return AddOrderItemModifier(
    id: data.id.orZero(),
    modifierId: data.id.orZero(),
    immgId: ZERO,
    title: data.title?.en ?? EMPTY,
    sequence: ZERO,
    enabled: data.enabled ?? true,
    visibilities:
        data.visibilities?.map((e) => _v2ToModifierVisibility(e)).toList() ??
            [],
    prices: data.prices?.map((e) => _v2ToItemPrice(e)).toList() ?? [],
    groups:
        data.groups?.map((e) => _v2ToModifierGroup(e, brandID)).toList() ?? [],
  );
}

AddOrderItemModifierRule _v2ToModifierRule(
  int max,
  int min,
  int brandID,
) {
  return AddOrderItemModifierRule(
    id: ZERO,
    title: EMPTY,
    typeTitle: EMPTY,
    value: ZERO,
    brandId: brandID,
    min: min,
    max: max,
  );
}

AddOrderModifierItemVisibility _v2ToModifierVisibility(V2VisibilityModel data) {
  return AddOrderModifierItemVisibility(
    providerId: data.providerID.orZero(),
    visibility: data.status ?? true,
  );
}

AddOrderModifierItemPrice _v2ToItemPrice(V2PriceModel data) {
  final priceDetails = data.details!.first;
  return AddOrderModifierItemPrice(
    providerId: data.providerID.orZero(),
    currencyId: ZERO,
    code: priceDetails.currencyCode.orEmpty(),
    symbol: priceDetails.currencyCode.orEmpty(),
    price: priceDetails.price ?? 0,
  );
}
