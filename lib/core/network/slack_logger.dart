import 'package:dio/dio.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/provider/device_information_provider.dart';
import 'package:slack_logger/slack_logger.dart';

import '../../app/di.dart';
import '../provider/date_time_provider.dart';

class SlackLoggerResolver {
  static final _instance = SlackLoggerResolver._internal();

  factory SlackLoggerResolver() => _instance;

  SlackLoggerResolver._internal();

  void initLogger() {
    SlackLogger(
      webhookUrl:
          'https://hooks.slack.com/services/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',
    );
  }

  void sendApiError(DioError error) async {
    List<String> markdownMessageList = await _metadata();
    markdownMessageList.addAll(
      [
        "*API ERROR*",
        'BASE URL: ${error.requestOptions.baseUrl}',
        'PATH: ${error.requestOptions.path}',
        'PARAMS: ${error.requestOptions.queryParameters}',
        'STATUS CODE: ${error.response?.statusCode?.toString()}',
        'BODY: ${error.response?.toString()}',
      ],
    );
    SlackLogger.instance.sendMarkdownAsAttachment(
      markdownMessageList: markdownMessageList,
      color: "#FF0000",
    );
  }

  Future<List<String>> _metadata() async {
    final user = SessionManager().currentUser();
    final deviceInfo = getIt.get<DeviceInfoProvider>();
    return [
      "*METADATA*",
      "CREATED AT: ${DateTimeProvider.currentDateTime()}",
      "BRANCH: ${user.branchName} (${user.branchId})",
      "BRAND: ${user.brandName} (${user.branchId})",
      "BUSINESS: ${user.businessName} (${user.businessId})",
      "VERSION: ${await deviceInfo.versionName()}",
      "PACKAGE: ${await deviceInfo.packageName()}",
      "OS: ${await deviceInfo.getOsVersion()}",
      "DEVICE: ${await deviceInfo.getDeviceModel()}",
    ];
  }
}
