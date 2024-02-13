import 'package:dartz/dartz.dart';

import '../../../core/network/error_handler.dart';
import '../entities/branch.dart';
import '../entities/brand.dart';
import '../entities/payment_info.dart';
import '../entities/provider.dart';
import '../entities/source.dart';

abstract class BusinessInfoProviderRepo {
  Future<Either<Failure, Brands>> fetchBrand(Map<String, dynamic> param);

  Future<Either<Failure, List<Provider>>> fetchProvider(Map<String, dynamic> param);

  Future<Either<Failure, List<Sources>>> fetchSources();

  Future<Either<Failure, List<PaymentMethod>>> fetchPaymentMethods();

  Future<Either<Failure, List<PaymentStatus>>> fetchPaymentSources();

  Future<Either<Failure, List<Branch>>> fetchBranches(Map<String, dynamic> params);

  Future<Either<Failure, List<PaymentChannel>>> fetchAllPaymentChannels();
}
