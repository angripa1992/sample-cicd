import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constants.dart';

class TabSelectionCubit extends Cubit<int> {
  TabSelectionCubit() : super(MenuTabIndex.MENU);

  void changeTab(int index) {
    emit(index);
  }
}
