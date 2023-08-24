import 'package:dartz/dartz.dart';

import '../../../../core/network/error_handler.dart';
import '../../data/request_models/brand_request_model.dart';
import '../entities/brand.dart';
import '../entities/payment_info.dart';
import '../entities/provider.dart';
import '../entities/source.dart';

abstract class OrderInfoProviderRepo {
  Future<Either<Failure, Brands>> fetchBrand(BrandRequestModel requestModel);

  Future<Either<Failure, List<Provider>>> fetchProvider(
      Map<String, dynamic> param);

  Future<Either<Failure, List<Sources>>> fetchSources();

  Future<Either<Failure, List<PaymentMethod>>> fetchPaymentMethods();

  Future<Either<Failure, List<PaymentStatus>>> fetchPaymentSources();
}
