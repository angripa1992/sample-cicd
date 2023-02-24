import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../app/app_preferences.dart';
import '../../../menu/domain/entities/sections.dart';
import '../../domain/entities/sub_section_list_item.dart';
import '../../domain/repository/add_order_repository.dart';

class FetchSubSectionCubit extends Cubit<ResponseState> {
  final AppPreferences _appPreferences;
  final AddOrderRepository _repository;

  FetchSubSectionCubit(this._repository, this._appPreferences) : super(Empty());

  void fetchSubsection(int brandId) async {
    emit(Loading());
    final response = await _repository.fetchMenus(
      branchId: _appPreferences.getUser().userInfo.branchId,
      brandId: brandId,
    );
    response.fold(
      (failure) => emit(Failed(failure)),
      (successResponse) {
        final subSectionListItems = _createSubSectionList(successResponse.sections);
        emit(Success<List<SubSectionListItem>>(subSectionListItems));
      },
    );
  }

  List<SubSectionListItem> _createSubSectionList(List<Sections> sections) {
    final List<SubSectionListItem> subSectionsListItemDataHolder = [];
    for(var section in sections){
      for(var subSection in section.subSections){
        final subSectionListItem = SubSectionListItem(section.availableTimes, subSection);
        subSectionsListItemDataHolder.add(subSectionListItem);
      }
    }
    return subSectionsListItemDataHolder;
  }
}
