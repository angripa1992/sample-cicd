import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/orders/domain/entities/brand.dart';
import 'package:klikit/modules/orders/domain/entities/busy_mode.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/entities/order_status.dart';
import 'package:klikit/modules/orders/domain/entities/provider.dart';
import 'package:klikit/modules/orders/domain/entities/settings.dart';

import '../../data/request_models/brand_request_model.dart';

abstract class OrderRepository{
  Future<Either<Failure,List<OrderStatus>>> fetchOrderStatus();
  Future<Either<Failure,Brands>> fetchBrand(BrandRequestModel requestModel);
  Future<Either<Failure,List<Provider>>> fetchProvider(Map<String,dynamic> param);
  Future<Either<Failure,Settings>> fetchSettings(int id);
  Future<Either<Failure,Orders>> fetchOrder(Map<String,dynamic> params);
  Future<Either<Failure,BusyModeGetResponse>> isBusy(Map<String,dynamic> params);
  Future<Either<Failure,BusyModePostResponse>> updateBusyMode(Map<String,dynamic> params);
}