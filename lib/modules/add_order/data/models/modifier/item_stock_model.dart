class AddOrderItemStockModel {
  bool? available;
  AddOrderItemSnoozeModel? snooze;

  AddOrderItemStockModel({this.available, this.snooze});

  AddOrderItemStockModel.fromJson(Map<String, dynamic> json) {
    available = json['available'];
    snooze = json['snooze'] == null
        ? null
        : AddOrderItemSnoozeModel.fromJson(json['snooze'] as Map<String, dynamic>);
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

class AddOrderItemSnoozeModel {
  String? endTime;
  int? duration;

  AddOrderItemSnoozeModel({
    this.endTime,
    this.duration,
  });

  AddOrderItemSnoozeModel.fromJson(Map<String, dynamic> json) {
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