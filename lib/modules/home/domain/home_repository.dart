import 'package:dartz/dartz.dart';

import '../../../core/network/error_handler.dart';
import '../data/model/z_report_data_model.dart';

abstract class HomeRepository{
  Future<Either<Failure, ZReportDataModel>> fetchZReportData(Map<String,dynamic> params);
}