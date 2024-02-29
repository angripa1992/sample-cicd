import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/common/entities/delivery_time_data.dart';

class DeliveryTimeDataModel {
  int? branchId;
  int? deliveryTimeMinute;

  DeliveryTimeDataModel({this.branchId, this.deliveryTimeMinute});

  DeliveryTimeDataModel.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    deliveryTimeMinute = json['delivery_time_minute'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = branchId;
    data['delivery_time_minute'] = deliveryTimeMinute;
    return data;
  }

  DeliveryTimeData toEntity() => DeliveryTimeData(branchId.orZero(), deliveryTimeMinute.orZero());
}
