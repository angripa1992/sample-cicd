import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/domain/entities/stock.dart';

import '../../../../app/app_preferences.dart';
import '../../../../core/provider/date_time_provider.dart';
import '../../domain/usecase/update_item.dart';

class UpdateItemCubit extends Cubit<ResponseState> {
  final UpdateItem _updateItem;
  final AppPreferences _preferences;

  UpdateItemCubit(this._updateItem, this._preferences) : super(Empty());

  void updateItem({
    required int brandId,
    required int itemId,
    required bool enabled,
  }) async {
    emit(Loading());
    final response = await _updateItem(UpdateItemParam(
      itemId: itemId,
      branchId: _preferences.getUser().userInfo.branchId,
      brandId: brandId,
      duration: 0,
      enabled: enabled,
      timeZoneOffset: DateTimeProvider.timeZoneOffset(),
    ));
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        emit(Success<Stock>(data));
      },
    );
  }
}
