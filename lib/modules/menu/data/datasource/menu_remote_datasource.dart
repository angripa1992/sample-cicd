import 'package:dio/dio.dart';
import 'package:klikit/core/network/rest_client.dart';
import 'package:klikit/modules/menu/data/models/menues_model.dart';

import '../../../../app/enums.dart';
import '../../../../core/network/urls.dart';
import '../models/brands_model.dart';

abstract class MenuRemoteDatasource {
  Future<MenuBrandsModel> fetchMenuBrands(Map<String, dynamic> params);

  Future<MenusDataModel> fetchMenus(int brandID);
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
  Future<MenusDataModel> fetchMenus(int brandID) async {
    try {
      final response =
          await _restClient.request(Urls.menus(brandID), Method.GET, null);
      return MenusDataModel.fromJson(response);
    } on DioError {
      rethrow;
    }
  }
}
