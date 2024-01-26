import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:klikit/app/date_time_patterns.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../app/session_manager.dart';
import '../../data/model/z_report_data_model.dart';
import '../../domain/repository/home_repository.dart';

class FetchZReportCubit extends Cubit<ResponseState> {
  final HomeRepository _repository;

  FetchZReportCubit(this._repository) : super(Empty());

  void fetchZReportData({required DateTime startDateTime, DateTime? endDateTime}) async {
    emit(Loading());
    final startDate = DateFormat('yyyy-MM-dd').format(startDateTime).toString();
    String endDate = startDate;
    String startTime = '00:00:00';
    String endTime = '23:59:59';

    if (endDateTime != null) {
      endDate = DateFormat('yyyy-MM-dd').format(endDateTime).toString();
      startTime = startDateTime.format(DTPatterns.HHmmss);
      endTime = endDateTime.format(DTPatterns.HHmmss);
    }

    debugPrint('Params: ${{
      'period_start': '$startDate $startTime',
      'period_end': '$endDate $endTime',
      'branch_id': SessionManager().branchId(),
    }}');

    final response = await _repository.fetchZReportData(
      {
        'period_start': '$startDate $startTime',
        'period_end': '$endDate $endTime',
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
