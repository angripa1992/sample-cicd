
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/domain/entities/items.dart';

import '../../../menu/domain/entities/brand.dart';
import '../../../menu/domain/entities/sections.dart';
import '../../domain/entities/sub_section_list_item.dart';
import '../../domain/repository/add_order_repository.dart';

class FetchSubSectionCubit extends Cubit<ResponseState> {
  final AddOrderRepository _repository;

  FetchSubSectionCubit(this._repository) : super(Empty());

  void fetchSubsection(MenuBrand brand) async {
    emit(Loading());
    final response = await _repository.fetchMenus(
      branchId: SessionManager().currentUserBranchId(),
      brandId: brand.id,
    );
    response.fold(
      (failure) => emit(Failed(failure)),
      (successResponse) {
        final subSectionListItems =
            _createSubSectionList(successResponse.sections);
        emit(Success<List<SubSectionListItem>>(subSectionListItems));
      },
    );
  }

  List<SubSectionListItem> _createSubSectionList(List<Sections> sections) {
    final List<SubSectionListItem> subSectionsListItemDataHolder = [];
    for (var section in sections) {
      if (section.enabled && !section.hidden) {
        for (var subSection in section.subSections) {
          if (subSection.enabled &&
              !subSection.hidden &&
              subSection.items.isNotEmpty) {
            final items = <MenuItems>[];
            for (var item in subSection.items) {
              if (!item.hidden) {
                item.availableTimes = section.availableTimes;
                items.add(item);
              }
            }
            subSection.items = items;
            final subSectionListItem =
                SubSectionListItem(section.availableTimes, subSection);
            subSectionsListItemDataHolder.add(subSectionListItem);
          }
        }
      }
    }
    return subSectionsListItemDataHolder;
  }
}