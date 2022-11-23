import 'dart:convert';

import 'package:klikit/notification/notification_data.dart';

class NotificationDataHandler{
  static final NotificationDataHandler _instance = NotificationDataHandler._internal();
  factory NotificationDataHandler(){
    return _instance;
  }
  NotificationDataHandler._internal();

  String convertMapToString(Map<String,dynamic> data){
    return jsonEncode(data);
  }

  Map<String,dynamic>  convertStringToMap(String data){
    return jsonDecode(data);
  }

  NotificationData getNotificationData(Map<String,dynamic> data){
    return NotificationData.fromJson(data);
  }

}