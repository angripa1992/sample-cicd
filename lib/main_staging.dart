import 'package:klikit/environment_variables.dart';
import 'package:klikit/main.dart';

void main() {
  final environmentVariables = EnvironmentVariables(
    // baseUrl: 'https://api-qa.shadowchef.co',
    //  cdnUrl: 'https://cdn-qa.shadowchef.co',
    baseUrl: 'https://gateway-enterprise.klikit.io',
    cdnUrl: 'https://assets.klikit.io',
  );
  mainCommon(environmentVariables);
}