import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';

class NavigationData {
  final int index;
  final int? subTabIndex;
  final Map<String, dynamic>? data;

  NavigationData({
    required this.index,
    this.data,
    this.subTabIndex,
  });
}

class BaseScreenCubit extends Cubit<NavigationData> {
  BaseScreenCubit()
      : super(NavigationData(
            index: BottomNavItem.HOME, data: null, subTabIndex: null));

  void changeIndex(NavigationData data) {
    emit(data);
  }
}
