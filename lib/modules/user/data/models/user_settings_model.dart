import 'package:klikit/app/extensions.dart';

import '../../domain/entities/user_settings.dart';

class UserSettingsModel {
  int? userId;
  bool? orderNotificationEnabled;

  UserSettingsModel({this.userId, this.orderNotificationEnabled});

  UserSettingsModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    orderNotificationEnabled = json['order_notification_enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['order_notification_enabled'] = orderNotificationEnabled;
    return data;
  }

  UserSettings toEntity() => UserSettings(
        userId: userId.orZero(),
        orderNotificationEnabled: orderNotificationEnabled ?? true,
      );
}
