import 'package:klikit/environment_variables.dart';
import 'package:klikit/main.dart';

void main() {
  final environmentVariables = EnvironmentVariables(
    baseUrl: 'https://api-qa.shadowchef.co/v1',
    cdnUrl: 'https://cdn-qa.shadowchef.co',
  );
  mainCommon(environmentVariables);
}