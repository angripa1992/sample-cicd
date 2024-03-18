import 'package:klikit/env/environment_variables.dart';
import 'package:klikit/main.dart';

void main() {
  final environmentVariables = EnvironmentVariables(
    baseUrl: 'https://gateway-enterprise.klikit.io',
    cdnUrl: 'https://assets.klikit.io',
    consumerUrl: 'https://gateway-consumer.klikit.io',
    segmentWriteKey: 'Sm10a3NTc2lnUjJVMXpBb05JalNJZk4wQjU1SWxyZWg=',
    slackUrl: 'https://hooks.slack.com/services/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',
    zohoAppKey: 'FlIXMZG3VUtYzlN8MUemAXC8RKrBKQds1Er4rWZQvv5GPkjAZYzxQ9OtSvBx7ai6',
    zohoAppAccessKey: 'Bb4BMRwMkXxBKGFkNe1LRWqvRXiEDBUt9Be8Bk4fHQOQyZ7keYD1aOzmuP7no%2FnSuJ1sca1DaTd2pnChL3dnO0FQ4U%2F%2Bql%2FXIBR%2FPoqHM2M1Evqlj6Socw%3D%3D',
    socketUrl: 'wss://connect.klikit.io'
  );
  mainCommon(environmentVariables);
}
