import 'package:flutter_bloc/flutter_bloc.dart';

class BaseScreenCubit extends Cubit<int>{
  BaseScreenCubit() : super(0);

  void changeIndex(int index){
    emit(index);
  }
}