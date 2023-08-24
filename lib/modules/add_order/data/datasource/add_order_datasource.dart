import 'package:dio/dio.dart';

import '../../../../app/enums.dart';
import '../../../../core/network/rest_client.dart';
import '../../../../core/network/urls.dart';
import '../../../menu/data/models/menues_model.dart';
import '../models/applied_promo.dart';
import '../models/billing_request.dart';
import '../models/billing_response.dart';
import '../models/item_modifier_group.dart';
import '../models/order_source.dart';
import '../models/place_order_data.dart';
import '../models/placed_order_response.dart';

abstract class AddOrderDatasource {
  Future<MenusDataModel> fetchMenus(
      {required int branchId, required int brandId});

  Future<List<ItemModifierGroupModel>> fetchModifiers({required int itemId});

  Future<CartBillModel> calculateBill({required BillingRequestModel model});

  Future<List<AddOrderSourcesModel>> fetchSources();

  Future<PlacedOrderResponse> placeOrder(PlaceOrderDataModel body);

  Future<List<AppliedPromo>> fetchPromos(Map<String, dynamic> params);
}

class AddOrderDatasourceImpl extends AddOrderDatasource {
  final RestClient _restClient;

  AddOrderDatasourceImpl(this._restClient);

  @override
  Future<MenusDataModel> fetchMenus({
    required int branchId,
    required int brandId,
  }) async {
    try {
      final response = await _restClient.request(
        Urls.menus(branchId),
        Method.GET,
        {'brand_ids': brandId},
      );
      return MenusDataModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<ItemModifierGroupModel>> fetchModifiers(
      {required int itemId}) async {
    try {
      List<dynamic>? response = await _restClient.request(
        Urls.itmModifiers,
        Method.GET,
        {'item_id': itemId},
      );
      return response
              ?.map((e) => ItemModifierGroupModel.fromJson(e))
              .toList() ??
          [];
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<CartBillModel> calculateBill(
      {required BillingRequestModel model}) async {
    try {
      final response = await _restClient.request(
        Urls.calculateBill,
        Method.POST,
        model.toJson(),
      );
      return CartBillModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<AddOrderSourcesModel>> fetchSources() async {
    try {
      final List<dynamic>? responses =
          await _restClient.request(Urls.sources, Method.GET, null);
      return responses?.map((e) => AddOrderSourcesModel.fromJson(e)).toList() ??
          [];
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<PlacedOrderResponse> placeOrder(PlaceOrderDataModel body) async {
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
  Future<List<AppliedPromo>> fetchPromos(Map<String, dynamic> params) async {
    try {
      final List<dynamic>? response = await _restClient.request(
        Urls.promos,
        Method.GET,
        params,
      );
      return response?.map((e) => AppliedPromo.fromJson(e)).toList() ?? [];
    } on DioException {
      rethrow;
    }
  }
}
