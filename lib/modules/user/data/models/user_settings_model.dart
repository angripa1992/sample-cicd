import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';

import '../../domain/entities/user_settings.dart';

class UserSettingsModel {
  int? userId;
  bool? orderNotificationEnabled;
  int? printingDeviceId;

  UserSettingsModel({
    this.userId,
    this.orderNotificationEnabled,
    this.printingDeviceId,
  });

  UserSettingsModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    orderNotificationEnabled = json['order_notification_enabled'];
    printingDeviceId = json['printing_device_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['order_notification_enabled'] = orderNotificationEnabled;
    data['printing_device_id'] = printingDeviceId;
    return data;
  }

  UserSettings toEntity() => UserSettings(
        userId: userId.orZero(),
        orderNotificationEnabled: orderNotificationEnabled ?? true,
        printingDeviceID: printingDeviceId ?? Device.android,
      );
}
