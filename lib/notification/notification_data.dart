import 'package:json_annotation/json_annotation.dart';

part 'notification_data.g.dart';

@JsonSerializable()
class NotificationData{
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'order_id')
  final String orderId;
  @JsonKey(name: 'url')
  final String providerUrl;

  NotificationData(this.type, this.title, this.message, this.orderId, this.providerUrl);

  factory NotificationData.fromJson(Map<String,dynamic> json) => _$NotificationDataFromJson(json);
}