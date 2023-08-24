class ItemStockModel {
  bool? available;
  ItemSnoozeModel? snooze;

  ItemStockModel({this.available, this.snooze});

  ItemStockModel.fromJson(Map<String, dynamic> json) {
    available = json['available'];
    snooze = json['snooze'] == null
        ? null
        : ItemSnoozeModel.fromJson(json['snooze'] as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['available'] = available;
    if (snooze != null) {
      data['snooze'] = snooze!.toJson();
    }
    return data;
  }
}

class ItemSnoozeModel {
  String? endTime;
  int? duration;

  ItemSnoozeModel({
    this.endTime,
    this.duration,
  });

  ItemSnoozeModel.fromJson(Map<String, dynamic> json) {
    endTime = json['end_time'] as String?;
    duration = json['duration'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['end_time'] = endTime;
    data['duration'] = duration;
    return data;
  }
}
