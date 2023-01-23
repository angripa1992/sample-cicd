import 'package:flutter_bloc/flutter_bloc.dart';

class AggregatorSelectionCubit extends Cubit<int?> {
  AggregatorSelectionCubit() : super(null);

  void changeAggregator(int? aggregator) {
    emit(aggregator);
  }
}
