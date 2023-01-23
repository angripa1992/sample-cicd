class ModifierRequestModel {
  final int type;
  final bool isEnabled;
  final int brandId;
  final int branchId;
  final int groupId;
  int? modifierId;
  List<int>? providerIds;

  ModifierRequestModel({
    required this.type,
    required this.isEnabled,
    required this.brandId,
    required this.branchId,
    required this.groupId,
    this.modifierId,
    this.providerIds,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_enabled'] = isEnabled;
    data['brand_id'] = brandId;
    data['branch_id'] = branchId;
    data['group_id'] = groupId;
    if (modifierId != null) {
      data['modifier_id'] = modifierId;
    }
    data['provider_ids'] = providerIds;
    return data;
  }
}
