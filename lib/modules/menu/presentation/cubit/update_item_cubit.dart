import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../app/session_manager.dart';
import '../../../../core/provider/date_time_provider.dart';
import '../../domain/entities/menu/menu_out_of_stock.dart';
import '../../domain/usecase/update_item.dart';

class UpdateItemCubit extends Cubit<ResponseState> {
  final UpdateItem _updateItem;

  UpdateItemCubit(this._updateItem) : super(Empty());

  void updateItem({
    required int brandId,
    required int itemId,
    required bool enabled,
    int duration = 0,
  }) async {
    emit(Loading());
    final response = await _updateItem(UpdateItemParam(
      itemId: itemId,
      branchId: SessionManager().currentUserBranchId(),
      brandId: brandId,
      duration: duration,
      enabled: enabled,
      timeZoneOffset: DateTimeProvider.timeZoneOffset(),
    ));
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        emit(Success<MenuOutOfStock>(data));
      },
    );
  }
}
