import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/orders/presentation/bloc/state/busy_mode_state.dart';

class BusyModeCubit extends Cubit<BusyModeState> {
  Timer? _timer;
  BusyModeCubit() : super(Available());

  void changeToOffline() {
    emit(Offline(0));
    _startTimer();
  }

  void changeOfflineToAvailable() {
    _cancelTimer();
    emit(Available());
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(Offline(timer.tick));
      if(timer.tick == 60){
        changeOfflineToAvailable();
      }
    });
  }

  void _cancelTimer(){
    _timer?.cancel();
  }
}