import 'package:json_annotation/json_annotation.dart';

part 'brand_request_model.g.dart';

@JsonSerializable()
class BrandRequestModel{
  final int filterByBranch;
  final int page;
  final int size;

  BrandRequestModel({required this.filterByBranch,this.page = 1, this.size = 1000,});

  Map<String,dynamic> toJson() => _$BrandRequestModelToJson(this);
  
}