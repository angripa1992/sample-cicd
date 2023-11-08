import 'package:klikit/modules/orders/data/models/orders_model.dart';

class AdditionalInfo {
  final VehicleInfo? vehicleInfo;

  AdditionalInfo({required this.vehicleInfo});

  AdditionalInfoModel toModel() => AdditionalInfoModel(vehicleInfo: vehicleInfo?.toModel());
}

class VehicleInfo {
  final String regNo;

  VehicleInfo({required this.regNo});

  VehicleInfoModel toModel() => VehicleInfoModel(regNo: regNo);
}
