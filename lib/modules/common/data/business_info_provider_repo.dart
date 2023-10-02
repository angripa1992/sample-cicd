import 'package:dartz/dartz.dart';

import '../../../core/network/error_handler.dart';
import '../entities/branch_info.dart';
import '../entities/payment_info.dart';
import '../entities/provider.dart';
import '../entities/source.dart';
import '../model/brand_request_model.dart';
import '../entities/brand.dart';

abstract class BusinessInfoProviderRepo {
  Future<Either<Failure, Brands>> fetchBrand(BrandRequestModel requestModel);

  Future<Either<Failure, List<Provider>>> fetchProvider(Map<String, dynamic> param);

  Future<Either<Failure, List<Sources>>> fetchSources();

  Future<Either<Failure, List<PaymentMethod>>> fetchPaymentMethods();

  Future<Either<Failure, List<PaymentStatus>>> fetchPaymentSources();

  Future<Either<Failure, BusinessBranchInfo>> fetchBranchDetails(int branchID);
}
