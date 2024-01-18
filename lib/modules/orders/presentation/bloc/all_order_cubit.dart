import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../core/widgets/filter/filter_data.dart';
import '../../../common/oni_parameter_provider.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/fetch_new_order.dart';

class AllOrderCubit extends Cubit<ResponseState> {
  final FetchNewOrder _fetchNewOrder;

  AllOrderCubit(this._fetchNewOrder) : super(Empty());

  void fetchAllOrder({required OniFilteredData? filteredData}) async {
    final params = await OniParameterProvider().allOrder(filteredData: filteredData);
    final response = await _fetchNewOrder(params);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (orders) {
        emit(Success<Orders>(orders));
      },
    );
  }
}
