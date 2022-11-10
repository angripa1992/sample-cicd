import 'package:dio/dio.dart';
import 'package:klikit/core/network/rest_client.dart';
import 'package:klikit/modules/menu/data/models/menues_model.dart';
import 'package:klikit/modules/menu/data/models/modifiers_group_model.dart';
import 'package:klikit/modules/menu/data/models/stock_model.dart';
import 'package:klikit/modules/menu/domain/usecase/update_item.dart';
import 'package:klikit/modules/menu/domain/usecase/update_menu.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../../../app/enums.dart';
import '../../../../core/network/urls.dart';
import '../../domain/usecase/fetch_menus.dart';
import '../models/brands_model.dart';

abstract class MenuRemoteDatasource {
  Future<MenuBrandsModel> fetchMenuBrands(Map<String, dynamic> params);

  Future<MenusDataModel> fetchMenus(FetchMenuParams params);

  Future<StockModel> updateItem(UpdateItemParam params);

  Future<ActionSuccess> updateMenu(UpdateMenuParams params);

  Future<List<ModifiersGroupModel>> fetchModifiersGroup(
      Map<String, dynamic> params);
}

class MenuRemoteDatasourceImpl extends MenuRemoteDatasource {
  final RestClient _restClient;

  MenuRemoteDatasourceImpl(this._restClient);

  @override
  Future<MenuBrandsModel> fetchMenuBrands(Map<String, dynamic> params) async {
    try {
      final response =
          await _restClient.request(Urls.menuBrands, Method.GET, params);
      return MenuBrandsModel.fromJson(response);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<MenusDataModel> fetchMenus(FetchMenuParams params) async {
    try {
      final response = await _restClient.request(
        Urls.menus(params.branchId),
        Method.GET,
        {
          'brand_id': params.brandId,
          'provider_id': params.providerID,
        },
      );
      return MenusDataModel.fromJson(response);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<StockModel> updateItem(UpdateItemParam params) async {
    try {
      final response = await _restClient.request(
        Urls.updateItem(params.itemId),
        Method.PATCH,
        {
          'branch_id': params.branchId,
          'brand_id': params.brandId,
          'duration': params.duration,
          'is_enabled': params.enabled,
          'timezoneOffset': params.timeZoneOffset,
        },
      );
      return StockModel.fromJson(response);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> updateMenu(UpdateMenuParams params) async {
    try {
      final response = await _restClient.request(
        Urls.updateMenu(params.id, params.type),
        Method.PATCH,
        {
          'branch_id': params.branchId,
          'brand_id': params.brandId,
          'is_enabled': params.enabled,
        },
      );
      return ActionSuccess.fromJson(response);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<List<ModifiersGroupModel>> fetchModifiersGroup(
      Map<String, dynamic> params) async {
    try {
      final List<dynamic> response = await _restClient.request(Urls.modifiersGroup, Method.GET, params);
      return response.map((e) => ModifiersGroupModel.fromJson(e)).toList();
    } on DioError {
      rethrow;
    }
  }
}
