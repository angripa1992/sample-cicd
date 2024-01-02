import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/common/business_information_provider.dart';

import '../../../../app/session_manager.dart';
import '../../data/model/z_report_data_model.dart';
import '../../domain/home_repository.dart';

class FetchZReportCubit extends Cubit<ResponseState> {
  final HomeRepository _repository;

  FetchZReportCubit(this._repository) : super(Empty());

  void fetchZReportData(DateTime dateTime) async {
    emit(Loading());
    final date = DateFormat('yyyy-MM-dd').format(dateTime).toString();
    const startTime = '00:00:00';
    const endTime = '23:59:59';
    final brands = await getIt.get<BusinessInformationProvider>().fetchBrandsIds();
    final response = await _repository.fetchZReportData(
      {
        'period_start': '$date $startTime',
        'period_end': '$date $endTime',
        'branch_id': SessionManager().branchId(),
        'brand_id': ListParam(brands, ListFormat.csv),
        'order_source': 'm,w',
        'no_cache': true,
        // 'period_start': '2023-01-19 00:00:00',
        //  'period_end': '2023-12-19 23:59:59',
        // 'branch_id': ListParam([604, 2, 601, 577, 597, 80, 81, 763, 1, 591, 592, 595, 593, 125, 567, 78, 49], ListFormat.csv),
        // 'brand_id': ListParam([965, 57, 1, 1012, 1013, 28, 25, 74, 27, 88, 79, 56, 91, 109, 92, 1163, 964, 58, 86, 26, 108, 59], ListFormat.csv),
      },
    );
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        emit(Success<ZReportData>(data));
      },
    );
  }
}
