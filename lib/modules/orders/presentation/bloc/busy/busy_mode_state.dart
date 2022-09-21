import 'package:equatable/equatable.dart';

abstract class BusyModeState extends Equatable{
  @override
  List<Object?> get props => [];
}

class Available extends BusyModeState{
  @override
  List<Object?> get props => [];
}

class Offline extends BusyModeState{
  final int minute;

  Offline(this.minute);

  @override
  List<Object?> get props => [minute];
}