import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChangeLanguageState{}

class InitState extends ChangeLanguageState{}

class OnChangeState extends ChangeLanguageState{
  final Locale locale;

  OnChangeState(this.locale);
}

class ChangeLanguageCubit extends Cubit<ChangeLanguageState>{
  ChangeLanguageCubit() : super(InitState());

  void openLanguageSettingDialog(Locale locale){
    emit(OnChangeState(locale));
  }
}