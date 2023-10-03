import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/common/entities/brand.dart';

import '../../../common/business_information_provider.dart';

class MenuBrandsCubit extends Cubit<ResponseState> {
  final BusinessInformationProvider _informationProvider;

  MenuBrandsCubit(this._informationProvider) : super(Empty());

  void fetchMenuBrands() async {
    emit(Loading());
    final brands = await _informationProvider.fetchBrands();
    emit(Success<List<Brand>>(brands));
  }
}
