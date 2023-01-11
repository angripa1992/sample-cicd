import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/domain/entities/menues.dart';

import '../../../../app/app_preferences.dart';
import '../../domain/usecase/fetch_menus.dart';

class MenusCubit extends Cubit<ResponseState> {
  final FetchMenus _fetchMenus;
  final AppPreferences _appPreferences;

  MenusCubit(this._fetchMenus, this._appPreferences) : super(Empty());

  void fetchMenu(int brandId,int? providerId) async {
    emit(Loading());
    final response = await _fetchMenus(
      FetchMenuParams(
        branchId: _appPreferences.getUser().userInfo.branchId,
        brandId: brandId,
        providerID: providerId != null ? (providerId == ZERO ? 'undefine' : providerId.toString()) : 'undefine',
      ),
    );
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        emit(Success<MenusData>(_filterHiddenMenu(providerId, data)));
      },
    );
  }

  MenusData _filterHiddenMenu(int? providerId,MenusData data){
    MenusData tempData = data;
    if(providerId == null) {
      return tempData;
    } else if(providerId == ZERO){
      tempData.sections.removeWhere((section){
        return section.statuses.any((status) => status.hidden);
      });
    }else{
      tempData.sections.removeWhere((section){
        return section.statuses.any((status) => status.providerId == providerId && status.hidden);
      });
    }
    return tempData;
  }
}
