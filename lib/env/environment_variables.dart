import 'package:klikit/app/extensions.dart';

class EnvironmentVariables {
  String baseUrl;
  String cdnUrl;
  String consumerUrl;
  String segmentWriteKey;
  String slackUrl;
  String zohoAppKey;
  String zohoAppAccessKey;
  String socketUrl;

  EnvironmentVariables({
    required this.baseUrl,
    required this.cdnUrl,
    required this.consumerUrl,
    required this.segmentWriteKey,
    required this.slackUrl,
    required this.zohoAppKey,
    required this.zohoAppAccessKey,
    required this.socketUrl,
  });
}

class EnvironmentVariablesModel {
  String? baseUrl;
  String? cdnUrl;
  String? consumerUrl;
  String? segmentWriteKey;
  String? slackUrl;
  String? zohoAppKey;
  String? zohoAppAccessKey;
  String? socketUrl;

  EnvironmentVariablesModel({
    this.baseUrl,
    this.cdnUrl,
    this.consumerUrl,
    this.slackUrl,
    this.segmentWriteKey,
    this.zohoAppKey,
    this.zohoAppAccessKey,
  });

  EnvironmentVariablesModel.fromJson(Map<String, dynamic> json) {
    baseUrl = json['base_url'];
    cdnUrl = json['cdn_url'];
    consumerUrl = json['consumer_url'];
    segmentWriteKey = json['segment_write_key'];
    slackUrl = json['slack_url'];
    zohoAppKey = json['zoho_app_key'];
    zohoAppAccessKey = json['zoho_app_access_key'];
  }

  EnvironmentVariables toEntity() => EnvironmentVariables(
        baseUrl: baseUrl.orEmpty(),
        cdnUrl: cdnUrl.orEmpty(),
        segmentWriteKey: segmentWriteKey.orEmpty(),
        slackUrl: slackUrl.orEmpty(),
        zohoAppKey: zohoAppKey.orEmpty(),
        zohoAppAccessKey: zohoAppAccessKey.orEmpty(),
        consumerUrl: consumerUrl.orEmpty(),
        socketUrl: socketUrl.orEmpty()
      );
}

class EnvRemoteUrls {
  EnvUrls? urls;

  EnvRemoteUrls({this.urls});

  EnvRemoteUrls.fromJson(Map<String, dynamic> json) {
    urls = json['urls'] != null ? EnvUrls.fromJson(json['urls']) : null;
  }
}

class EnvUrls {
  String? baseUrl;
  String? cdnUrl;

  EnvUrls({this.baseUrl, this.cdnUrl});

  EnvUrls.fromJson(Map<String, dynamic> json) {
    baseUrl = json['base_url'];
    cdnUrl = json['cdn_url'];
  }
}
