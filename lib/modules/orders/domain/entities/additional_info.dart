import 'package:klikit/modules/orders/data/models/orders_model.dart';

class AdditionalInfo {
  final VehicleInfo? vehicleInfo;

  AdditionalInfo({required this.vehicleInfo});

  AdditionalInfoModel toModel() => AdditionalInfoModel(vehicleInfo: vehicleInfo?.toModel());
}

class VehicleInfo {
  final String regNo;
  final String additionalDetails;

  VehicleInfo({required this.regNo, required this.additionalDetails});

  VehicleInfoModel toModel() => VehicleInfoModel(regNo: regNo, additionalDetails: additionalDetails);
}
