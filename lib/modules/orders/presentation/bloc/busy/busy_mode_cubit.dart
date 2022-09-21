import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/core/provider/order_information_provider.dart';
import 'package:klikit/modules/orders/presentation/bloc/busy/busy_mode_state.dart';

class BusyModeCubit extends Cubit<BusyModeState> {
  Timer? _timer;
  final infoProvider = getIt.get<OrderInformationProvider>();
  BusyModeCubit() : super(Available());

  void test() async{
    final status = await infoProvider.getStatusIds();
    print("======status ids $status");
    final brands = await infoProvider.getBrandsIds();
    print("======brands ids $brands");
    final providers = await infoProvider.getProvidersIds();
    print("======providers ids $providers");
  }

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