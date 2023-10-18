import 'package:dio/dio.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

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

  Future<AppliedPromoInfo?> appliedPromoInfoForWebShopOrder(Order order) async {
    final appliedPromo = order.orderAppliedPromo;
    if (appliedPromo == null) return null;
    final promos = await AppliedPromoProvider().fetchPromos(
      productType: 'web_shop',
      orderAmountInCent: order.itemPrice,
      brandsID: order.brands.map((e) => e.id).toList(),
    );
    final promo = promos.firstWhere((element) => appliedPromo.promoId == element.id);
    return AppliedPromoInfo(
      promo: promo,
      isSeniorCitizenPromo: appliedPromo.isSeniorCitizenPromo,
      itemId: 0,
      promoId: promo.id,
      numberOfSeniorCitizen: appliedPromo.numberOfSeniorCitizen,
      numberOfCustomer: appliedPromo.numberOfCustomer,
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
