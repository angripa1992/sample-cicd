import 'package:klikit/env/environment_variables.dart';
import 'package:klikit/main.dart';

void main() {
  final environmentVariables = EnvironmentVariables(
    baseUrl: 'https://api-qa.shadowchef.co',
    cdnUrl: 'https://cdn-qa.shadowchef.co',
    segmentWriteKey: 'djROSUJqa21nc2dKUUJTOUJGaWU3ckFsZHIwM01nSGg=',
    slackUrl:
        'https://hooks.slack.com/services/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',
  );
  mainCommon(environmentVariables);
}
