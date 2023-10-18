import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:klikit/modules/add_order/data/models/update_webshop_order_response.dart';
import 'package:klikit/modules/add_order/data/models/webshop_calculate_bill_response.dart';

import '../../../../app/di.dart';
import '../../../../app/enums.dart';
import '../../../../app/session_manager.dart';
import '../../../../core/network/public_rest_client.dart';
import '../../../../core/network/rest_client.dart';
import '../../../../core/network/urls.dart';
import '../../../../core/provider/date_time_provider.dart';
import '../../../../env/environment_variables.dart';
import '../../../menu/domain/entities/menu/menu_branch_info.dart';
import '../../domain/entities/modifier/item_modifier_group.dart';
import '../mapper/v1_modifier_to_modifier.dart';
import '../mapper/v2_modifier_to_modifier.dart';
import '../models/applied_promo.dart';
import '../models/billing_response.dart';
import '../models/modifier/item_modifier_group_model.dart';
import '../models/modifier/item_modifier_v2_data_model.dart';
import '../models/order_source.dart';
import '../models/placed_order_response.dart';
import '../models/request/billing_request.dart';
import '../models/request/place_order_data_request.dart';
import '../models/request/webshop_calculate_bill_payload.dart';
import '../models/request/webshop_pace_order_payload.dart';

abstract class AddOrderDatasource {
  Future<List<MenuItemModifierGroup>> fetchModifiers({required int itemID, required MenuBranchInfo branchInfo});

  Future<CartBillModel> calculateBill({required BillingRequestModel model});

  Future<WebShopCalculateBillResponse> webShopCalculateBill({required WebShopCalculateBillPayload model});

  Future<List<AddOrderSourcesModel>> fetchSources();

  Future<PlacedOrderResponse> placeOrder(PlaceOrderDataRequestModel body);

  Future<List<Promo>> fetchPromos(Map<String, dynamic> params);

  Future<UpdateWebShopOrderResponse> updateWebShopOrder(int id, WebShopPlaceOrderPayload payload);
}

class AddOrderDatasourceImpl extends AddOrderDatasource {
  final RestClient _restClient;

  AddOrderDatasourceImpl(this._restClient);

  @override
  Future<List<MenuItemModifierGroup>> fetchModifiers({
    required int itemID,
    required MenuBranchInfo branchInfo,
  }) async {
    try {
      if (SessionManager().user()!.menuV2EnabledForKlikitOrder) {
        List<dynamic>? response = await _restClient.request(
          Urls.itmModifiersV2,
          Method.GET,
          {
            'itemIDs': itemID,
            'businessID': branchInfo.businessID,
            'brandID': branchInfo.brandID,
            'branchID': branchInfo.branchID,
          },
        );
        if (response != null && response.isNotEmpty) {
          final modifierGroupsResponse = response.first as List<dynamic>;
          final v2Modifiers = modifierGroupsResponse.map((e) => V2ItemModifierGroupModel.fromJson(e)).toList();
          return mapAddOrderV2ModifierToModifier(v2Modifiers, branchInfo);
        } else {
          return [];
        }
      } else {
        List<dynamic>? response = await _restClient.request(
          Urls.itmModifiers,
          Method.GET,
          {'item_id': itemID},
        );
        final v1Modifiers = response?.map((e) => MenuItemModifierGroupModel.fromJson(e)).toList() ?? [];
        return mapAddOrderV1ModifierToModifier(v1Modifiers);
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<CartBillModel> calculateBill({required BillingRequestModel model}) async {
    try {
      if (SessionManager().menuV2EnabledForKlikitOrder()) {
        final response = await _restClient.request(
          Urls.calculateBillV2,
          Method.POST,
          model.toJsonV2(),
        );
        return CartBillModel.fromJson(response);
      } else {
        final response = await _restClient.request(
          Urls.calculateBill,
          Method.POST,
          model.toJsonV1(),
        );
        return CartBillModel.fromJson(response);
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<AddOrderSourcesModel>> fetchSources() async {
    try {
      final List<dynamic>? responses = await _restClient.request(Urls.sources, Method.GET, null);
      return responses?.map((e) => AddOrderSourcesModel.fromJson(e)).toList() ?? [];
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<PlacedOrderResponse> placeOrder(PlaceOrderDataRequestModel body) async {
    try {
      final response = await _restClient.request(
        Urls.manualOrder,
        Method.POST,
        body.toJson(),
      );
      return PlacedOrderResponse.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<Promo>> fetchPromos(Map<String, dynamic> params) async {
    try {
      final timezone = await DateTimeProvider.timeZone();
      params['timezone'] = timezone;
      final List<dynamic>? response = await _restClient.request(
        Urls.promos,
        Method.GET,
        params,
      );
      return response?.map((e) => Promo.fromJson(e)).toList() ?? [];
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<WebShopCalculateBillResponse> webShopCalculateBill({required WebShopCalculateBillPayload model}) async {
    try {
      final str = json.encode(model.toJson());
      final response = await PublicRestClient().request(
        '${getIt.get<EnvironmentVariables>().consumerUrl}${Urls.webShopCalculateBill}',
        Method.POST,
        model.toJson(),
      );
      return WebShopCalculateBillResponse.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<UpdateWebShopOrderResponse> updateWebShopOrder(int id, WebShopPlaceOrderPayload payload) async {
    try {
      final str = json.encode(payload.toJson());
      final response = await _restClient.request(
        Urls.updateWebShopOrder(id),
        Method.PATCH,
        payload.toJson(),
      );
      return UpdateWebShopOrderResponse(message: 'Order Successfully Updated');
    } on DioException {
      rethrow;
    }
  }
}
