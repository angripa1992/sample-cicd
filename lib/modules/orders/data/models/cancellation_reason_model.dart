import 'package:klikit/app/extensions.dart';

import '../../domain/entities/cancellation_reason.dart';

class CancellationReasonModel {
  int? id;
  String? title;
  int? cancelOrderTypeId;
  String? createdAt;

  CancellationReasonModel({
    this.id,
    this.title,
    this.cancelOrderTypeId,
    this.createdAt,
  });

  CancellationReasonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    cancelOrderTypeId = json['cancel_order_type_id'];
    createdAt = json['created_at'];
  }

  CancellationReason toEntity() => CancellationReason(
        id: id.orZero(),
        title: title.orEmpty(),
        cancelOrderTypeId: cancelOrderTypeId.orZero(),
        createdAt: createdAt.orEmpty(),
      );
}
