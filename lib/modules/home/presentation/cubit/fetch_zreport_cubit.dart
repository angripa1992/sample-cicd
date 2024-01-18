import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../app/session_manager.dart';
import '../../data/model/z_report_data_model.dart';
import '../../domain/repository/home_repository.dart';

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
