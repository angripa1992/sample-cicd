import 'package:docket_design_template/utils/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_branch_info.dart';

import '../../../menu/data/models/v2_common_data_model.dart';
import '../../domain/entities/modifier/item_modifier.dart';
import '../../domain/entities/modifier/item_modifier_group.dart';
import '../../domain/entities/modifier/item_price.dart';
import '../../domain/entities/modifier/item_visibility.dart';
import '../../domain/entities/modifier/modifier_rule.dart';
import '../models/modifier/item_modifier_v2_data_model.dart';

List<MenuItemModifierGroup> mapAddOrderV2ModifierToModifier(
  List<V2ItemModifierGroupModel>? data,
  MenuBranchInfo branchInfo,
  int orderType,
) {
  return data?.map((e) => _v2ToModifierGroup(e, branchInfo, orderType)).toList() ?? [];
}

MenuItemModifierGroup _v2ToModifierGroup(
  V2ItemModifierGroupModel data,
  MenuBranchInfo branchInfo,
  int type,
) {
  return MenuItemModifierGroup(
    groupId: data.id.orZero(),
    title: data.title?.en ?? EMPTY,
    label: data.description?.en ?? EMPTY,
    brandId: branchInfo.brandID!,
    sequence: data.sequence.orZero(),
    enabled: data.enabled ?? true,
    visibilities: data.visibilities?.map((e) => _v2ToModifierVisibility(e)).toList() ?? [],
    rule: _v2ToModifierRule(data.max.orZero(), data.min.orZero()),
    modifiers: data.modifiers
            ?.map((modifier) => _v1ToModifierItem(
                  data.id.orZero(),
                  type,
                  data.title?.en ?? EMPTY,
                  modifier,
                  branchInfo,
                ))
            .toList() ??
        [],
  );
}

MenuItemModifier _v1ToModifierItem(
  int groupID,
  int type,
  String groupName,
  V2ItemModifierModel data,
  MenuBranchInfo branchInfo,
) {
  return MenuItemModifier(
    id: data.id.orZero(),
    modifierId: data.id.orZero(),
    modifierGroupId: groupID,
    modifierGroupName: groupName,
    immgId: ZERO,
    skuID: EMPTY,
    title: data.title?.en ?? EMPTY,
    sequence: ZERO,
    enabled: data.enabled ?? true,
    visibilities: data.visibilities?.map((e) => _v2ToModifierVisibility(e)).toList() ?? [],
    prices: data.prices?.map((e) => _v2ToItemPrice(e, branchInfo, type)).toList() ?? [],
    groups: data.groups?.map((e) => _v2ToModifierGroup(e, branchInfo, type)).toList() ?? [],
  );
}

MenuItemModifierRule _v2ToModifierRule(
  int max,
  int min,
) {
  return MenuItemModifierRule(
    id: ZERO,
    title: EMPTY,
    typeTitle: EMPTY,
    value: ZERO,
    brandId: ZERO,
    min: min,
    max: max,
  );
}

MenuItemModifierVisibility _v2ToModifierVisibility(V2VisibilityModel data) {
  return MenuItemModifierVisibility(
    providerId: data.providerID.orZero(),
    visibility: data.status ?? true,
  );
}

MenuItemModifierPrice _v2ToItemPrice(
  V2PriceModel data,
  MenuBranchInfo branchInfo,
  int type,
) {
  final priceDetails = data.details!.firstWhere((element) => element.currencyCode!.toUpperCase() == branchInfo.currencyCode.toUpperCase());
  num price = ZERO;
  if (type == OrderType.DELIVERY) {
    price = priceDetails.advancedPricing?.delivery ?? ZERO;
  } else if (type == OrderType.PICKUP) {
    price = priceDetails.advancedPricing?.pickup ?? ZERO;
  } else {
    price = price = priceDetails.advancedPricing?.dineIn ?? ZERO;
  }
  return MenuItemModifierPrice(
    providerId: data.providerID.orZero(),
    currencyId: branchInfo.currencyID,
    code: branchInfo.currencyCode,
    symbol: branchInfo.currencySymbol,
    price: price,
  );
}
