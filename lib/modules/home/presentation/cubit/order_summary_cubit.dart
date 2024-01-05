import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/modules/home/domain/repository/home_repository.dart';

class OrderSummaryCubit extends Cubit<ResponseState>{
  final HomeRepository _repository;

  OrderSummaryCubit(this._repository) : super(Empty());

  void fetchOrderSummaryData(HomeFilterAppliedData? filterAppliedDate){

  }
}