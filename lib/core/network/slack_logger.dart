import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/network/error_handler.dart';
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
    if (!kReleaseMode || error.response == null || error.response?.statusCode == ResponseCode.UNAUTHORISED) {
      return;
    }
    final deviceInfo = getIt.get<DeviceInfoProvider>();
    List<String> markdownMessageList = [
      "CREATED AT: ${DateTime.now().toLocal().toString()}",
      'Url: ${error.requestOptions.baseUrl}${error.requestOptions.path}',
      'Status Code: ${error.response?.statusCode?.toString()}',
      'Response: ${error.response?.toString()}',
      'Params: ${json.encode(error.requestOptions.queryParameters)}',
      "********** BUSINESS **********",
      "Branch: ${SessionManager().branchName()} (${SessionManager().branchId()})",
      "Brand: ${SessionManager().brandIDs().join(', ')}",
      "Business: ${SessionManager().businessID()} (${SessionManager().businessID()})",
      "********** METADATA **********",
      "Version: ${await deviceInfo.versionName()}",
      "Package: ${await deviceInfo.packageName()}",
      "OS: ${await deviceInfo.getOsVersion()}",
      "Device: ${await deviceInfo.getDeviceModel()}",
    ];
    SlackLogger.instance.sendMarkdownAsAttachment(markdownMessageList: markdownMessageList, color: "#FF0000");
  }
}
