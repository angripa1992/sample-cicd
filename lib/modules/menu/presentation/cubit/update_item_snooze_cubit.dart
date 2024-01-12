import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../app/constants.dart';
import '../../../../app/di.dart';
import '../../../../app/session_manager.dart';
import '../../../../app/user_permission_manager.dart';
import '../../../../core/provider/date_time_provider.dart';
import '../../../common/business_information_provider.dart';
import '../../domain/entities/menu/menu_out_of_stock.dart';
import '../../domain/usecase/update_item_snooze.dart';

class UpdateItemSnoozeCubit extends Cubit<ResponseState> {
  final UpdateItemSnooze _updateItem;

  UpdateItemSnoozeCubit(this._updateItem) : super(Empty());

  void updateItem({
    required int menuVersion,
    required int brandId,
    required int branchID,
    required int itemId,
    required bool enabled,
    required duration,
  }) async {
    emit(Loading());
    final branch = await getIt.get<BusinessInformationProvider>().branchByID(branchID);
    final version = UserPermissionManager().isBizOwner() ? (branch?.menuVersion ?? MenuVersion.v2) : menuVersion;
    final response = await _updateItem(
      UpdateItemSnoozeParam(
        itemId: itemId,
        businessID: SessionManager().businessID(),
        branchId: branchID,
        brandId: brandId,
        duration: duration,
        enabled: enabled,
        timeZoneOffset: DateTimeFormatter.timeZoneOffset(),
        menuVersion: version,
      ),
    );
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
