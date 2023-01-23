import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCountData {
  final int numOfNewOrders;
  final int numOfCancelOrders;

  NotificationCountData(
      {required this.numOfNewOrders, required this.numOfCancelOrders});
}

class NotificationCountCubit extends Cubit<NotificationCountData> {
  NotificationCountCubit(NotificationCountData data) : super(data);

  void update(NotificationCountData data) {
    emit(data);
  }
}

class NewNotificationCountCubit extends Cubit<int> {
  NewNotificationCountCubit() : super(0);

  void increment() {
    emit(state + 1);
  }
}

class CancelNotificationCountCubit extends Cubit<int> {
  CancelNotificationCountCubit() : super(0);

  void increment() {
    emit(state + 1);
  }
}
