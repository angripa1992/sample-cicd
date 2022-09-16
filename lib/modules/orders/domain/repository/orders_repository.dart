import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/orders/domain/entities/brand.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/entities/order_status.dart';
import 'package:klikit/modules/orders/domain/entities/provider.dart';
import 'package:klikit/modules/orders/domain/entities/settings.dart';

import '../../data/request_models/brand_request_model.dart';
import '../../data/request_models/order_request_model.dart';
import '../../data/request_models/provider_request_model.dart';

abstract class OrderRepository{
  Future<Either<OrderStatus,Failure>> fetchOrderStatus();
  Future<Either<Brands,Failure>> fetchBrand(BrandRequestModel requestModel);
  Future<Either<Provider,Failure>> fetchProvider(ProviderRequestModel requestModel);
  Future<Either<Settings,Failure>> fetchSettings(int id);
  Future<Either<Orders,Failure>> fetchOrder(OrderRequestModel requestModel);
}