import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';

class NavigationData{
  final int index;
  final dynamic data;

  NavigationData(this.index, this.data);
}

class BaseScreenCubit extends Cubit<NavigationData>{
  BaseScreenCubit() : super(NavigationData(BottomNavItem.HOME, null));

  void changeIndex(NavigationData data){
    emit(data);
  }
}