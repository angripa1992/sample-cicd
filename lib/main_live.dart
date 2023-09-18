import 'package:klikit/env/environment_variables.dart';
import 'package:klikit/main.dart';

void main() {
  final environmentVariables = EnvironmentVariables(
    baseUrl: 'https://gateway-enterprise.klikit.io',
    cdnUrl: 'https://assets.klikit.io',
    segmentWriteKey: 'Sm10a3NTc2lnUjJVMXpBb05JalNJZk4wQjU1SWxyZWg=',
    slackUrl: 'https://hooks.slack.com/services/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',
    zohoAppKey: 'FlIXMZG3VUtYzlN8MUemAXC8RKrBKQds1Er4rWZQvv5GPkjAZYzxQ9OtSvBx7ai6',
    zohoAppAccessKey: 'Bb4BMRwMkXxb0xiK51IrfVDBXngyqVP07gWLRP54XhSACzcKVaDd47isUNyi6L456fRkg%2BQnMmmgACtXYjw61SCASk1cMZAB7xW4NBovvWUIRxvXqHdYyyxtI%2FrBT97g',
  );
  mainCommon(environmentVariables);
}
