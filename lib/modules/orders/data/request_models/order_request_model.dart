import 'package:json_annotation/json_annotation.dart';

part 'order_request_model.g.dart';

@JsonSerializable()
class OrderRequestModel {
  final int page;
  final int size;
  final int filterByBranch;
  final List<int> filterByProvider;
  final List<int> filterByBrand;

  OrderRequestModel({
    required this.page,
    this.size = 10,
    required this.filterByBranch,
    required this.filterByProvider,
    required this.filterByBrand,
  });

  Map<String,dynamic> toJson() => _$OrderRequestModelToJson(this);

}
