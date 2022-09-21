import 'package:json_annotation/json_annotation.dart';

part 'order_request_model.g.dart';

@JsonSerializable()
class OrderRequestModel {
  final int? page;
  final int? size;
  final String? start;
  final String? end;
  final String? timeZone;
  final int filterByBranch;
  final List<int> filterByStatus;
  final List<int> filterByProvider;
  final List<int> filterByBrand;

  OrderRequestModel({
    this.page,
    this.size,
    this.start,
    this.end,
    this.timeZone,
    required this.filterByBranch,
    required this.filterByStatus,
    required this.filterByProvider,
    required this.filterByBrand,
  });

  Map<String, dynamic> toJson() => _$OrderRequestModelToJson(this);
}
