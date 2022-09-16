import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/orders/domain/entities/order_status.dart';

part 'order_status_model.g.dart';

@JsonSerializable()
class OrderStatusModel {
  int? id;
  String? status;

  OrderStatusModel({this.id, this.status});

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) => _$OrderStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusModelToJson(this);

  OrderStatus toEntity(){
    return OrderStatus(id.orZero(), status.orEmpty());
  }
}
