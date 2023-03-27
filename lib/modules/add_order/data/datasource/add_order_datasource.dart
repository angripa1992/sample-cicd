import 'package:dio/dio.dart';

import '../../../../app/enums.dart';
import '../../../../core/network/rest_client.dart';
import '../../../../core/network/urls.dart';
import '../../../menu/data/models/menues_model.dart';
import '../models/item_modifier_group.dart';

abstract class AddOrderDatasource {
  Future<MenusDataModel> fetchMenus(
      {required int branchId, required int brandId});

  Future<List<ItemModifierGroupModel>> fetchModifiers({required int itemId});
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
    } on DioError {
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
      return response?.map((e) => ItemModifierGroupModel.fromJson(e)).toList() ?? [];
    } on DioError {
      rethrow;
    }
  }
}
