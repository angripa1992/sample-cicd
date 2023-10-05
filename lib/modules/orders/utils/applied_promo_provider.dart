import 'package:dio/dio.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/modules/orders/data/models/webshop_order_details_model.dart';

import '../../../app/session_manager.dart';
import '../../add_order/data/datasource/add_order_datasource.dart';
import '../../add_order/data/models/applied_promo.dart';

class AppliedPromoProvider {
  static final _instance = AppliedPromoProvider._internal();

  factory AppliedPromoProvider() => _instance;

  AppliedPromoProvider._internal();

  Future<List<Promo>> fetchPromos({
    required String productType,
    required num orderAmountInCent,
    required List<int> brandsID,
  }) async {
    try {
      final params = {
        'country': SessionManager().country(),
        'business': SessionManager().businessID(),
        'branch': SessionManager().branchId(),
        'product_type': productType,
        'order_amount': orderAmountInCent / 100,
        'brands': ListParam<int>(brandsID, ListFormat.csv),
      };
      final response = await getIt.get<AddOrderDatasource>().fetchPromos(params);
      return response;
    } catch (e) {
      return [];
    }
  }

  AppliedPromoInfo? appliedPromoInfoForWebShopOrder(WebShopOrderDetailsModel orderDetailsModel) {
    final promo = orderDetailsModel.appliedPromo;
    if (promo == null) return null;
    return AppliedPromoInfo(
      promo: promo,
      isSeniorCitizenPromo: promo.isSeniorCitizenPromo!,
      itemId: 0,
      promoId: promo.id,
      numberOfSeniorCitizen: orderDetailsModel.numberOfSeniorCitizen,
      numberOfCustomer: orderDetailsModel.numberOfCustomer,
      promoCode: promo.code,
    );
  }

  AppliedPromoInfo? appliedPromoInfo({
    required List<Promo> promos,
    required AppliedPromoInfo? orderPromo,
    required List<AppliedPromoInfo> itemPromos,
    bool isItemPromo = false,
    int itemId = 0,
  }) {
    try {
      if (promos.isEmpty) return null;
      if (isItemPromo) {
        if (itemPromos.isEmpty) return null;
        final itemPromo = itemPromos.firstWhere((element) => element.itemId == itemId);
        final promo = promos.firstWhere((element) => itemPromo.promoId == element.id);
        return _promoInfoFromAppliedPromo(appliedPromo: itemPromo, promo: promo, isItemPromo: true);
      } else {
        if (orderPromo == null) return null;
        final promo = promos.firstWhere((element) => orderPromo.promoId == element.id);
        return _promoInfoFromAppliedPromo(appliedPromo: orderPromo, promo: promo, isItemPromo: false);
      }
    } catch (e) {
      return null;
    }
  }

  AppliedPromoInfo _promoInfoFromAppliedPromo({
    required AppliedPromoInfo appliedPromo,
    required Promo promo,
    required bool isItemPromo,
  }) {
    int? citizen;
    int? customer;
    if (isItemPromo) {
      citizen = appliedPromo.quantityOfScPromoItem;
    } else {
      citizen = appliedPromo.numberOfSeniorCitizen;
      customer = appliedPromo.numberOfCustomer;
    }
    if (!appliedPromo.isSeniorCitizenPromo!) {
      citizen = null;
      customer = null;
    }
    if (citizen != null && citizen <= 0) {
      citizen = null;
    }
    if (customer != null && customer <= 0) {
      customer = null;
    }
    return AppliedPromoInfo(promo: promo, numberOfSeniorCitizen: citizen, numberOfCustomer: customer);
  }
}
