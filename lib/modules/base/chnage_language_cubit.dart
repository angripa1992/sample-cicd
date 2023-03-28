import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChangeLanguageState {}

class InitState extends ChangeLanguageState {}

class OnChangeState extends ChangeLanguageState {
  final Locale locale;
  final int id;
  OnChangeState(this.locale, this.id);
}

class ChangeLanguageCubit extends Cubit<ChangeLanguageState> {
  ChangeLanguageCubit() : super(InitState());

  void openLanguageSettingDialog(Locale locale,int id) {
    emit(OnChangeState(locale,id));
  }
}
