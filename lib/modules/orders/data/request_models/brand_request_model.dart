import 'package:json_annotation/json_annotation.dart';

part 'brand_request_model.g.dart';

@JsonSerializable()
class BrandRequestModel{
  final int filterByBranch;

  BrandRequestModel({required this.filterByBranch});

  Map<String,dynamic> toJson() => _$BrandRequestModelToJson(this);
  
}