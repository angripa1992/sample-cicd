// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) =>
    NotificationData(
      json['type'] as String,
      json['title'] as String,
      json['message'] as String,
      json['order_id'] as String,
      json['url'] as String,
    );

Map<String, dynamic> _$NotificationDataToJson(NotificationData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'order_id': instance.orderId,
      'url': instance.providerUrl,
    };
