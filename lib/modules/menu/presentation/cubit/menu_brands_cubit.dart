import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/domain/entities/brand.dart';
import 'package:klikit/modules/menu/domain/entities/brands.dart';

import '../../../../app/session_manager.dart';
import '../../domain/usecase/fetch_menu_brands.dart';

class MenuBrandsCubit extends Cubit<ResponseState> {
  final FetchMenuBrands _fetchMenuBrands;

  MenuBrandsCubit(this._fetchMenuBrands) : super(Empty());

  void fetchMenuBrands() async {
    emit(Loading());
    final branchID = SessionManager().currentUserBranchId();
    List<MenuBrand> brands = [];
    int pageKey = 1;
    int pageSize = 10;
    bool isFailed = false;
    while (true) {
      final response = await _fetchMenuBrands(
        {
          'filterByBranch': branchID,
          'page': pageKey,
        },
      );
      if (response.isRight()) {
        final data = response.getOrElse(
            () => MenuBrands(results: [], total: 0, page: 0, size: 0));
        final isLastPage = data.total <= (pageKey * pageSize);
        brands.addAll(data.results);
        if (isLastPage) {
          break;
        } else {
          pageKey += 1;
        }
      } else {
        response.fold(
          (failure) {
            emit(Failed(failure));
          },
          (data) {},
        );
        isFailed = true;
        break;
      }
    }
    if (!isFailed) {
      emit(Success<List<MenuBrand>>(brands));
    }
  }
}
