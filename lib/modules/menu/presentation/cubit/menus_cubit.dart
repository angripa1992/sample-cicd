import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/domain/entities/menues.dart';

import '../../domain/usecase/fetch_menus.dart';

class MenusCubit extends Cubit<ResponseState> {
  final FetchMenus _fetchMenus;

  MenusCubit(this._fetchMenus) : super(Empty());

  void fetchMenu(int brandID) async {
    emit(Loading());
    final response = await _fetchMenus(brandID);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        emit(Success<MenusData>(data));
      },
    );
  }
}
