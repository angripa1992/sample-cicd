import 'package:klikit/app/extensions.dart';

import '../../domain/entities/user_settings.dart';

class UserSettingsModel {
  int? userId;
  bool? orderNotificationEnabled;
  bool? sunmiDevice;

  UserSettingsModel({
    this.userId,
    this.orderNotificationEnabled,
    this.sunmiDevice,
  });

  UserSettingsModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    orderNotificationEnabled = json['order_notification_enabled'];
    sunmiDevice = json['sunmi_device'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['order_notification_enabled'] = orderNotificationEnabled;
    data['sunmi_device'] = sunmiDevice;
    return data;
  }

  UserSettings toEntity() => UserSettings(
        userId: userId.orZero(),
        orderNotificationEnabled: orderNotificationEnabled ?? true,
        sunmiDevice: sunmiDevice ?? false,
      );
}
