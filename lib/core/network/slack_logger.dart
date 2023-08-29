import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/provider/device_information_provider.dart';
import 'package:klikit/env/environment_variables.dart';
import 'package:slack_logger/slack_logger.dart';

import '../../app/di.dart';

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
    if (!kReleaseMode || error.response == null) {
      return;
    }
    final deviceInfo = getIt.get<DeviceInfoProvider>();
    final user = SessionManager().user();
    List<String> markdownMessageList = [
      "CREATED AT: ${DateTime.now().toLocal().toString()}",
      'Url: ${error.requestOptions.baseUrl}${error.requestOptions.path}',
      'Status Code: ${error.response?.statusCode?.toString()}',
      'Response: ${error.response?.toString()}',
      'Params: ${error.requestOptions.queryParameters}',
      "********** BUSINESS **********",
      "Branch: ${user.branchName} (${user.branchId})",
      "Brand: ${user.brandName} (${user.branchId})",
      "Business: ${user.businessName} (${user.businessId})",
      "********** METADATA **********",
      "Version: ${await deviceInfo.versionName()}",
      "Package: ${await deviceInfo.packageName()}",
      "OS: ${await deviceInfo.getOsVersion()}",
      "Device: ${await deviceInfo.getDeviceModel()}",
    ];
    SlackLogger.instance.sendMarkdownAsAttachment(
      markdownMessageList: markdownMessageList,
      color: "#FF0000",
    );
  }
}
