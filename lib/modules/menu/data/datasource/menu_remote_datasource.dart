import 'package:dio/dio.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/core/network/rest_client.dart';
import 'package:klikit/modules/menu/data/models/modifier/affected_modifier_response_model.dart';
import 'package:klikit/modules/menu/data/models/modifier_request_model.dart';
import 'package:klikit/modules/menu/domain/usecase/update_item_snooze.dart';
import 'package:klikit/modules/menu/domain/usecase/update_menu_enabled.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../../../app/enums.dart';
import '../../../../core/network/urls.dart';
import '../../../../core/provider/date_time_provider.dart';
import '../../domain/entities/menu/menu_data.dart';
import '../../domain/usecase/fetch_menus.dart';
import '../../domain/usecase/ftech_modifier_groups.dart';
import '../mapper/mmv1_to_menu.dart';
import '../mapper/mmv2_to_menu.dart';
import '../models/menu/menu_oos_response_model.dart';
import '../models/menu/menu_v1_data.dart';
import '../models/menu/menu_v2_data.dart';
import '../models/modifier/modifier_v1_data.dart';
import '../models/modifier/modifier_v2_data.dart';

abstract class MenuRemoteDatasource {
  Future<MenuData> fetchMenus(FetchMenuParams params);

  Future<MenuOosResponseModel> updateItemSnooze(UpdateItemSnoozeParam params);

  Future<ActionSuccess> updateMenuEnabled(UpdateMenuParams params);

  Future<List<V1ModifierGroupModel>> fetchV1ModifiersGroup(FetchModifierGroupParams params);

  Future<List<V2ModifierGroupModel>> fetchV2ModifiersGroup(FetchModifierGroupParams params);

  Future<AffectedModifierResponseModel> verifyDisableAffect(ModifierRequestModel param);

  Future<ActionSuccess> updateModifierEnabled(ModifierRequestModel param);
}

class MenuRemoteDatasourceImpl extends MenuRemoteDatasource {
  final RestClient _restClient;

  MenuRemoteDatasourceImpl(this._restClient);

  @override
  Future<MenuData> fetchMenus(FetchMenuParams params) async {
    try {
      if (params.menuV2Enabled) {
        final tz = await DateTimeFormatter.timeZone();
        final fetchParams = <String, dynamic>{
          'businessID': params.businessId,
          'brandID': params.brandId,
          'branchID': params.branchId,
          'tz': tz,
        };
        if (params.providers.isNotEmpty) {
          fetchParams['providerID'] = ListParam(params.providers, ListFormat.csv);
        }
        final response = await _restClient.request(Urls.menuV2, Method.GET, fetchParams);
        return mapMMV2toMenu(response is List<dynamic> ? MenuV2DataModel(branchInfo: null, sections: null) : MenuV2DataModel.fromJson(response));
      } else {
        final fetchParams = <String, dynamic>{
          'brand_id': params.brandId,
        };
        if (params.providers.isNotEmpty) {
          fetchParams['provider_id'] = ListParam(params.providers, ListFormat.csv);
        }
        final response = await _restClient.request(
          Urls.menuV1(params.branchId),
          Method.GET,
          fetchParams,
        );
        final value = mapMMV1toMenu(MenuV1MenusDataModel.fromJson(response));
        return value;
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<MenuOosResponseModel> updateItemSnooze(UpdateItemSnoozeParam params) async {
    try {
      if (params.menuVersion == MenuVersion.v2) {
        final response = await _restClient.request(Urls.updateV2temSnooze(params.itemId), Method.PATCH, {
          'businessID': params.businessID,
          'branchID': params.branchId,
          'brandID': params.brandId,
          'duration': params.duration,
          'isEnabled': params.enabled,
          'timezoneOffset': params.timeZoneOffset,
        });
        return MenuOosV2ResponseModel.fromJson(response).oos!;
      } else {
        return await _updateV1ItemSnooze(params);
      }
    } on DioException {
      rethrow;
    }
  }

  Future<MenuOosResponseModel> _updateV1ItemSnooze(UpdateItemSnoozeParam params) async {
    try {
      final response = await _restClient.request(Urls.updateV1ItemSnooze(params.itemId), Method.PATCH, {
        'branch_id': params.branchId,
        'brand_id': params.brandId,
        'duration': params.duration,
        'is_enabled': params.enabled,
        'timezoneOffset': params.timeZoneOffset,
      });
      return MenuOosResponseModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> updateMenuEnabled(UpdateMenuParams params) async {
    try {
      if (params.menuVersion == MenuVersion.v2) {
        late String path;
        if (params.type == MenuType.ITEM) {
          path = 'items';
        } else if (params.type == MenuType.CATEGORY) {
          path = 'categories';
        } else {
          path = 'sections';
        }
        final response = await _restClient.request(Urls.updateV2Menu(path), Method.PATCH, {
          'businessID': params.businessId,
          'brandID': params.brandId,
          'branchID': params.branchId,
          'ids': [params.id],
          'isEnabled': params.enabled,
        });
        return ActionSuccess.fromJson(response);
      } else {
        if (params.type == MenuType.ITEM) {
          final response = await _updateV1ItemSnooze(
            UpdateItemSnoozeParam(
              menuVersion: params.menuVersion,
              itemId: params.id,
              businessID: params.businessId,
              branchId: params.branchId,
              brandId: params.brandId,
              duration: 0,
              enabled: params.enabled,
              timeZoneOffset: DateTimeFormatter.timeZoneOffset(),
            ),
          );
          if (response.available ?? false) {
            return ActionSuccess('Item stock enabled successful');
          } else {
            return ActionSuccess('Item stock disabled successful');
          }
        }
        final response = await _restClient.request(Urls.updateMenu(params.id, params.type), Method.PATCH, {
          'branch_id': params.branchId,
          'brand_id': params.brandId,
          'is_enabled': params.enabled,
        });
        return ActionSuccess.fromJson(response);
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<V1ModifierGroupModel>> fetchV1ModifiersGroup(FetchModifierGroupParams params) async {
    try {
      Map<String, dynamic> fetchParams = {'brand_id': params.brandID, 'branch_id': params.branchID};
      if (params.providers.isNotEmpty) {
        fetchParams['provider_id'] = ListParam(params.providers, ListFormat.csv);
      }
      final List<dynamic> response = await _restClient.request(Urls.v1ModifiersGroup, Method.GET, fetchParams);
      return response.map((e) => V1ModifierGroupModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<V2ModifierGroupModel>> fetchV2ModifiersGroup(FetchModifierGroupParams params) async {
    try {
      final fetchParams = {
        'brandID': params.brandID,
        'branchID': params.branchID,
        'businessID': params.businessID,
      };
      final List<dynamic> response = await _restClient.request(
        Urls.v2ModifiersGroup,
        Method.GET,
        fetchParams,
      );
      return response.map((e) => V2ModifierGroupModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<AffectedModifierResponseModel> verifyDisableAffect(ModifierRequestModel param) async {
    try {
      if (param.menuVersion == MenuVersion.v1) {
        final response = await _restClient.request(
          Urls.checkAffect(
            param.type == ModifierType.MODIFIER ? param.modifierId! : param.groupId,
            param.type,
          ),
          Method.PATCH,
          param.toV1Json(),
        );
        return AffectedModifierResponseModel.fromJson(response);
      } else {
        final response = await _restClient.request(
          Urls.checkAffectV2,
          Method.GET,
          param.toV2VerifyDisableRequestJson(),
        );
        return AffectedModifierResponseModel.fromJson(response);
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> updateModifierEnabled(ModifierRequestModel param) async {
    try {
      if (param.menuVersion == MenuVersion.v1) {
        final response = await _restClient.request(
          Urls.updateModifierEnabled(param.type == ModifierType.MODIFIER ? param.modifierId! : param.groupId, param.type),
          Method.PATCH,
          param.toV1Json(),
        );
        return ActionSuccess.fromJson(response);
      } else {
        final response = await _restClient.request(Urls.updateModifierEnabledV2(param.type), Method.PATCH, param.toV2Json());
        return ActionSuccess.fromJson(response);
      }
    } on DioException {
      rethrow;
    }
  }
}
