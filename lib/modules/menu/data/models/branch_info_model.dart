import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';

import '../../domain/entities/branch_info.dart';

part 'branch_info_model.g.dart';

@JsonSerializable()
class BranchInfoModel {
  @JsonKey(name: 'country_id')
  int? countryId;
  @JsonKey(name: 'branch_id')
  int? branchId;
  @JsonKey(name: 'currency_id')
  int? currencyId;
  @JsonKey(name: 'start_time')
  int? startTime;
  @JsonKey(name: 'end_time')
  int? endTime;
  @JsonKey(name: 'availability_mask')
  int? availabilityMask;
  @JsonKey(name: 'provider_ids')
  String? providerIds;
  @JsonKey(name: 'language_code')
  String? languageCode;

  BranchInfoModel({
    this.countryId,
    this.branchId,
    this.currencyId,
    this.startTime,
    this.endTime,
    this.availabilityMask,
    this.providerIds,
    this.languageCode,
  });

  factory BranchInfoModel.fromJson(Map<String, dynamic> json) =>
      _$BranchInfoModelFromJson(json);

  BranchInfo toEntity() {
    return BranchInfo(
      countryId: countryId.orZero(),
      branchId: branchId.orZero(),
      currencyId: currencyId.orZero(),
      startTime: startTime.orZero(),
      endTime: endTime.orZero(),
      availabilityMask: availabilityMask.orZero(),
      providerIds: providerIds.orEmpty(),
      languageCode: languageCode.orEmpty(),
    );
  }
}
