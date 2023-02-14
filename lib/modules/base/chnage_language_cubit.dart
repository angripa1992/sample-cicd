import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChangeLanguageState{}

class InitState extends ChangeLanguageState{}

class OnChangeState extends ChangeLanguageState{}

class ChangeLanguageCubit extends Cubit<ChangeLanguageState>{
  ChangeLanguageCubit() : super(InitState());

  void openLanguageSettingDialog(){
    emit(OnChangeState());
  }
}