import 'package:klikit/app/extensions.dart';

import '../../domain/entities/item_price.dart';
import '../../domain/entities/menu/menu_branch_info.dart';
import '../models/v1_common_data_model.dart';
import '../models/v2_common_data_model.dart';

ItemPrice v1PriceToItemPrice(V1PricesModel data) {
  return ItemPrice(
    providerId: data.providerId.orZero(),
    currencyId: data.currencyId.orZero(),
    currencyCode: data.code.orEmpty(),
    price: data.price.orZero(),
    takeAwayPrice: data.price.orZero(),
    currencySymbol: data.symbol.orEmpty(),
    advancedPrice: _toAdvancedPrice(null),
  );
}

ItemPrice v2PriceToItemPrice(V2PriceModel data, MenuBranchInfo branchInfo, int id) {
  try {
    final v2PriceDetails = data.details!.firstWhere((element) => element.currencyCode!.toUpperCase() == branchInfo.currencyCode.toUpperCase());
    return ItemPrice(
      providerId: data.providerID.orZero(),
      currencyId: branchInfo.currencyID.orZero(),
      currencyCode: branchInfo.currencyCode,
      currencySymbol: branchInfo.currencySymbol,
      price: v2PriceDetails.price ?? ZERO,
      takeAwayPrice: v2PriceDetails.takeAwayPrice ?? ZERO,
      advancedPrice: _toAdvancedPrice(v2PriceDetails.advancedPricing),
    );
  } catch (e) {
    return ItemPrice(
      providerId: data.providerID.orZero(),
      currencyId: branchInfo.currencyID.orZero(),
      currencyCode: branchInfo.currencyCode,
      currencySymbol: branchInfo.currencySymbol,
      price: ZERO,
      takeAwayPrice: ZERO,
      advancedPrice: _toAdvancedPrice(null),
    );
  }
}

ItemAdvancedPrice _toAdvancedPrice(V2AdvancedPricingModel? advancePriceModel) {
  return ItemAdvancedPrice(
    delivery: advancePriceModel?.delivery ?? ZERO,
    dineIn: advancePriceModel?.dineIn ?? ZERO,
    pickup: advancePriceModel?.pickup ?? ZERO,
  );
}
