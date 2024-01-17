import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/language/selected_locale.dart';

abstract class ChangeLanguageState {}

class InitState extends ChangeLanguageState {}

class OnChangeState extends ChangeLanguageState {
  final SelectedLocale selectedLocale;

  OnChangeState(this.selectedLocale);
}

class ChangeLanguageCubit extends Cubit<ChangeLanguageState> {
  ChangeLanguageCubit() : super(InitState());

  void openLanguageSettingDialog(SelectedLocale selectedLocale) {
    emit(OnChangeState(selectedLocale));
  }
}
