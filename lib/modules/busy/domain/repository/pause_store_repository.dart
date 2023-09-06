import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';

import '../entity/pause_store_data.dart';

abstract class PauseStoreRepository{
  Future<Either<Failure,PauseStoresData>> fetchPauseStoresData(int branchID);
}