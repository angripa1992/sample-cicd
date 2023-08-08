import 'package:dio/dio.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/core/network/rest_client.dart';
import 'package:klikit/modules/menu/data/models/modifier_disabled_response_model.dart';
import 'package:klikit/modules/menu/data/models/modifier_request_model.dart';
import 'package:klikit/modules/menu/data/models/modifiers_group_model.dart';
import 'package:klikit/modules/menu/domain/usecase/update_item.dart';
import 'package:klikit/modules/menu/domain/usecase/update_menu.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../../../app/enums.dart';
import '../../../../core/network/urls.dart';
import '../../../../core/provider/date_time_provider.dart';
import '../../domain/usecase/fetch_menus.dart';
import '../models/brand_model.dart';
import '../models/brands_model.dart';
import '../models/menu/menu_out_of_stock_model.dart';
import '../models/menu/menu_v1_data.dart';
import '../models/menu/menu_v2_data.dart';

abstract class MenuRemoteDatasource {
  Future<MenuBrandsModel> fetchMenuBrands(Map<String, dynamic> params);

  Future<MenuBrandModel> fetchMenuBrand({
    required int brandId,
    required int branchId,
  });

  Future<MenuV1MenusDataModel> fetchMenuV1(FetchMenuParams params);

  Future<MenuV2DataModel> fetchMenuV2(FetchMenuParams params);

  Future<MenuOutOfStockModel> updateItem(UpdateItemParam params);

  Future<ActionSuccess> updateMenu(UpdateMenuParams params);

  Future<List<ModifiersGroupModel>> fetchModifiersGroup(
      Map<String, dynamic> params);

  Future<ModifierDisabledResponseModel> disableModifier(
    ModifierRequestModel param,
  );

  Future<ActionSuccess> enableModifier(ModifierRequestModel param);
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
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<MenuV1MenusDataModel> fetchMenuV1(FetchMenuParams params) async {
    try {
      final fetchParams = <String,dynamic>{
        'brand_id': params.brandId,
      };
      if(params.providerID != null){
        fetchParams['provider_id'] = params.providerID;
      }
      final response = await _restClient.request(
        Urls.menuV1(params.branchId),
        Method.GET,
        fetchParams,
      );
      return MenuV1MenusDataModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<MenuV2DataModel> fetchMenuV2(FetchMenuParams params) async{
    try {
      final tz = await DateTimeProvider.timeZone();
      final fetchParams = <String,dynamic>{
        'businessID' : params.businessId,
        'brandID': params.brandId,
        'branchID': params.branchId,
        'tz' : tz,
      };
      if(params.providerID != null){
        fetchParams['providerID'] = params.providerID;
      }
      final response = await _restClient.request(
        Urls.menuV2,
        Method.GET,
        fetchParams,
      );
      return MenuV2DataModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<MenuOutOfStockModel> updateItem(UpdateItemParam params) async {
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
      return MenuOutOfStockModel.fromJson(response);
    } on DioException {
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
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<ModifiersGroupModel>> fetchModifiersGroup(
      Map<String, dynamic> params) async {
    try {
      final List<dynamic> response =
          await _restClient.request(Urls.modifiersGroup, Method.GET, params);
      return response.map((e) => ModifiersGroupModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<ModifierDisabledResponseModel> disableModifier(
      ModifierRequestModel param) async {
    try {
      final response = await _restClient.request(
        Urls.modifiersDisabled(
          param.type == ModifierType.MODIFIER
              ? param.modifierId!
              : param.groupId,
          param.type,
        ),
        Method.PATCH,
        param.toJson(),
      );
      return ModifierDisabledResponseModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> enableModifier(ModifierRequestModel param) async {
    try {
      final response = await _restClient.request(
        Urls.modifiersEnabled(
          param.type == ModifierType.MODIFIER
              ? param.modifierId!
              : param.groupId,
          param.type,
        ),
        Method.PATCH,
        param.toJson(),
      );
      return ActionSuccess.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<MenuBrandModel> fetchMenuBrand(
      {required int brandId, required int branchId}) async {
    try {
      final response = await _restClient.request(
        Urls.menuBrand(brandId),
        Method.GET,
        {
          'filterByBranch': branchId,
        },
      );
      return MenuBrandModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }
}
