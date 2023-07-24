import 'package:klikit/app/extensions.dart';

class EnvironmentVariables {
  final String baseUrl;
  final String cdnUrl;
  final String segmentWriteKey;

  EnvironmentVariables({
    required this.baseUrl,
    required this.cdnUrl,
    required this.segmentWriteKey,
  });
}

class EnvironmentVariablesModel {
  String? baseUrl;
  String? cdnUrl;
  String? segmentWriteKey;

  EnvironmentVariablesModel({this.baseUrl, this.cdnUrl, this.segmentWriteKey});

  EnvironmentVariablesModel.fromJson(Map<String, dynamic> json) {
    baseUrl = json['base_url'];
    cdnUrl = json['cdn_url'];
    segmentWriteKey = json['segment_write_key'];
  }

  EnvironmentVariables toEntity() => EnvironmentVariables(
        baseUrl: baseUrl.orEmpty(),
        cdnUrl: cdnUrl.orEmpty(),
        segmentWriteKey: segmentWriteKey.orEmpty(),
      );
}
