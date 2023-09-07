import 'package:dio/dio.dart';
import 'package:klikit/app/enums.dart';

import '../../../../core/network/rest_client.dart';
import '../../../../core/network/urls.dart';
import '../model/pause_store_data_model.dart';
import '../model/pause_store_update_response_model.dart';

abstract class PauseStoreRemoteDataSource {
  Future<PauseStoreDataModel> fetchPausedStore(int branchID);

  Future<PauseStoreUpdateResponseModel> updatePauseStore(Map<String, dynamic> params);
}

class PauseStoreRemoteDataSourceImpl extends PauseStoreRemoteDataSource {
  final RestClient _restClient;

  PauseStoreRemoteDataSourceImpl(this._restClient);

  @override
  Future<PauseStoreDataModel> fetchPausedStore(int branchID) async {
    try {
      final response = await _restClient.request(Urls.pauseStore, Method.GET, {'branch_id': branchID});
      return PauseStoreDataModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<PauseStoreUpdateResponseModel> updatePauseStore(Map<String, dynamic> params) async {
    try {
      final response = await _restClient.request(Urls.pauseStore, Method.POST, params);
      return PauseStoreUpdateResponseModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }
}
