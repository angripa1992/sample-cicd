import 'package:json_annotation/json_annotation.dart';

part 'provider_request_model.g.dart';

@JsonSerializable()
class ProviderRequestModel{
  final List<int> filterByCountry;

  ProviderRequestModel({required this.filterByCountry});

  Map<String,dynamic> toJson() => _$ProviderRequestModelToJson(this);
}