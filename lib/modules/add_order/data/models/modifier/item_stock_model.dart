class MenuItemOutOfStockModel {
  bool? available;
  MenuItemSnoozeModel? snooze;

  MenuItemOutOfStockModel({this.available, this.snooze});

  MenuItemOutOfStockModel.fromJson(Map<String, dynamic> json) {
    available = json['available'];
    snooze = json['snooze'] == null
        ? null
        : MenuItemSnoozeModel.fromJson(json['snooze'] as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['available'] = available;
    if(snooze != null){
      data['snooze'] = snooze!.toJson();
    }
    return data;
  }
}

class MenuItemSnoozeModel {
  String? endTime;
  int? duration;

  MenuItemSnoozeModel({
    this.endTime,
    this.duration,
  });

  MenuItemSnoozeModel.fromJson(Map<String, dynamic> json) {
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