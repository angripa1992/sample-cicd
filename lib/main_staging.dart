import 'package:klikit/env/environment_variables.dart';
import 'package:klikit/main.dart';

void main() {
  final environmentVariables = EnvironmentVariables(
    baseUrl: 'https://api-qa.shadowchef.co',
    cdnUrl: 'https://cdn-qa.shadowchef.co',
    consumerUrl: 'https://consumer.dev.shadowchef.co',
    segmentWriteKey: 'djROSUJqa21nc2dKUUJTOUJGaWU3ckFsZHIwM01nSGg=',
    slackUrl: 'https://hooks.slack.com/services/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',
    zohoAppKey: 'FlIXMZG3VUtYzlN8MUemAXC8RKrBKQds1Er4rWZQvv5GPkjAZYzxQ9OtSvBx7ai6',
    zohoAppAccessKey: 'Bb4BMRwMkXxb0xiK51IrfVDBXngyqVP07gWLRP54XhSACzcKVaDd47isUNyi6L456fRkg%2BQnMmmgACtXYjw61SCASk1cMZAB7xW4NBovvWUIRxvXqHdYyyxtI%2FrBT97g',
  );
  mainCommon(environmentVariables);
}
