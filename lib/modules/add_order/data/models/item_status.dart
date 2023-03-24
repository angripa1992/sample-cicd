class ItemStatusModel {
  int? providerId;
  bool? enabled;
  bool? hidden;

  ItemStatusModel({this.providerId, this.enabled, this.hidden});

  ItemStatusModel.fromJson(Map<String, dynamic> json) {
    providerId = json['provider_id'];
    enabled = json['enabled'];
    hidden = json['hidden'];
  }

}