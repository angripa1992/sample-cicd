import 'package:klikit/app/enums.dart';
import 'package:klikit/env/environment_variables.dart';
import 'package:klikit/main.dart';

void main() async {
  final environmentVariables = EnvironmentVariables(
    baseUrl: 'https://api.dev.shadowchef.co',
    cdnUrl: 'https://cdn.dev.shadowchef.co',
    segmentWriteKey: 'alQxTlFDYkl3TklCS2NiTll2UlNmTUhDTGs2dmxoRDQ=',
    slackUrl: 'https://hooks.slack.com/services/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',
  );
  mainCommon(environmentVariables);
}
