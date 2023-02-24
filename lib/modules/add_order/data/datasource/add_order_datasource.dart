import 'package:dio/dio.dart';

import '../../../../app/enums.dart';
import '../../../../core/network/rest_client.dart';
import '../../../../core/network/urls.dart';
import '../../../menu/data/models/menues_model.dart';

abstract class AddOrderDatasource {
  Future<MenusDataModel> fetchMenus(
      {required int branchId, required int brandId});
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
        {
          'brand_ids': brandId,
        },
      );
      return MenusDataModel.fromJson(response);
    } on DioError {
      rethrow;
    }
  }
}
