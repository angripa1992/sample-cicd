import 'package:klikit/app/constants.dart';

class ModifierRequestModel {
  final int menuVersion;
  final int type;
  final bool isEnabled;
  final int brandId;
  final int branchId;
  final int businessId;
  final int groupId;
  final int? modifierId;
  final List<int> providerIds;

  ModifierRequestModel({
    required this.menuVersion,
    required this.type,
    required this.isEnabled,
    required this.brandId,
    required this.branchId,
    required this.businessId,
    required this.groupId,
    this.modifierId,
    required this.providerIds,
  });

  Map<String, dynamic> toV1Json() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_enabled'] = isEnabled;
    data['brand_id'] = brandId;
    data['branch_id'] = branchId;
    data['group_id'] = groupId;
    if (modifierId != null) {
      data['modifier_id'] = modifierId;
    }
    if (providerIds.isNotEmpty) {
      data['provider_ids'] = providerIds;
    }
    return data;
  }

  Map<String, dynamic> toV2Json() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isEnabled'] = isEnabled;
    data['businessID'] = businessId;
    data['brandID'] = brandId;
    data['branchID'] = branchId;
    if (type == ModifierType.GROUP) {
      data['ids'] = [groupId];
    } else {
      data['modifierGroupID'] = groupId;
      data['modifiers'] = [modifierId];
    }
    return data;
  }

  Map<String, dynamic> toV2VerifyDisableRequestJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['businessID'] = businessId;
    data['brandID'] = brandId;
    data['branchID'] = branchId;
    data['groupID'] = groupId;
    if (type == ModifierType.MODIFIER) {
      data['modifierID'] = modifierId;
    }
    return data;
  }
}
