import 'package:docket_design_template/model/brand.dart';
import 'package:docket_design_template/model/cart.dart';
import 'package:docket_design_template/model/modifiers.dart';
import 'package:docket_design_template/model/order.dart';
import 'package:docket_design_template/model/rider_info.dart';
import 'package:docket_design_template/utils/date_time_provider.dart';
import 'package:docket_design_template/utils/extension.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/modules/orders/domain/entities/cart.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../app/di.dart';
import '../../modules/common/business_information_provider.dart';
import '../../modules/common/entities/brand.dart';

class PrinterDataProvider {
  static final _instance = PrinterDataProvider._internal();

  factory PrinterDataProvider() => _instance;

  PrinterDataProvider._internal();

  Future<TemplateOrder> createTemplateOrderData({
    required Brand? brand,
    required Order order,
  }) async {
    final branchInfo = await getIt.get<BusinessInformationProvider>().branchByID(SessionManager().branchId());
    return TemplateOrder(
      id: order.id,
      externalId: order.externalId,
      shortId: order.shortId,
      providerId: order.providerId,
      status: order.status,
      itemPrice: order.itemPrice,
      finalPrice: order.finalPrice,
      discount: order.discount,
      customerDiscount: order.customerDiscount,
      deliveryFee: order.deliveryFee,
      additionalFee: order.additionalFee,
      vat: order.vat,
      currency: order.currency,
      currencySymbol: order.currencySymbol,
      itemCount: order.itemCount,
      createdAt: order.createdAt,
      userFirstName: order.userFirstName,
      userLastName: order.userLastName,
      isInterceptorOrder: order.isInterceptorOrder,
      orderComment: order.orderComment,
      type: order.type,
      klikitComment: order.klikitComment,
      cartV2: _createTemplateCartsList(order.cartV2),
      brands: _createTemplateCartsBrandList(order.brands),
      placedOn: order.orderSource.title,
      qrInfo: _createQrInfo(brand),
      paymentStatus: order.paymentStatus,
      paymentMethod: order.paymentMethod,
      gatewayFee: order.gatewayFee,
      serviceFee: order.serviceFee,
      restaurantServiceFee: order.restaurantServiceFee,
      tableNo: order.tableNo,
      branchName: SessionManager().branchName(),
      isManualOrder: order.isManualOrder,
      isFoodpandaApiOrder: order.isFoodpandaApiOrder,
      isVatIncluded: order.isVatIncluded,
      isThreePlOrder: order.isThreePlOrder,
      fulfillmentDeliveredTime: order.fulfillmentDeliveredTime,
      fulfillmentExpectedPickupTime: order.fulfillmentExpectedPickupTime,
      fulfillmentStatusId: order.fulfillmentStatusId,
      fulfillmentPickupPin: order.fulfillmentPickupPin,
      fulfillmentTrackingUrl: order.fulfillmentTrackingUrl,
      pickupAt: order.estimatedPickUpAt.isNotEmpty ? DateTimeProvider.pickupTime(order.estimatedPickUpAt) : order.estimatedPickUpAt,
      deliveryTime: order.estimatedDeliveryAt.isNotEmpty ? DateTimeProvider.pickupTime(order.estimatedDeliveryAt) : order.estimatedDeliveryAt,
      providerSubTotal: order.providerSubTotal,
      providerGrandTotal: order.providerGrandTotal,
      providerAdditionalFee: order.providerAdditionalFee,
      queueNo: order.queueNo,
      paidByCustomer: order.feePaidByCustomer,
      rewardDiscount: order.rewardDiscount,
      customFee: order.customFee,
      mergeFee: order.mergeFee,
      customFeeTitle: branchInfo?.webshopCustomFeesTitle ?? 'Packaging Fee',
      mergeFeeTitle: branchInfo?.mergeFeeTitle ?? EMPTY,
      mergeFeeEnabled: branchInfo?.mergeFeeEnabled ?? false,
      roundOffAmount: order.roundOffAmount,
      providerRoundOffAmount: order.providerRoundOffAmount,
      gatewayFeePaidByCustomer: order.gatewayFeePaidByCustomer,
      serviceFeePaidByCustomer: order.serviceFeePaidByCustomer,
      isMerchantDelivery: order.isMerchantDelivery,
      deliveryAddress: order.deliveryAddress,
      fulfillmentRider: order.fulfillmentRider != null
          ? RiderInfo(
              name: order.fulfillmentRider?.name,
              phone: order.fulfillmentRider?.phone,
              email: order.fulfillmentRider?.email,
              licensePlate: order.fulfillmentRider?.licensePlate,
              photoUrl: order.fulfillmentRider?.photoUrl,
              coordinates: order.fulfillmentRider?.coordinates != null
                  ? Coordinates(
                      latitude: order.fulfillmentRider?.coordinates?.latitude,
                      longitude: order.fulfillmentRider?.coordinates?.longitude,
                    )
                  : null,
            )
          : null,
    );
  }

  QrInfo? _createQrInfo(Brand? brand) {
    if (brand != null && brand.qrContent.isNotEmpty) {
      return QrInfo(
        brandId: brand.id,
        qrLabel: brand.qrLabel,
        qrContent: brand.qrContent,
      );
    }
    return null;
  }

  TemplateCart _createTemplateCart(CartV2 cartV2) {
    return TemplateCart(
      id: cartV2.id,
      name: cartV2.name,
      image: cartV2.image,
      price: cartV2.price,
      comment: cartV2.comment,
      quantity: cartV2.quantity,
      unitPrice: cartV2.unitPrice,
      cartBrand: _createTemplateCartBrand(cartV2.cartBrand),
      modifierGroups: __createTemplateModifiersGroupsList(cartV2.modifierGroups),
    );
  }

  TemplateModifiers _createTemplateModifiers(Modifiers modifiers) {
    return TemplateModifiers(
      id: modifiers.id,
      name: modifiers.name,
      price: modifiers.price,
      quantity: modifiers.quantity,
      unitPrice: modifiers.unitPrice,
      modifierGroups: __createTemplateModifiersGroupsList(modifiers.modifierGroups),
    );
  }

  TemplateModifierGroups _createTemplateModifierGroups(ModifierGroups modifierGroups) {
    return TemplateModifierGroups(
      id: modifierGroups.id,
      name: modifierGroups.name,
      modifiers: __createTemplateModifiersList(modifierGroups.modifiers),
    );
  }

  TemplateCartBrand _createTemplateCartBrand(CartBrand cartBrand) {
    return TemplateCartBrand(
      id: cartBrand.id,
      title: cartBrand.title,
      logo: cartBrand.logo,
    );
  }

  List<TemplateModifierGroups> __createTemplateModifiersGroupsList(List<ModifierGroups> modifierGroups) {
    List<TemplateModifierGroups> templateModifiersGroups = [];
    for (var element in modifierGroups) {
      templateModifiersGroups.add(_createTemplateModifierGroups(element));
    }
    return templateModifiersGroups;
  }

  List<TemplateModifiers> __createTemplateModifiersList(List<Modifiers> modifiers) {
    List<TemplateModifiers> templateModifiers = [];
    for (var element in modifiers) {
      templateModifiers.add(_createTemplateModifiers(element));
    }
    return templateModifiers;
  }

  List<TemplateCartBrand> _createTemplateCartsBrandList(List<CartBrand> brands) {
    List<TemplateCartBrand> templateBrands = [];
    for (var cartBrand in brands) {
      templateBrands.add(_createTemplateCartBrand(cartBrand));
    }
    return templateBrands;
  }

  List<TemplateCart> _createTemplateCartsList(List<CartV2> cartV2) {
    List<TemplateCart> templateCarts = [];
    for (var cart in cartV2) {
      templateCarts.add(_createTemplateCart(cart));
    }
    return templateCarts;
  }
}
