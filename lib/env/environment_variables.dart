import 'package:klikit/app/extensions.dart';

class EnvironmentVariables {
  String baseUrl;
  String cdnUrl;
  String segmentWriteKey;
  String slackUrl;

  EnvironmentVariables({
    required this.baseUrl,
    required this.cdnUrl,
    required this.segmentWriteKey,
    required this.slackUrl,
  });
}

class EnvironmentVariablesModel {
  String? baseUrl;
  String? cdnUrl;
  String? segmentWriteKey;
  String? slackUrl;

  EnvironmentVariablesModel({this.baseUrl, this.cdnUrl, this.segmentWriteKey});

  EnvironmentVariablesModel.fromJson(Map<String, dynamic> json) {
    baseUrl = json['base_url'];
    cdnUrl = json['cdn_url'];
    segmentWriteKey = json['segment_write_key'];
    slackUrl = json['slack_url'];
  }

  EnvironmentVariables toEntity() => EnvironmentVariables(
        baseUrl: baseUrl.orEmpty(),
        cdnUrl: cdnUrl.orEmpty(),
        segmentWriteKey: segmentWriteKey.orEmpty(),
        slackUrl: slackUrl.orEmpty(),
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
