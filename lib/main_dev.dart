import 'package:klikit/env/environment_variables.dart';
import 'package:klikit/main.dart';

void main() async {
  final environmentVariables = EnvironmentVariables(
    baseUrl: 'https://api.dev.shadowchef.co',
    cdnUrl: 'https://cdn.dev.shadowchef.co',
    segmentWriteKey: 'alQxTlFDYkl3TklCS2NiTll2UlNmTUhDTGs2dmxoRDQ=',
    slackUrl: 'https://hooks.slack.com/services/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',
    zohoAppKey: 'FlIXMZG3VUtYzlN8MUemAXC8RKrBKQds1Er4rWZQvv5GPkjAZYzxQ9OtSvBx7ai6',
    zohoAppAccessKey: 'Bb4BMRwMkXxb0xiK51IrfVDBXngyqVP07gWLRP54XhSACzcKVaDd47isUNyi6L456fRkg%2BQnMmmgACtXYjw61SCASk1cMZAB7xW4NBovvWUIRxvXqHdYyyxtI%2FrBT97g',
  );
  mainCommon(environmentVariables);
}
