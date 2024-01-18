import 'package:dartz/dartz.dart';
import 'package:klikit/modules/home/domain/entities/summary_data.dart';

import '../../../../core/network/error_handler.dart';
import '../../data/model/z_report_data_model.dart';

abstract class HomeRepository{
  Future<Either<Failure, ZReportData>> fetchZReportData(Map<String,dynamic> params);

  Future<Either<Failure, OrderSummaryData>> fetchSummary(Map<String,dynamic> params);
}