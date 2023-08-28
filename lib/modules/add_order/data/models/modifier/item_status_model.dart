class MenuItemStatusModel {
  int? providerId;
  bool? enabled;
  bool? hidden;

  MenuItemStatusModel({this.providerId, this.enabled, this.hidden});

  MenuItemStatusModel.fromJson(Map<String, dynamic> json) {
    providerId = json['provider_id'];
    enabled = json['enabled'];
    hidden = json['hidden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['provider_id'] = providerId;
    data['enabled'] = enabled;
    data['hidden'] = hidden;
    return data;
  }
}
