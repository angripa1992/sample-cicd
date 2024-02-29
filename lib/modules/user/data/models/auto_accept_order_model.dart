import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/user/domain/entities/auto_accept_order.dart';

class AutoAcceptOrderModel {
  int? branchId;
  bool? autoAcceptOrderEnabled;

  AutoAcceptOrderModel({
    this.branchId,
    this.autoAcceptOrderEnabled,
  });

  AutoAcceptOrderModel.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    autoAcceptOrderEnabled = json['auto_accept'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = branchId;
    data['auto_accept'] = autoAcceptOrderEnabled;
    return data;
  }

  AutoAcceptOrder toEntity() => AutoAcceptOrder(
        branchId: branchId.orZero(),
        autoAccept: autoAcceptOrderEnabled ?? false,
      );
}
