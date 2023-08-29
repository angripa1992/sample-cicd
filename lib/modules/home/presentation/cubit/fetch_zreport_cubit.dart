import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/utils/response_state.dart';

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
    final response = await _repository.fetchZReportData(
      {
        'period_start': '$date $startTime',
        'period_end': '$date $endTime',
        'branch_id': SessionManager().branchId(),
        // 'period_start': '2023-08-11 10:10:00',
        // 'period_end': '2023-08-18 11:10:00',
      },
    );
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        emit(Success<ZReportDataModel>(data));
      },
    );
  }
}
