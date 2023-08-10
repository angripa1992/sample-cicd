import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/provider/device_information_provider.dart';
import 'package:klikit/env/environment_variables.dart';
import 'package:slack_logger/slack_logger.dart';

import '../../app/di.dart';
import '../provider/date_time_provider.dart';

class SlackLoggerResolver {
  static final _instance = SlackLoggerResolver._internal();

  factory SlackLoggerResolver() => _instance;

  SlackLoggerResolver._internal();

  void initLogger() {
    SlackLogger(
      webhookUrl: getIt.get<EnvironmentVariables>().slackUrl,
    );
  }

  void sendApiError(DioException error) async {
    if(!kReleaseMode){
      return;
    }
    List<String> metadata = await _metadata();
    List<String> business = await _businessInfo();
    List<String> markdownMessageList = [];
    markdownMessageList.addAll(metadata);
    markdownMessageList.addAll(business);
    markdownMessageList.addAll(
      [
        "********** API ERROR **********",
        'Url: ${error.requestOptions.baseUrl}${error.requestOptions.path}',
        'Params: ${error.requestOptions.queryParameters}',
        'Status Code: ${error.response?.statusCode?.toString()}',
        'Response: ${error.response?.toString()}',
      ],
    );
    SlackLogger.instance.sendMarkdownAsAttachment(
      markdownMessageList: markdownMessageList,
      color: "#FF0000",
    );
  }

  Future<List<String>> _metadata() async {
    final deviceInfo = getIt.get<DeviceInfoProvider>();
    return [
      "CREATED AT: ${DateTimeProvider.currentDateTime()}",
      "********** METADATA **********",
      "Version: ${await deviceInfo.versionName()}",
      "Package: ${await deviceInfo.packageName()}",
      "OS: ${await deviceInfo.getOsVersion()}",
      "Device: ${await deviceInfo.getDeviceModel()}",
    ];
  }

  Future<List<String>> _businessInfo() async {
    final user = SessionManager().user();
    return [
      "********** BUSINESS **********",
      "Branch: ${user.branchName} (${user.branchId})",
      "Brand: ${user.brandName} (${user.branchId})",
      "Business: ${user.businessName} (${user.businessId})",
    ];
  }
}
