import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/modules/orders/presentation/bloc/busy/busy_mode_state.dart';

import '../../../domain/usecases/check_busy_mode.dart';

class BusyModeCubit extends Cubit<BusyModeState> {
  final CheckBusyMode _checkBusyMode;
  final AppPreferences _appPreferences;
  Timer? _timer;

  BusyModeCubit(this._checkBusyMode, this._appPreferences) : super(Available()) {
    checkCurrentStatus();
  }

  void checkCurrentStatus() async {
    final params = {"branch_id": _appPreferences.getUser().userInfo.branchId};
    final response = await _checkBusyMode(params);
    response.fold(
      (failure) {},
      (data) {
        if (data.isBusy) {
          changeToOffline();
        } else {
          changeToAvailable();
        }
      },
    );
  }

  void changeToOffline() {
    emit(Offline(0));
    _startTimer();
  }

  void changeToAvailable() {
    _cancelTimer();
    emit(Available());
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) {
        emit(Offline(timer.tick));
        if(timer.tick == AppConstant.busyTimeInMin){
          _cancelTimer();
        }
      },
    );
  }

  void _cancelTimer() {
    _timer?.cancel();
  }
}
